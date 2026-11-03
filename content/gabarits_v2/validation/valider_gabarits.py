#!/usr/bin/env python3
"""Valide les 30 templates, le socle et les 435 comparaisons de signature."""
import json, re, sys
from pathlib import Path
from difflib import SequenceMatcher
ROOT=Path(__file__).resolve().parents[1]
SECTORS=['vetements_mode','coiffure_beaute','restaurants_maquis','batiment_travaux','immo_auto','shops_small_business']
FORMATS=['T1','T2','T3','T4','T5']
COMPUTED={'pourcentage'}

def load(p): return json.loads(p.read_text(encoding='utf-8'))
def ids(s,k): return {x['id'] for x in s.get(k,[]) if isinstance(x,dict) and 'id' in x}
def sim(a,b): return SequenceMatcher(None,a,b,autojunk=False).ratio()
WORD_RE=re.compile(r"\{[A-Za-z_][A-Za-z0-9_]*\}|[A-Za-zÀ-ÖØ-öø-ÿ0-9]+(?:['’][A-Za-zÀ-ÖØ-öø-ÿ]+)?")
def word_count(text): return len(WORD_RE.findall(text or ''))
def sentence_count(text): return len([x for x in re.split(r'[.!?]+', (text or '').strip()) if x.strip()])
def norm_text(text): return re.sub(r'\s+',' ',(text or '').strip().casefold())
def idlist(values, valid, label, where, errors):
 for x in values:
  if x and x not in valid: errors.append(f'{where}: ID {label} inconnu: {x}')
def all_strings(value):
 if isinstance(value,dict):
  for v in value.values():yield from all_strings(v)
 elif isinstance(value,list):
  for v in value:yield from all_strings(v)
 elif isinstance(value,str):yield value

def pair_axes(a,b):
 aa=a['axes_signature']; bb=b['axes_signature']
 return {
  'séquence rôles':aa['sequence_roles']!=bb['sequence_roles'],
  'nombre scènes':aa['nombre_scenes']!=bb['nombre_scenes'],
  'courbe rythme':aa['courbe_rythme']!=bb['courbe_rythme'],
  'transitions/placement':aa['transitions']!=bb['transitions'],
  'effets/placement':aa['effets']!=bb['effets'],
  'découpage prises':aa['decoupage_prises']!=bb['decoupage_prises'],
  'cartes générées/position':aa['cartes_generees']!=bb['cartes_generees'],
  'animation + position texte':aa['texte_animation_position']!=bb['texte_animation_position'],
  'étalonnage':aa['preset_etalonnage']!=bb['preset_etalonnage'],
  'structure audio':aa['structure_audio']!=bb['structure_audio']}

