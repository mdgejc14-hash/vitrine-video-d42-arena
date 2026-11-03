#!/usr/bin/env python3
"""Contrôle ADDITIONNEL de la consolidation proposée. Python 3.9+.

N'édite ni gabarit, ni validateur historique, ni test. Le contrôle du JSON
Schema complet est exécuté si la bibliothèque jsonschema est disponible.
Ne prouve ni qualité visuelle ni droits ni approbation ni rendu réel.
"""
from pathlib import Path
from decimal import Decimal, ROUND_HALF_UP
from collections import Counter
import copy
import csv
import hashlib
import json
import sys

ROOT=Path(__file__).resolve().parents[1]
SECTEURS={'vetements_mode','restaurants_maquis','immo_auto','coiffure_beaute','shops_small_business','batiment_travaux'}
FORMATS={'T1','T2','T3','T4','T5'}
EXPECTED_COUNTS={'whoosh_soft':85,'whoosh_fast':15,'caisse_enregistreuse':50,'clic_appareil':40,
 'impact_drop':31,'pop_badge':28,'amb_chantier':17,'sizzle_grill':8,'vapeur_plat':6}
EXPECTED_HIST_VALIDATOR='7617215c2df815df5fa51b6ba237e631b4f20385e8c2464677304f9f30209447'
ERRORS=[]
def need(test,msg):
    if not test: ERRORS.append(msg)
def read_json(p):return json.loads(p.read_text(encoding='utf-8-sig'))
def sha(p):return hashlib.sha256(p.read_bytes()).hexdigest()
def q(x):return int(Decimal(str(x)).quantize(Decimal(1),rounding=ROUND_HALF_UP))
def no_null(x):
    if x is None:return False
    if isinstance(x,dict):return all(no_null(v) for v in x.values())
    if isinstance(x,list):return all(no_null(v) for v in x)
    return True
def without_none(x):
    if isinstance(x,dict):return {k:without_none(v) for k,v in x.items() if v is not None}
    if isinstance(x,list):return [without_none(v) for v in x if v is not None]
    return x
def rows(path):
    with path.open(encoding='utf-8-sig',newline='') as f:return list(csv.DictReader(f,delimiter=';'))
def box_inside(inner,outer):
    return (outer['x0']<=inner['x0']<inner['x1']<=outer['x1'] and
            outer['y0']<=inner['y0']<inner['y1']<=outer['y1'])

def v13_preview(p,src):
    # Conversion uniquement en mémoire, sans aucune approbation ni sortie fichier.
    # V1.3 impose des null pour les champs non applicables/inconnus.
    result={'schema_version':'1.3','profil_id':p['profil_id'],'gabarit_id':p['gabarit_id'],
      'gabarit_sha256':p['gabarit_sha256'],'statut':'A_APPROUVER','approbation_id':None,
      'reference_visuelle_sha256':None,'axes_signature_source':src['axes_signature'],
      'style_visuel_source':src['style_visuel'],'etalonnage_source':src['etalonnage'],'scenes':[]}
    for v,s in zip(p['scenes'],src['scenes']):
        result['scenes'].append({'numero':v['numero'],'role_json':s['role'],
          'source_type':s['source']['type'],'prise_id':s['source'].get('prise_id'),
          'carte_id':s['source'].get('carte_id'),'transition_json':s['transition_sortie'],
          'effet_json':s['effet'],'animation_json':s['texte_ecran']['animation'],
          'position_texte_json':s['texte_ecran']['position'],
          'transition_parametres':v['transition_parametres'],'effet_parametres':v['effet_parametres'],
          'animation_parametres':v['animation_parametres'],
          'carte_layout':v['carte_layout'] if s['source']['type']=='generee' else None,
          'sfx_json':s['sfx'],'ancre_sfx':v['ancre_sfx'] if s['sfx'] is not None else None,
          'condition_json':s.get('condition_affichage')})
    return result

