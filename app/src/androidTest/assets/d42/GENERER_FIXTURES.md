# Fixtures de rushs D42 — commandes exactes

Quatre jeux, **jamais mélangés** :

| Dossier | Cadence | Audio | Usage | Taille |
|---|---|---|---|---|
| `rushes/` | 30 im/s | sinus AAC 48 kHz | profil **production** — modes voix/mix | 3 × 12 s, 720×1280 |
| `rushes15/` | 15 im/s | sinus AAC 48 kHz | profil **validation** — modes voix/mix | 3 × 12 s, 720×1280 |
| `rushes_muets/` | 30 im/s | **aucun** | profil **production** — mode musique (gain solo) | 3 × 12 s, 720×1280 |
| `rushes_muets15/` | 15 im/s | **aucun** | profil **validation** — mode musique (gain solo) | 3 × 12 s, 720×1280 |

D42.29 : le mode MUSIQUE exige des rushs MUETS — c'est la condition produit du
gain solo (ExportWorker `baseSilencieuse` : rushs sans audio + BGM planifiée →
musique à 0 dB). Les jeux muets sont générés par les MÊMES commandes que les
jeux sonores, sans l'entrée `sine` (voir ci-dessous), même habillage visuel
(markées « RUSH n MUET » pour les distinguer sur une planche contact).

Même durée (12 s), même orientation (720×1280 portrait), même codec (H.264
High, yuv420p, AAC LC 48 kHz mono). Seule la cadence diffère, parce que le coût
du moteur sur émulateur est dominé par un coût **fixe par image** — mesuré à
≈ 217 ms/image : 758 s en 1080p et 360 s en 540p pour 1 050 images.

```bash
# Jeu de validation (15 im/s) — sources à FAIBLE ENTROPIE, mouvement lisible :
# un premier essai en testsrc2 donnait 25 Mo par MP4 (5,8 Mbps) : du bruit
# coûteux à encoder ET à décoder, qui annulait le gain de cadence.
for i in 1 2 3; do
  case $i in 1) BG=0x102A43; FG=0xF0B429;; 2) BG=0x1B4332; FG=0xFF6B35;; 3) BG=0x3D0C11; FG=0x63E6BE;; esac
  ffmpeg -y -f lavfi -i "color=c=${BG}:size=720x1280:rate=15:duration=12" \
         -f lavfi -i "sine=frequency=$((300+i*100)):sample_rate=48000:duration=12" \
         -vf "drawbox=x='mod(t*140\,560)':y=260:w=160:h=160:color=${FG}:t=fill,\
drawbox=x=60:y=1000:w='mod(t*90\,600)+60':h=24:color=white@0.9:t=fill,\
drawgrid=width=120:height=120:thickness=2:color=white@0.12,\
drawtext=fontfile=/usr/share/fonts/truetype/dejavu/DejaVuSans.ttf:text='RUSH ${i}':x=60:y=80:fontsize=72:fontcolor=white,\
drawtext=fontfile=/usr/share/fonts/truetype/dejavu/DejaVuSans.ttf:text='%{pts\\:hms}':x=60:y=1180:fontsize=48:fontcolor=white" \
         -c:v libx264 -preset veryfast -crf 30 -profile:v high -pix_fmt yuv420p -g 30 \
         -c:a aac -b:a 64k -ac 1 -shortest rush_$i.mp4
done
```

Chaque rush porte : un fond coloré uni, un carré en mouvement horizontal, une
barre de progression, une grille de repère, son numéro et l'horodatage de
l'image. Les trois jeux se distinguent visuellement (bleu/orange/vert), ce qui
permet de vérifier sur une planche contact qu'une scène utilise bien la prise
attendue.

Les rushs ne contiennent **aucune** image du produit : ce sont des sources de
test. Toutes les scènes, transitions, overlays, prix, badges et pistes audio
sont composés par le moteur de production à partir du gabarit.