def main():
 errors=[]; dlist=[]; checked=[]; guide_stats={}
 try:soc=load(ROOT/'universel/socle_universel.json')
 except Exception as e: print('Socle invalide:',e);return 1
 theme_ids={x.get('id') for x in soc.get('themes_parole',[]) if isinstance(x,dict)}
 expected_themes={'accroche','presenter_offre','parler_interet','detail_qualite','parler_prix','urgence_reelle','donner_adresse_contact','inviter_a_venir','remercier','question_client','ressenti_client','aucune'}
 if theme_ids!=expected_themes:errors.append(f'themes_parole absents/inattendus: {expected_themes^theme_ids}')
 schema=soc.get('schema_guide_parole',{})
 rules=soc.get('regles_guide_parole',{})
 if not {'parole_active','duree_parole_s','duree_affichee_s','idee','quoi_raconter','quoi_montrer','exemple','exemple_langue_libre','theme','conseil','cles'}.issubset(set(schema.get('champs_requis',[]))):errors.append('Schéma guide_parole incomplet dans le socle')
 if not {'quoi_raconter','quoi_montrer','duree_cible_s','duree_affichee_s','segment_audio_id'}.issubset(set(schema.get('capture_scene_parlee',{}))):errors.append('Capture parlée doit nommer le sujet dit, le visuel, la durée et le segment audio')
 if rules.get('duree_conseillee_peut_depasse_duree_scene') is not True or rules.get('arret_force_par_temps_conseille') is not False:errors.append('Le temps de parole est un repère non coupant; la voix peut continuer sur l’image suivante')
 if rules.get('idee_max_mots')!=25 or rules.get('idee_min_phrases')!=1 or rules.get('idee_max_phrases')!=2 or rules.get('exemple_min_phrases')!=1 or rules.get('exemple_max_phrases')!=1 or rules.get('exemple_max_mots')!=20 or rules.get('debit_exemple_mots_par_seconde')!=2.5 or rules.get('tolerance_debit_pct')!=20:errors.append('Règles de longueur/débit guide_parole incorrectes')
 try:
  menu=load(ROOT/'universel/formats_affichage.json')
  names=[x.get('nom') for x in menu.get('choix',[])]
  expected_names=['Nouvel arrivage','Avant et après','Montrer un produit','Promotion','Un client raconte']
  if names!=expected_names:errors.append('Le menu commerçant doit afficher les cinq noms simples attendus')
  if re.search(r'\bT[1-5]\b',json.dumps(menu,ensure_ascii=False)):errors.append('Un code T1–T5 est visible dans le menu commerçant')
  for rel in ['guide_commercant_facile.md','exemple_parcours_commercant.md']:
   text=(ROOT/rel).read_text(encoding='utf-8').lower()
   if any(word.lower() in text for word in ['montage','gabarit','recadrage','transition','b-roll','vad','lufs','bpm','rush']):errors.append(f'{rel}: terme technique ou interne dans le document commerçant')
 except Exception as e:errors.append(f'Menu ou guide commerçant invalide: {e}')
 pack_langues=['fr','en','es','ja','fon','yoruba']; packs={}
 try:
  for lang in pack_langues:packs[lang]=load(ROOT/'packs_langue'/f'{lang}.json')
  keysets={lang:set(pack.get('traductions',{})) for lang,pack in packs.items()}
  if len({frozenset(x) for x in keysets.values()})!=1:errors.append('Les packs de langue ne possèdent pas la même liste de clés')
  if packs['fr'].get('statut')!='complet' or any(not isinstance(v,str) or not v for v in packs['fr'].get('traductions',{}).values()):errors.append('Le pack fr doit être complet et contenir tous les textes')
  if any(packs[x].get('statut')!='a_traduire' for x in pack_langues if x!='fr'):errors.append('Les packs en/es/ja/fon/yoruba doivent rester marqués a_traduire')
  if any(v is not None for x in pack_langues if x!='fr' for v in packs[x].get('traductions',{}).values()):errors.append('Une traduction non validée a été inventée dans un pack a_traduire')
  if 'guide.commun.exemple_langue_libre' not in keysets.get('fr',set()):errors.append('Clé commune exemple_langue_libre absente du pack fr')
 except Exception as e:errors.append(f'Packs de langue manquants ou invalides: {e}')
 try:
  strategy=load(ROOT/'universel/strategie_langues_locales.json').get('guide_parole',{})
  if not all(strategy.get(k) for k in ['langue_du_guide','langue_de_la_voix','langue_des_textes_a_ecran','sous_titres_de_voix','mode_sans_voix']):errors.append('La stratégie langue ne décrit pas le guide, la voix, l’écran, les sous-titres et le mode sans voix')
 except Exception as e:errors.append(f'Stratégie de langues invalide: {e}')
 files=sorted((ROOT/'gabarits').glob('*/*.json'))
 if len(files)!=30:errors.append(f'30 gabarits requis; trouvés {len(files)}')
 top_keysets=[]
 expected_sectors=set(SECTORS)
 if {p.parent.name for p in files}!=expected_sectors:errors.append('Secteurs absents/inattendus')
 valid={'transition_sortie':ids(soc,'transitions'),'effet':ids(soc,'effets'),'animation':ids(soc,'animations_texte'),'sfx':ids(soc,'sfx_categories'),'preset':ids(soc,'presets_etalonnage'),'typo':ids(soc,'presets_typographiques'),'palette':ids(soc,'palettes'),'badge':ids(soc,'badges'),'card':ids(soc,'cartes_generees'),'audio_cat':ids(soc,'categories_audio_musique'),'audio_structure':ids(soc,'structures_audio')}
 for p in files:
  rel=str(p.relative_to(ROOT))
  try:d=load(p)
  except Exception as e:errors.append(f'{rel}: JSON invalide: {e}');continue
  for text in all_strings(d):
   if re.search(r'\b(?:tu|ton|ta|tes|toi|te)\b',text,re.I):errors.append(f'{rel}: tutoiement restant dans un texte: {text[:100]}')
   if re.search(r'\bvous\s+(?:proposes|n’es|n\'es|changes|l’as|en as|ranges|dresses|filmes)\b',text,re.I):errors.append(f'{rel}: conjugaison à corriger dans un texte avec vous: {text[:100]}')
  top_keysets.append(frozenset(d.keys()))
  sector=p.parent.name; code=p.stem; scenes=d.get('scenes',[]); takes=d.get('prises',[]); fields=d.get('champs_saisie',[]); fmap={x.get('id'):x for x in fields}
  iface=d.get('interface_commercant',{})
  expected_display={'T1':'Nouvel arrivage','T2':'Avant et après','T3':'Montrer un produit','T4':'Promotion','T5':'Un client raconte'}
  if iface.get('nom_format')!=expected_display.get(code) or not iface.get('visible'):errors.append(f'{rel}: nom simple du gabarit absent de l’interface')
  if 'format' not in iface.get('ne_pas_afficher_cles_internes',[]):errors.append(f'{rel}: le code interne format doit rester caché au commerçant')
  if sector not in SECTORS or code not in FORMATS:errors.append(f'{rel}: secteur/format invalide')
  if d.get('secteur')!=sector or not d.get('format','').startswith(code):errors.append(f'{rel}: chemin et identifiants secteur/format incohérents')
  if not 30<=d.get('duree_totale_secondes',0)<=60:errors.append(f'{rel}: durée totale hors 30–60 s')
  if d.get('nombre_scenes')!=len(scenes) or not 10<=len(scenes)<=18:errors.append(f'{rel}: nombre_scenes invalide ({len(scenes)})')
  if not 2<=len(takes)<=4:errors.append(f'{rel}: prises hors limites 2–4')
  if any(not 8<=float(t.get('duree_cible_s',0))<=20 for t in takes):errors.append(f'{rel}: chaque prise doit viser 8–20 secondes')
  if abs(sum(float(s.get('duree_secondes',0)) for s in scenes)-d.get('duree_totale_secondes',0))>0.01:errors.append(f'{rel}: somme durées scènes incorrecte')
  if not scenes or scenes[0].get('acte')!='hook' or scenes[0].get('duree_secondes',99)>3:errors.append(f'{rel}: hook absent ou >3s')
  if scenes and scenes[0].get('source',{}).get('type')=='prise' and scenes[0]['source'].get('vitesse',1)>1:errors.append(f'{rel}: hook rush accéléré sans justification')
  if scenes and scenes[-1].get('duree_secondes',0)<4:errors.append(f'{rel}: CTA final <4s')
  for fid in ('nom_commerce','quartier_ville','whatsapp'):
   f=fmap.get(fid)
   if not f or f.get('obligatoire') is not True or f.get('source')!='saisie_video':errors.append(f'{rel}: champ obligatoire/source invalide: {fid}')
   elif '{'+fid+'}' not in scenes[-1].get('texte_ecran',{}).get('contenu',''):errors.append(f'{rel}: {fid} absent carte finale')
  if 'prix' not in fmap or fmap['prix'].get('obligatoire')!=(code!='T5'):errors.append(f'{rel}: règle prix obligatoire/optionnel incorrecte')
  if any(f.get('source')!='saisie_video' for f in fields):errors.append(f'{rel}: un champ source n’est pas saisie_video')
  if not d.get('politique_saisie',{}).get('recollecter_a_chaque_video') or d['politique_saisie'].get('enregistrer_dans_profil') is not False:errors.append(f'{rel}: règle de saisie par vidéo/profil invalide')
  ui=d.get('formulaire_ui',{}); groups=ui.get('sections_principales',[])
  if not 4<=len(groups)<=5 or ui.get('nombre_sections_principales')!=len(groups):errors.append(f'{rel}: formulaire UI doit avoir 4–5 sections principales')
  grouped=[fid for g in groups for fid in g.get('champs',[])]
  main_input={f['id'] for f in fields if f['id']!='badge_engagement_actif'}
  if set(grouped)!=main_input or len(grouped)!=len(set(grouped)):errors.append(f'{rel}: formulaire UI ne groupe pas exactement les champs de saisie principaux')
  if 'badge_engagement_actif' not in ui.get('options_facultatives_repliees',{}).get('champs',[]):errors.append(f'{rel}: badge facultatif non masqué par défaut')
  guide=d.get('guide_tournage',{})
  if guide.get('nombre_prises_a_filmer')!=len(takes) or len(guide.get('etapes_capture',[]))!=len(takes) or not guide.get('pas_de_montage_manuel'):errors.append(f'{rel}: guide de capture ne correspond pas au nombre de prises')
  if not guide.get('le_commercant_ne_filme_pas_une_scene_par_etape_montage'):errors.append(f'{rel}: mention explicite des scènes moteur absente')
  scene_guide_surface=' '.join(' '.join(str(s.get('guide_parole',{}).get(k,'')) for k in ('idee','exemple','exemple_langue_libre','conseil'))+' '+s.get('texte_ecran',{}).get('contenu','')+' '+s.get('action_montage','') for s in scenes)
  global_guide_surface=' '.join(str(guide.get('guide_parole',{}).get(k,'')) for k in ('titre','introduction','langue','temps','pas_une_prise','sans_voix','sous_titres'))+' '+json.dumps(guide.get('sous_titres_voix',{}),ensure_ascii=False)
  surface=' '.join([iface.get('nom_format',''),iface.get('secteur',''),iface.get('phrase_courte',''),iface.get('promesse',''),d.get('notes_adaptation',''),ui.get('titre',''),ui.get('message',''),guide.get('titre',''),guide.get('message_principal',''),guide.get('note',''),global_guide_surface,d.get('audio',{}).get('interface_commercant',{}).get('genre_en_mots_simples',''),d.get('audio',{}).get('interface_commercant',{}).get('message',''),d.get('audio',{}).get('interface_commercant',{}).get('note','')]+[g.get('titre','')+' '+g.get('aide','') for g in ui.get('sections_principales',[])]+[ui.get('options_facultatives_repliees',{}).get('titre','')+' '+ui.get('options_facultatives_repliees',{}).get('aide','')]+[f.get('label','')+' '+f.get('aide_simple','') for f in fields]+[t.get('libelle','')+' '+t.get('consigne_camera','')+' '+t.get('astuce','') for t in takes]+[str(x) for x in guide.get('etapes_capture',[])]+[x.get('action','')+' '+x.get('voix','')+' '+x.get('audio','')+' '+x.get('texte','') for x in d.get('etapes_montage',[])]+[scene_guide_surface,json.dumps(d.get('copywriting',{}),ensure_ascii=False)])
  if re.search(r'\bT[1-5]\b',surface):errors.append(f'{rel}: code T1–T5 visible dans les consignes commerçant')
  jargon=['recadrage','VAD','LUFS','BPM','Media3','rush','cutaway','split-screen','whip-pan','montage','gabarit','transition','effet','gros plan','SFX']
  if any(word.lower() in surface.lower() for word in jargon):errors.append(f'{rel}: jargon de montage dans les consignes commerçant')
  guide_vars=' '.join(' '.join(str(s.get('guide_parole',{}).get(k,'')) for k in ('idee','exemple','exemple_langue_libre','conseil'))+' '+s.get('texte_ecran',{}).get('contenu','') for s in scenes)
  used=set(re.findall(r'\{([a-zA-Z_][a-zA-Z0-9_]*)\}',guide_vars+json.dumps(d.get('copywriting',{}),ensure_ascii=False)))
  if used-set(fmap)-COMPUTED:errors.append(f'{rel}: variables sans champ {sorted(used-set(fmap)-COMPUTED)}')
  speech_count=0; silent_count=0; speech_total=0.0; speech_themes=[]; ideas_seen=set(); examples_seen=set(); speech_time_by_take={}; speech_scenes_by_take={}; capture_orders={}
  expected_gp={'parole_active','duree_parole_s','duree_affichee_s','idee','quoi_raconter','quoi_montrer','exemple','exemple_langue_libre','theme','conseil','cles'}
  for si,sc in enumerate(scenes,1):
   gp=sc.get('guide_parole')
   if not isinstance(gp,dict) or not expected_gp.issubset(gp):
    errors.append(f'{rel}: scène {si} guide_parole absent ou incomplet');continue
   active=bool(gp.get('parole_active'))
   if active!=bool(sc.get('voix',{}).get('active')):errors.append(f'{rel}: scène {si} parole_active non aligné avec voix.active')
   duration=float(gp.get('duree_parole_s',-1))
   if duration<0 or duration>20:errors.append(f'{rel}: durée de parole conseillée hors limites d’une prise')
   if active:
    speech_count+=1;speech_total+=duration;speech_themes.append(gp.get('theme'))
    capture=gp.get('capture',{});voice=sc.get('voix',{});src=sc.get('source',{})
    if not isinstance(capture,dict) or not {'prise_id','ordre_dans_la_prise','segment_audio_id','marqueur_de_segment','duree_cible_s','duree_affichee_s','audio_separe_de_image','vitesse_voix','quoi_montrer','quoi_raconter'}.issubset(capture):errors.append(f'{rel}: scène {si} consigne parlée sans lien de prise/segment audio ou de visuel')
    if not gp.get('quoi_montrer') or not gp.get('quoi_raconter'):errors.append(f'{rel}: scène {si} doit séparer clairement quoi montrer et quoi raconter')
    if isinstance(capture,dict) and (not capture.get('quoi_montrer') or not capture.get('quoi_raconter')):errors.append(f'{rel}: scène {si} consigne capture sans sujet visuel/oral')
    else:
     take_id=capture.get('prise_id');take_ids_now={t.get('id') for t in takes}
     if take_id not in take_ids_now:errors.append(f'{rel}: scène {si} voix reliée à une prise inconnue')
     if src.get('type')=='prise' and take_id!=src.get('prise_id'):errors.append(f'{rel}: scène {si} voix doit rester liée à la prise de son image')
     if voice.get('source_audio_prise_id')!=take_id or voice.get('segment_audio_id')!=capture.get('segment_audio_id'):errors.append(f'{rel}: scène {si} source audio voix non alignée')
     if capture.get('marqueur_de_segment')!='bouton_suivant' or capture.get('audio_separe_de_image') is not True or capture.get('vitesse_voix')!=1.0:errors.append(f'{rel}: scène {si} marqueur ou traitement voix incorrect')
     if capture.get('duree_cible_s')!=duration or capture.get('duree_affichee_s')!=round(duration,1) or gp.get('duree_affichee_s')!=round(duration,1) or not 0<=capture.get('tolerance_debit_pct',-1)<=20 or capture.get('arret_force') is not False:errors.append(f'{rel}: durée voix affichée ou règle sans coupure forcée incorrecte')
     order_key=(take_id,capture.get('ordre_dans_la_prise'))
     if order_key in capture_orders:errors.append(f'{rel}: ordre de consigne voix répété dans la prise {take_id}')
     capture_orders[order_key]=si
     speech_time_by_take[take_id]=speech_time_by_take.get(take_id,0)+duration
     speech_scenes_by_take.setdefault(take_id,[]).append(si)
    idea=gp.get('idee','');example=gp.get('exemple','');langhint=gp.get('exemple_langue_libre','');advice=gp.get('conseil','');theme=gp.get('theme')
    if not 1<=word_count(idea)<=25:errors.append(f'{rel}: scène {si} idée doit contenir 1–25 mots')
    if not 1<=sentence_count(idea)<=2:errors.append(f'{rel}: scène {si} idée doit faire 1–2 phrases')
    if not 1<=word_count(example)<=20:errors.append(f'{rel}: scène {si} exemple doit contenir 1–20 mots')
    if sentence_count(example)!=1:errors.append(f'{rel}: scène {si} exemple doit faire une seule phrase')
    if not langhint or not advice:errors.append(f'{rel}: scène {si} exemple_langue_libre/conseil absent')
    if duration<=0:errors.append(f'{rel}: scène {si} parole active sans durée positive')
    if word_count(example)>2.5*duration*1.2+0.001:errors.append(f'{rel}: scène {si} exemple trop long pour le temps de parole')
    if theme not in theme_ids:errors.append(f'{rel}: scène {si} thème parole inconnu: {theme}')
    ni=norm_text(idea); ne=norm_text(example)
    if ni in ideas_seen:errors.append(f'{rel}: idée de parole répétée dans le même gabarit')
    if ne in examples_seen:errors.append(f'{rel}: exemple de parole répété dans le même gabarit')
    ideas_seen.add(ni);examples_seen.add(ne)
    if code=='T5':
     if theme not in {'question_client','ressenti_client'}:errors.append(f'{rel}: scène T5 doit utiliser une question neutre ou un récit libre')
     forbidden=['excellent','excellente','meilleur','meilleure','parfait','parfaite','je recommande','recommande','recommandé','recommandée','satisfait','satisfaite','génial','géniale','super','incroyable','5 étoiles','cinq étoiles','éloge','compliment']
     t5text=' '.join([idea,example,advice]).casefold()
     if any(w in t5text for w in forbidden):errors.append(f'{rel}: guide client T5 contient un avis positif imposé')
    # All examples and ideas draw variables only from the merchant form.
    guide_vars_scene=' '.join([idea,example,langhint,advice])
    vars_scene=set(re.findall(r'\{([a-zA-Z_][a-zA-Z0-9_]*)\}',guide_vars_scene))
    if vars_scene-set(fmap)-COMPUTED:errors.append(f'{rel}: scène {si} variables guide sans champ {sorted(vars_scene-set(fmap)-COMPUTED)}')
    keys=gp.get('cles',{})
    for field in ('idee','quoi_raconter','quoi_montrer','exemple','exemple_langue_libre','conseil'):
     k=keys.get(field)
     if not k or k not in packs.get('fr',{}).get('traductions',{}):errors.append(f'{rel}: scène {si} clé pack fr absente pour {field}')
     elif packs['fr']['traductions'][k]!=gp.get(field,''):errors.append(f'{rel}: scène {si} texte {field} différent du pack fr')
   else:
    silent_count+=1
    if duration!=0 or gp.get('duree_affichee_s')!=0 or any(gp.get(k)!='' for k in ('idee','quoi_raconter','quoi_montrer','exemple','exemple_langue_libre','conseil')) or gp.get('theme')!='aucune' or gp.get('cles')!={}:errors.append(f'{rel}: scène {si} sans parole doit rester sans consigne orale ni exemple')
    if gp.get('capture') or sc.get('voix',{}).get('source_audio_prise_id') or sc.get('voix',{}).get('segment_audio_id'):errors.append(f'{rel}: scène {si} silencieuse ne doit pas avoir de segment de voix')
   if 'texte_guide' in sc.get('voix',{}):errors.append(f'{rel}: ancien voix.texte_guide encore présent')
   if si-1<len(d.get('etapes_montage',[])):
    stguide=d['etapes_montage'][si-1].get('guide_parole',{})
    if stguide.get('parole_active')!=active or stguide.get('theme')!=gp.get('theme') or stguide.get('duree_parole_s')!=gp.get('duree_parole_s'):errors.append(f'{rel}: guide parole de l’étape montage non aligné scène {si}')
  # The capture checklist, take-level segments, and scene references must agree exactly.
  if any(v>20.0 for v in speech_time_by_take.values()):errors.append(f'{rel}: les segments de parole dépassent 20 secondes dans une prise')
  capture_steps={x.get('prise_id'):x for x in guide.get('etapes_capture',[])}
  scene_by_num={x.get('numero'):x for x in scenes}
  for take in takes:
   tid=take.get('id');expected_scenes=speech_scenes_by_take.get(tid,[])
   if take.get('guide_parole_scenes',[])!=expected_scenes:errors.append(f'{rel}: scènes parlées mal regroupées dans {tid}')
   segments=take.get('segments_guide_parole',[])
   if [x.get('scene') for x in segments]!=expected_scenes:errors.append(f'{rel}: segments audio manquants/désordonnés dans {tid}')
   for segment_order,seg in enumerate(segments,1):
    sc_ref=scene_by_num.get(seg.get('scene'),{});g_ref=sc_ref.get('guide_parole',{});cap_ref=g_ref.get('capture',{})
    segscene=seg.get('scene')
    if cap_ref.get('ordre_dans_la_prise')!=segment_order or cap_ref.get('prise_id')!=tid:errors.append(f'{rel}: ordre ou prise du segment incorrect scène {segscene}')
    if seg.get('quoi_raconter')!=g_ref.get('quoi_raconter') or seg.get('quoi_montrer')!=g_ref.get('quoi_montrer') or seg.get('exemple')!=g_ref.get('exemple') or seg.get('duree_conseillee_s')!=g_ref.get('duree_affichee_s') or seg.get('segment_audio_id')!=cap_ref.get('segment_audio_id'):errors.append(f'{rel}: affichage guide/segment non aligné scène {segscene}')
   step=capture_steps.get(tid,{})
   if step.get('guide_parole_scenes',[])!=expected_scenes or step.get('guide_parole_segments',[])!=segments:errors.append(f'{rel}: guide visible pendant {tid} différent des segments audio liés')
   if sum(float(x.get('duree_conseillee_s',0)) for x in segments)>20.0:errors.append(f'{rel}: charge de parole trop longue dans {tid}')
  if len(capture_steps)!=len(takes):errors.append(f'{rel}: étapes de capture ne reprennent pas exactement les prises existantes')
  gpui=guide.get('guide_parole',{})
  for field in ('titre','introduction','langue','temps','pas_une_prise','sans_voix','sous_titres'):
   key=gpui.get('cles',{}).get(field)
   if not key or key not in packs.get('fr',{}).get('traductions',{}) or packs['fr']['traductions'].get(key)!=gpui.get(field):errors.append(f'{rel}: texte général guide parole non lié au pack fr ({field})')
  st=guide.get('sous_titres_voix',{})
  if st.get('sous_titres_automatiques') is not False or st.get('paroles_transcrites') is not False:errors.append(f'{rel}: la transcription automatique ne doit pas être revendiquée')
  for field in ('texte_ecran_actuel','voix_langue_locale'):
   key=st.get('cles',{}).get(field)
   if not key or key not in packs.get('fr',{}).get('traductions',{}):errors.append(f'{rel}: clé pack fr manquante pour sous_titres_voix.{field}')
  guide_stats[rel]={'parlees':speech_count,'silencieuses':silent_count,'temps_total':speech_total,'themes':speech_themes}
  takeids={x.get('id') for x in takes}
  if sector=='batiment_travaux' and code=='T2':
   expected_stage_map={'hook_site_avant':'prise_1','jalon_fondations':'prise_2','enduit_finition':'prise_3','plan_large_livraison_stabilise':'prise_4'}
   if len(takes)!=4:errors.append(f'{rel}: T2 chantier doit filmer avant, deux jalons et plan livré (4 prises)')
   rolemap={s.get('role'):s.get('source',{}).get('prise_id') for s in scenes}
   for role,tid in expected_stage_map.items():
    if rolemap.get(role)!=tid:errors.append(f'{rel}: jalon chantier {role} doit utiliser {tid}')
  if sector=='restaurants_maquis' and code=='T2':
   rolemap={s.get('role'):s.get('source',{}).get('prise_id') for s in scenes}
   for role,tid in {'hook_assiette_finale':'prise_4','ingredients_bruts_vue_haut':'prise_1','dressage_ordre_reel':'prise_3','reveal_assiette_fumante':'prise_4','hero_plat_ralenti':'prise_4'}.items():
    if rolemap.get(role)!=tid:errors.append(f'{rel}: scène culinaire {role} doit utiliser {tid}')
  if sector=='vetements_mode' and code=='T3':
   rolemap={s.get('role'):s.get('source',{}).get('prise_id') for s in scenes}
   for role,tid in {'indicateur_angle_un':'prise_1','indicateur_angle_deux':'prise_2','indicateur_angle_trois':'prise_3'}.items():
    if rolemap.get(role)!=tid:errors.append(f'{rel}: repère catalogue {role} doit suivre {tid}')
  for i,s in enumerate(scenes,1):
   src=s.get('source',{})
   if src.get('type')=='prise' and src.get('prise_id') not in takeids:errors.append(f'{rel}: scène {i} prise non définie')
   if src.get('carte_id'):idlist([src['carte_id']],valid['card'],'carte source',rel,errors)
   idlist([s.get('transition_sortie')],valid['transition_sortie'],'transition',rel,errors)
   idlist([s.get('effet')],valid['effet'],'effet',rel,errors)
   idlist([s.get('texte_ecran',{}).get('animation')],valid['animation'],'animation',rel,errors)
   idlist([s.get('sfx')],valid['sfx'],'SFX',rel,errors)
   idlist([s.get('carte_generee_id')],valid['card'],'carte',rel,errors)
   if s.get('etalonnage_scene') and s['etalonnage_scene'] not in valid['preset']:errors.append(f'{rel}: preset scène inconnu')
  et=d.get('etalonnage',{})
  for key in ('preset','preset_avant','preset_apres','preset_avant_ref','preset_apres_ref'):
   if et.get(key) and et[key] not in valid['preset']:errors.append(f'{rel}: étalonnage {key} inconnu')
  if et.get('protection_peau') is not True:errors.append(f'{rel}: protection peau obligatoire')
  st=d.get('style_visuel',{});idlist([st.get('typographie',{}).get('preset')],valid['typo'],'typo',rel,errors);idlist([st.get('palette')],valid['palette'],'palette',rel,errors);idlist(st.get('badges',[]),valid['badge'],'badge',rel,errors)
  if code=='T5' and st.get('badges'):errors.append(f'{rel}: T5 ne doit pas générer de badge de satisfaction/note')
  if code=='T5' and not fmap.get('accord_client_diffusion',{}).get('valeur_obligatoire'):errors.append(f'{rel}: consentement client T5 non obligatoire')
  aud=d.get('audio',{});mu=aud.get('musique',{});idlist([mu.get('categorie_audio')],valid['audio_cat'],'catégorie audio',rel,errors);idlist([mu.get('structure_id')],valid['audio_structure'],'structure audio',rel,errors)
  for sx in aud.get('sfx_scenes',[]):idlist([sx.get('categorie')],valid['sfx'],'SFX scène',rel,errors)
  if aud.get('mix',{}).get('cible_lufs')!=-14:errors.append(f'{rel}: cible audio non conforme')
  if not d.get('etapes_montage') or len(d['etapes_montage'])!=len(scenes):errors.append(f'{rel}: guide étape par étape incomplet')
  sig=d.get('signature_montage',{})
  required=('id_unique','famille_format','empreinte_sequence','courbe_rythme','justification_sectorielle')
  if any(not sig.get(k) for k in required):errors.append(f'{rel}: bloc signature_montage incomplet')
  else:
   if sig['famille_format']!=code or len(sig['empreinte_sequence'])!=len(scenes) or len(sig['courbe_rythme'])!=len(scenes):errors.append(f'{rel}: signature/empreinte/courbe dimensions incorrectes')
   if not 2<=len(sig['justification_sectorielle'].split('. '))<=5:errors.append(f'{rel}: justification sectorielle doit faire 2–4 phrases (approx)')
   if sig['courbe_rythme']!=[s['duree_secondes'] for s in scenes]:errors.append(f'{rel}: courbe de rythme non alignée sur scènes')
   for i,(fp,sc) in enumerate(zip(sig['empreinte_sequence'],scenes),1):
    parts=fp.split('|')
    if len(parts)!=3 or parts[0]!=sc.get('role') or parts[1]!=sc.get('transition_sortie') or parts[2]!=sc.get('effet'):errors.append(f'{rel}: empreinte scène {i} incohérente')
  axes=d.get('axes_signature',{})
  required_axes={'sequence_roles','nombre_scenes','courbe_rythme','transitions','effets','decoupage_prises','cartes_generees','texte_animation_position','preset_etalonnage','structure_audio'}
  if not required_axes.issubset(axes) or len(axes.get('sequence_roles',[]))!=len(scenes):errors.append(f'{rel}: axes_signature incomplet')
  if len(d.get('etapes_montage',[]))==len(scenes) and any(x.get('etape')!=i for i,x in enumerate(d['etapes_montage'],1)):errors.append(f'{rel}: numérotation étapes montage invalide')
  dlist.append(d)
 if top_keysets and len(set(top_keysets))!=1:errors.append('Les 30 gabarits ne partagent pas exactement les mêmes clés de premier niveau')
 # Signature IDs globally unique and expected matrix sets.
 sigids=[x.get('signature_montage',{}).get('id_unique') for x in dlist]
 if len(set(sigids))!=30:errors.append('Les 30 id_unique ne sont pas uniques')
 expected={f'{f}_{s}' for s in SECTORS for f in FORMATS}
 if set(sigids)!=expected:errors.append(f'id_unique manquants/inattendus: {set(sigids)^expected}')
 # 435 pairwise checks; sequence and rhythm are independently compared and thresholds applied to both.
 pairs=[]; n=len(dlist)
 for i in range(n):
  for j in range(i+1,n):
   a,b=dlist[i],dlist[j]; sa=a['signature_montage']; sb=b['signature_montage']
   seq=sim(sa['empreinte_sequence'],sb['empreinte_sequence'])
   ca=[round(x/a['duree_totale_secondes'],4) for x in sa['courbe_rythme']]
   cb=[round(x/b['duree_totale_secondes'],4) for x in sb['courbe_rythme']]
   rhythm=sim(ca,cb); same=a['format'][:2]==b['format'][:2]; threshold=0.60 if same else 0.50
   axes=pair_axes(a,b); axis_count=sum(axes.values())
   identical=(axes['séquence rôles']==False and axes['nombre scènes']==False and axes['transitions/placement']==False)
   status='OK'
   if seq>threshold or rhythm>threshold:status='ÉCHEC similarité';errors.append(f"Paire {sa['id_unique']} / {sb['id_unique']}: similarité dépasse {threshold:.0%} (séquence {seq:.1%}, rythme {rhythm:.1%})")
   if identical:status='ÉCHEC structure identique';errors.append(f"Paire {sa['id_unique']} / {sb['id_unique']}: même rôles, nombre de scènes et transitions")
   if same and axis_count<5:status='ÉCHEC axes';errors.append(f"Paire même format {sa['id_unique']} / {sb['id_unique']}: seulement {axis_count}/10 axes distincts")
   pairs.append({'a':sa['id_unique'],'b':sb['id_unique'],'same':same,'seq':seq,'rhythm':rhythm,'threshold':threshold,'axes':axis_count,'status':status})
 # 30x30 matrix: combined score = max of sequence/rhythm similarities (strictest reading).
 labels=[x['signature_montage']['id_unique'] for x in dlist]
 matrix=[[1.0 if i==j else 0.0 for j in range(n)] for i in range(n)]
 idx={x:i for i,x in enumerate(labels)}
 for p in pairs:
  score=max(p['seq'],p['rhythm']);i=idx[p['a']];j=idx[p['b']];matrix[i][j]=matrix[j][i]=score
 # Required distinctness: exactly 435 pair results.
 if len(pairs)!=435:errors.append(f'435 paires attendues; obtenu {len(pairs)}')
 same_pairs=[p for p in pairs if p['same']]; cross_pairs=[p for p in pairs if not p['same']]
 min_axes=min((p['axes'] for p in same_pairs),default=0)
 max_same_seq=max((p['seq'] for p in same_pairs),default=0); max_same_rhythm=max((p['rhythm'] for p in same_pairs),default=0)
 max_cross=max((max(p['seq'],p['rhythm']) for p in cross_pairs),default=0)
 total_spoken=sum(x['parlees'] for x in guide_stats.values());total_silent=sum(x['silencieuses'] for x in guide_stats.values());total_speech_time=round(sum(x['temps_total'] for x in guide_stats.values()),2)
 common_pack_keys=len(packs.get('fr',{}).get('traductions',{}))
 report=['# Rapport de validation — signatures sectorielles','',f'- Gabarits analysés : {len(dlist)}/30',f'- Comparaisons de paires : {len(pairs)}/435',f'- Résultat global : **{"ÉCHEC" if errors else "SUCCÈS — zéro erreur"}**',f'- Signatures structurellement distinctes démontrées : **{"30/30" if not errors and len(dlist)==30 else "NON DÉMONTRÉ"}**',f'- Plus forte similarité même format : séquence {max_same_seq:.1%}; courbe {max_same_rhythm:.1%}; minimum axes distincts {min_axes}/10.',f'- Plus forte similarité formats différents (max séquence/courbe) : {max_cross:.1%}.','- Règle appliquée strictement : séquence et courbe doivent chacune rester ≤60% entre deux gabarits du même format et ≤50% entre formats différents.','- Axe same-format : au moins 5/10 dimensions doivent différer. Vérification anti-clone : même rôle sequence + même scène count + mêmes transitions = échec.','', '## Matrice 30×30 — similarité la plus élevée (séquence ou rythme)','', 'Chaque cellule indique le maximum des deux similarités en pourcentage; diagonale = même gabarit. Une paire passe si la valeur est ≤ seuil applicable.','']
 report.append('| Signature | '+' | '.join(labels)+' |')
 report.append('|---|'+'|'.join(['---:']*n)+'|')
 for i,label in enumerate(labels):report.append('| '+label+' | '+' | '.join(f'{matrix[i][j]:.0%}' for j in range(n))+' |')
 report += ['', '## Résultat par paire (435 paires)','', '| A | B | Format commun | Sim. séquence | Sim. rythme | Seuil | Axes distincts | Résultat |','|---|---|:---:|---:|---:|---:|---:|---|']
 for p in pairs:report.append(f"| {p['a']} | {p['b']} | {'oui' if p['same'] else 'non'} | {p['seq']:.1%} | {p['rhythm']:.1%} | {p['threshold']:.0%} | {p['axes']}/10 | {p['status']} |")
 report += ['', '## Détail des structures et de charge utilisateur', '', '| Signature | scènes | durée | prises | sections UI | champs individuels | preset | audio |', '|---|---:|---:|---:|---:|---:|---|---|']
 for d in dlist:
  s=d['signature_montage']; report.append(f"| {s['id_unique']} | {len(d['scenes'])} | {d['duree_totale_secondes']}s | {len(d['prises'])} | {d['formulaire_ui']['nombre_sections_principales']} | {len(d['champs_saisie'])} | {d['etalonnage']['preset']} | {d['audio']['musique']['structure_id']} |")
 report += ['', '## Guide de parole — résultats de validation','', f'- Scènes avec une idée/exemple oral : **{total_spoken}**; scènes prévues sans parole : **{total_silent}**; somme des durées conseillées sur les 30 gabarits : **{total_speech_time:.2f} s** (pas la durée d’une seule vidéo).', f'- Pack français : **{common_pack_keys} clés**, complet; packs en/es/ja/fon/yoruba : mêmes clés, marqués `a_traduire`, sans traduction inventée.', '- Contrôles : quoi montrer et quoi raconter liés pour chaque scène parlée; exemple illustratif non à réciter; durée conseillée affichée simplement, sans coupure forcée; segment audio référencé dans une prise existante et marqué par Suivant; voix à vitesse normale; aucune consigne ni exemple sur les scènes muettes; 2–4 prises de 8–20 s; aucune transcription automatique; questions T5 neutres et ouvertes.', '- Les textes affichés viennent des champs saisis; ils ne retranscrivent pas la voix. Aucune transcription automatique n’est prévue. Une traduction humaine vérifiée est requise pour afficher des paroles en langue locale.', '', '| Signature interne | Scènes parlées | Scènes sans parole | Temps conseillé total | Thèmes dans l’ordre |', '|---|---:|---:|---:|---|']
 for d in dlist:
  fam=d['signature_montage']['famille_format']; key=f"gabarits/{d['secteur']}/{fam}.json"; gs=guide_stats.get(key,{}); themes=', '.join(gs.get('themes',[])) or 'aucun'
  report.append(f"| {d['signature_montage']['id_unique']} | {gs.get('parlees',0)} | {gs.get('silencieuses',0)} | {gs.get('temps_total',0):.2f} s | {themes} |")
 report += ['', '## Corrections effectuées','', 'Reconstruction intégrale des séquences scène par scène à partir du sujet et du parcours d’achat de chaque secteur; ajout de courbes de coupe différenciées, placements de prises/cartes, transitions/effets et textes positionnés; ajout de presets couleur et structures audio par signature; ajout du guide de parole par scène, du lien entre image à montrer et sujet à raconter, des exemples non récités et des durées affichées. Les segments sont associés aux prises existantes, marqués par Suivant, et la voix reste à vitesse normale; les scènes muettes gardent leurs champs oraux vides. Le validateur compare les signatures, les prises, les segments audio, les guides et les textes français avant qu’une conformité soit revendiquée.','', '## Erreurs à corriger avant approbation',''] + ([f'- {x}' for x in errors] if errors else ['Aucune.'])
 (ROOT/'validation/rapport_validation.md').write_text('\n'.join(report)+'\n',encoding='utf-8')
 print(f'30 signatures: {len(dlist)}; pairs={len(pairs)}; errors={len(errors)}')
 if errors:
  for e in errors[:80]:print('ERROR:',e)
 return 1 if errors else 0
if __name__=='__main__':sys.exit(main())