def main():
    files=sorted((ROOT/'gabarits').glob('*/*.json'))
    primary=sorted((ROOT/'fiches_style_v2_0').glob('*/*.json'))
    aliases=sorted((ROOT/'profils_style').glob('*/*.json'))
    need(len(files)==len(primary)==len(aliases)==30,'Il faut 30 gabarits et deux copies des 30 mêmes profils.')
    expect={(s,f) for s in SECTEURS for f in FORMATS}
    need({(p.parent.name,p.stem) for p in files}==expect,'Noms secteur / T1–T5 invalides.')
    need({(p.parent.name,p.stem) for p in primary}==expect,'Un profil V2 canonique manque.')
    need({(p.parent.name,p.stem) for p in aliases}==expect,'Un profil du répertoire alias manque.')
    for name in ('contrats_et_validation/valider_gabarits.py','validation/valider_gabarits.py'):
        need(sha(ROOT/name)==EXPECTED_HIST_VALIDATOR,'Le validateur historique a changé : '+name)
    manifest=rows(ROOT/'references/empreintes_40_fichiers_origine.csv')
    need(len(manifest)==40 and len({r['chemin'] for r in manifest})==40,'Manifest source : 40 chemins uniques requis.')
    for r in manifest:
        rel=Path(r['chemin']); f=ROOT/rel
        need(not rel.is_absolute() and '..' not in rel.parts and f.is_file(),'Chemin manifest source invalide : '+str(rel))
        if f.is_file():need(sha(f)==r['sha256'],'Octets source modifiés : '+str(rel))
    audio_rows=rows(ROOT/'matrice_audio/matrice_audio_30_reperes_proposes.csv')
    sfx_rows=rows(ROOT/'matrice_audio/evenements_sfx_280_reperes_proposes.csv')
    aud={r['gabarit']:r for r in audio_rows}
    events={(r['gabarit'],int(r['scene'])):r for r in sfx_rows}
    need(len(audio_rows)==len(aud)==30,'La matrice audio doit avoir 30 gabarits uniques.')
    need(len(sfx_rows)==len(events)==280,'La matrice SFX doit avoir 280 événements uniques.')
    bank=read_json(ROOT/'matrice_audio/banque_9_sfx_v2_0_proposition.json')
    need(len(bank['categories'])==9,'Il faut neuf catégories SFX.')
    need({x['categorie']:x['occurrences_source'] for x in bank['categories']}==EXPECTED_COUNTS,'Banque SFX : catégories ou nombres incorrects.')
    for cat in bank['categories']:
        need(cat['etat_fichier']=='A_ACQUERIR' and cat['etat_licence']=='A_VERIFIER' and cat['sample_impact']=='A_MESURER_SUR_FICHIER_REEL', 'Un SFX absent est présenté comme acquis/mesuré : '+cat['categorie'])
    primitives=read_json(ROOT/'references/dictionnaire_primitives_v2_0_propose.json')
    need(len(primitives['transitions'])==22 and len(primitives['animations'])==16 and len(primitives['effets'])==23,'Dictionnaires de primitives incomplets.')
    jsonschema_ok=False
    try:
        import jsonschema
        v2schema=read_json(ROOT/'contrats_et_validation/profil_style_v2_0_proposition.schema.json')
        v13schema=read_json(ROOT/'contrats_et_validation/profil_style_v1_3.schema.json')
        for x in (v2schema,v13schema,read_json(ROOT/'contrats_et_validation/plan_rendu_v2_0.schema.json'),read_json(ROOT/'contrats_et_validation/video_license_receipt_v2_0.schema.json')):
            jsonschema.Draft202012Validator.check_schema(x)
        v2validator=jsonschema.Draft202012Validator(v2schema)
        v13validator=jsonschema.Draft202012Validator(v13schema)
        jsonschema_ok=True
    except ImportError:
        print('NOTE : jsonschema absent. Contrôles métier stdlib exécutés ; installer jsonschema pour contrôler aussi les schémas.')
    except Exception as e:
        need(False,'Chargement/vérification du schéma : '+str(e))
    count=Counter();seen_events=set();alerts=Counter();first_profile=None
    for fp in files:
      try:
        rel=fp.relative_to(ROOT/'gabarits'); pp=ROOT/'fiches_style_v2_0'/rel; ap=ROOT/'profils_style'/rel
        need(pp.is_file() and ap.is_file(),f'{rel} : profil manquant')
        if not pp.is_file() or not ap.is_file():continue
        need(pp.read_bytes()==ap.read_bytes(),f'{rel} : les deux chemins ne contiennent pas les mêmes octets.')
        src=read_json(fp);p=read_json(pp);where=src['id']
        if first_profile is None:first_profile=p
        need(no_null(p),f'{where} : null dans le profil V2.')
        need(p['schema_version']=='2.0' and p['statut']=='A_APPROUVER' and p['production_autorisee'] is False,f'{where} : statut trompeur.')
        need(p['gabarit_id']==src['id'] and p['gabarit_sha256']==sha(fp),f'{where} : lien ou empreinte du gabarit incorrect.')
        need(p['axes_signature_source']==src['axes_signature'],f'{where} : axes différents.')
        need(p['style_visuel_source']==without_none(src['style_visuel']) and p['etalonnage_source']==without_none(src['etalonnage']),f'{where} : style ou étalonnage différent.')
        need(set(p['etalonnage_champs_non_applicables'])=={k for k,v in src['etalonnage'].items() if v is None},f'{where} : étalonnage non applicable non signalé.')
        need(p['cadre']['fps_num']==30 and p['cadre']['fps_den']==1 and p['audio']['mix']['sample_rate_hz']==48000,f'{where} : base de temps non 30 i/s - 48 kHz.')
        mix=p['audio']['mix']
        need(mix['ducking_musique_sous_voix_db']==-14 and mix['cible_lufs']==-14 and mix['plafond_true_peak_dbtp']==-1 and mix['voix_prioritaire'] and mix['vitesse_voix']==1.0,f'{where} : règles mix incorrectes.')
        ms=src['audio']['musique'];pa=p['audio'];a=aud.get(where,{})
        need(pa['bpm_min_source']==ms['bpm_min'] and pa['bpm_max_source']==ms['bpm_max'] and pa['genre_source']==ms['genre'],f'{where} : BPM ou genre non conformes à la source.')
        need(a.get('bpm_min_source')==str(ms['bpm_min']) and a.get('bpm_max_source')==str(ms['bpm_max']) and a.get('genre_source')==ms['genre'],f'{where} : ligne BPM/audio incohérente.')
        need(pa['riser']['role_source']==ms['cue_roles']['riser_role'] and pa['drop']['scene_source']==ms['cue_roles']['drop_scene'],f'{where} : riser/drop source incorrect.')
        need(a.get('riser_role_source')==pa['riser']['role_source'] and int(a.get('drop_scene_source','-1'))==pa['drop']['scene_source'],f'{where} : matrice riser/drop incohérente.')
        need(pa['statut_piste']=='A_ACQUERIR_ET_ECOUTER' and pa['pistes_reelles_validees']==[],f'{where} : piste imaginaire présentée comme validée.')
        need(len(p['scenes'])==len(src['scenes']),f'{where} : nombre de scènes incorrect.')
        cumul=Decimal(0);prev=0
        for i,(v,s) in enumerate(zip(p['scenes'],src['scenes'])):
            w=f'{where}:SC{s["numero"]:02d}';cumul+=Decimal(str(s['duree_secondes']));end=q(cumul*30)
            need(v['numero']==s['numero']==i+1 and v['acte_source']==s['acte'] and v['role_source']==s['role'],w+' : rôle / ordre modifié.')
            need(v['duree_source_ms']==int(Decimal(str(s['duree_secondes']))*1000) and v['frame_debut']==prev and v['frame_fin_exclusive']==end and end>prev,w+' : frontières cumulées erronées.')
            need(v['source']==without_none(s['source']) and v['texte']==without_none(s['texte_ecran']) and v['voix']==without_none(s['voix']),w+' : source, texte ou voix différents.')
            t=v['transition_parametres']; e=v['effet_parametres'];an=v['animation_parametres'];lay=v['carte_layout'];snd=v['ancre_sfx'];co=v['condition']
            need(t['id_source']==s['transition_sortie'] and e['id_source']==s['effet'] and an['id_source']==s['texte_ecran']['animation'] and an['position_source']==s['texte_ecran']['position'],w+' : primitives source différentes.')
            need(t['duree_ms']==primitives['transition_durees_ms'][s['transition_sortie']] and t['duree_frames_proposee']==q(Decimal(t['duree_ms'])*30/1000),w+' : durée transition incorrecte.')
            if i<len(src['scenes'])-1:
                need(t['fenetre_frame_debut']==end-t['marge_b_avant_frames'] and t['fenetre_frame_fin_exclusive']==end+t['marge_a_apres_frames'] and t['marge_b_avant_frames']+t['marge_a_apres_frames']==t['duree_frames_proposee'],w+' : fenêtre transition incorrecte.')
            else:
                need(t['fenetre_frame_fin_exclusive']==end and t['fenetre_frame_debut']>=prev and t['cible']=='FOND_NOIR_PROPOSE_A_APPROUVER',w+' : sortie finale incorrecte.')
            need(box_inside(an['boite_texte_norm'],p['cadre']['zone_sure_norm']) and an['boite_texte_norm']==lay['zone_texte_norm'],w+' : zone de texte non sûre ou incohérente.')
            hold=end-prev-an['entree_frames']-an['sortie_frames']
            need(an['entree_frames']>=0 and an['sortie_frames']>=0 and hold==an['pleine_lisibilite_min_frames'] and hold>=min(30,end-prev),w+' : maintien lisible insuffisant.')
            kf=an['keyframes_entree']; need(len(kf)>=2 and kf[0]['t']==0 and kf[-1]['t']==1 and all(kf[j]['t']<kf[j+1]['t'] for j in range(len(kf)-1)),w+' : keyframes mal ordonnées.')
            need(all(0<=k['opacite']<=1 and 0<=k['masque']<=1 and k['scale']>0 for k in kf),w+' : keyframe hors bornes.')
            need(e['voix_vitesse']==1.0 and e['ne_pas_geler_visage_parlant'],w+' : protection voix/visage manquante.')
            if s['source']['type']=='prise':
                need(e['source_vitesse']==s['source']['vitesse'] and 'SOURCE_VITESSE' in e['regle_vitesse_effective'],w+' : vitesse source absente.')
            if s['source']['type']=='generee' and s['voix']['active']:
                count['cartes_parlees']+=1
                need(lay['fond_image_obligatoire']['prise_id']==s['voix']['source_audio_prise_id'],w+' : image liée à la voix absente.')
            if s['source'].get('carte_id')=='carte_avant_apres_split':
                count['splits']+=1; cmp=lay['comparaison']
                need(cmp['avant_prise_id']=='prise_1' and cmp['apres_prise_id']=='prise_3',w+' : prises avant/après incorrectes.')
            expected_cond=s.get('condition_affichage') or 'AUCUNE'
            need(co['type']==expected_cond,w+' : condition source différente.')
            if expected_cond!='AUCUNE':
                count[expected_cond]+=1;need('REPLI_APPROUVE' in co['si_fausse'] and 'BLOQUER' in co['si_fausse'],w+' : repli conditionnel non sûr.')
            if expected_cond=='prix_est_saisi':need(co['si_vraie']=='BLOQUER_TANT_QUE_T5_SCENE_10_NON_ARBITREE',w+' : contradiction T5 non signalée.')
            for x in v['alertes_source']:alerts[x['type']]+=1
            cat=s['sfx'];key=(where,s['numero']); event=events.get(key)
            if cat is None:
                count['sans_sfx']+=1;need(snd['present'] is False and event is None,w+' : SFX ajouté malgré null source.')
            else:
                count[cat]+=1;seen_events.add(key)
                need(snd['present'] is True and snd['categorie']==cat and event is not None,w+' : catégorie SFX différente ou absente.')
                if event:
                    f=snd['frame_cible_30fps']; smp=snd['sample_cible_48khz']
                    need(event['sfx_categorie']==cat and event['condition_source']==expected_cond and int(event['frame_cible_30fps'])==f and int(event['sample_cible_48khz'])==smp and smp==1600*f,w+' : repère SFX incohérent.')
                    need(0<=f<q(Decimal(str(src['duree_totale_secondes']))*30) and event['statut_asset']=='A_ACQUERIR_ET_VERIFIER' and event['sample_impact_fichier']=='A_MESURER',w+' : SFX hors vidéo ou faux statut.')
                    if expected_cond=='prix_est_saisi':count['sfx_prix_conditionnels']+=1
            prev=end;count['scenes']+=1
        need(prev==int(src['duree_totale_secondes'])*30,where+' : durée finale incorrecte.')
        for label,ix in [('riser',pa['riser']['scene']-1),('drop',pa['drop']['scene_source']-1)]:
            cue=pa[label];v=p['scenes'][ix];f=cue['frame_cible_candidate']
            need(cue['fenetre_frames']==[v['frame_debut'],v['frame_fin_exclusive']] and cue['frame_cible_candidate']>=v['frame_debut'] and f<v['frame_fin_exclusive'] and cue['sample_cible_candidate']==f*1600,where+' : repère '+label+' hors fenêtre.')
            need(int(a[label+'_frame_cible_candidate'])==f,where+' : matrice '+label+' incorrecte.')
        need(p['scenes'][pa['riser']['scene']-1]['role_source']==pa['riser']['role_source'],where+' : scène de riser différente du rôle source.')
        need(pa['riser']['frame_cible_candidate']<pa['drop']['frame_cible_candidate'],where+' : montée candidate pas avant le drop.')
        if jsonschema_ok:
            for error in v2validator.iter_errors(p):need(False,where+' : schéma V2 : '+error.message)
            for error in v13validator.iter_errors(v13_preview(p,src)):need(False,where+' : correspondance V1.3 en mémoire : '+error.message)
      except Exception as e:
        need(False,f'{fp} : erreur de contrôle : {type(e).__name__}: {e}')
    need(count['scenes']==448,'Il faut 448 scènes.')
    need(count['sans_sfx']==168,'Il faut 168 scènes source sans SFX.')
    need({k:count[k] for k in EXPECTED_COUNTS}==EXPECTED_COUNTS,'Occurrences SFX différentes de la source.')
    need(seen_events==set(events),'Événement SFX supplémentaire ou manquant.')
    need(count['cartes_parlees']==12 and count['splits']==4,'Cartes parlées ou avant/après incorrectes.')
    need(count['citation_client_est_saisie']==6 and count['prix_est_saisi']==6 and count['sfx_prix_conditionnels']==6,'Conditions T5 ou SFX associés incorrects.')
    need(alerts==Counter({'PRIX_T4_ROLE_ET_TEXTE_A_ARBITRER':4,'RAYURE_T4_CIBLE_A_CONFIRMER':3}),'Les sept points de vigilance T4 doivent rester signalés.')
    if jsonschema_ok and first_profile is not None:
        # style_visuel_source tolère une propriété libre ; seul le contrôle récursif
        # doit alors refuser sa valeur null, indépendamment d'autres restrictions.
        bad=copy.deepcopy(first_profile);bad['style_visuel_source']['champ_test_libre']=None
        good=copy.deepcopy(first_profile);good['style_visuel_source']['champ_test_libre']='present'
        need(v2validator.is_valid(good) and not v2validator.is_valid(bad),'Le schéma V2 devrait refuser null imbriqué.')
    if ERRORS:
        print('ÉCHEC :',len(ERRORS),'anomalie(s)')
        for e in ERRORS[:150]:print(' -',e)
        if len(ERRORS)>150:print(' ... autres anomalies non affichées')
        return 1
    print('OK — 40 fichiers source conformes au manifest ; 30 gabarits / profils uniques ; 448 scènes.')
    print('OK — 30 BPM/roles/drop source ; 280 SFX proposés, 9 catégories ; 168 absences ; 6 prix conditionnels.')
    print('OK — 12 cartes parlées, 4 avant/après ; 30 copies identiques ; durées, zones et conditions contrôlées.')
    print('OK — T5 bloqué pour arbitrage ; 7 points T4 signalés ; validateur historique intact.')
    print('JSON Schema V2 + correspondance V1.3 en mémoire : '+('OK (bibliothèque jsonschema)' if jsonschema_ok else 'NON EXÉCUTÉ — jsonschema absent'))
    print('Rappel : cela ne prouve ni un rendu, ni une licence, ni une approbation artistique.')
    return 0
if __name__=='__main__':sys.exit(main())
