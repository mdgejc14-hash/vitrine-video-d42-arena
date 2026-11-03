# VV Mock Staging local (0 FCFA)

Node.js **pur** (zero dependance npm) : mock Firebase Auth, Workers, B2 et
serveur authority C10. Ports : 3200 HTTP plain (flavor qa / emulateur
10.0.2.2:3200). HTTPS optionnel : fournir certs/ et etendre server.js.

## Lancer
node mock-server/server.js          # port 3200
VV_MOCK_PORT=3300 node mock-server/server.js

## Preuves C10 (protocole authority)
curl -s localhost:3200/health
curl -s -X POST localhost:3200/authority/reset -d '{"appId":"video.vitrine.app","userId":"u1","deviceId":"d1"}' -H 'Content-Type: application/json'
curl -s -X POST localhost:3200/authority/install -d '{"appId":"video.vitrine.app","userId":"u1","deviceId":"d1","resetToken":"<token>"}' -H 'Content-Type: application/json'
curl -s "localhost:3200/authority/verify?appId=video.vitrine.app&userId=u1&deviceId=d1"

## Securite
Jamais exposer sur Internet ; tarification miroir de l'app (500/3000/7500) ;
aucune donnee de production ; jwt secret local documente (mock uniquement).
