# Configuration Google Maps - Guide

## 📍 Intégration de la carte dans le projet

### 1. Mode actuel (recommandé) : OpenStreetMap (sans clé API)

- La page `maps.jsp` utilise maintenant **Leaflet + OpenStreetMap**
- ✅ Aucune clé API nécessaire
- ✅ Aucun compte Google Cloud requis
- ✅ Utilisation 100% gratuite pour votre projet scolaire
- Les clubs et événements sont géocodés via le service public **Nominatim** (OpenStreetMap)

Vous n'avez donc plus besoin de configurer Google Maps pour que la carte fonctionne.

---

### 2. (Optionnel) Utiliser Google Maps quand même

#### Étape 1 : Activer l'essai gratuit (si pas déjà fait)
1. Dans la console Google Cloud, cliquez sur **"Commencez l'essai gratuit"** en haut de la page
2. Acceptez les conditions pour activer le crédit de 300$ (gratuit)

#### Étape 2 : Activer les APIs nécessaires
1. Dans "Accès rapide", cliquez sur **"API et services"**
2. Cliquez sur **"+ Activer des API et services"** (ou "Bibliothèque")
3. Recherchez **"Maps JavaScript API"** et cliquez dessus
4. Cliquez sur le bouton **"Activer"**
5. Répétez pour **"Geocoding API"** (nécessaire pour convertir les adresses en coordonnées)

#### Étape 3 : Créer/Configurer une clé API
1. Retournez dans **"API et services"** → **"Identifiants"**
2. Cliquez sur **"Créer des identifiants"** → **"Clé API"** (ou modifiez la clé existante)
3. **Important** : Cliquez sur la clé créée pour la modifier
4. Dans **"Restrictions d'application"**, sélectionnez **"Référents HTTP"**
5. Ajoutez ces référents :
   - `http://localhost/*`
   - `http://localhost:8080/*`
   - (Ajoutez votre domaine si nécessaire)
6. Cliquez sur **"Enregistrer"**
7. **Copiez la clé API** générée

#### Étape 4 : Vérifier la facturation
1. Dans "Accès rapide", cliquez sur **"Facturation"**
2. Vérifiez qu'un compte de facturation est lié au projet
3. (Même avec le crédit gratuit, la facturation doit être activée)

### 3. Configuration dans le projet (si vous utilisez Google Maps)

✅ **DÉJÀ FAIT** : La clé API a été configurée dans le fichier `maps.jsp`

La clé actuelle est : `AIzaSyA1i-VRRVznVaxfS6xaLkHFXmQFKWjLqsE`

**Si vous devez la changer**, modifiez la ligne dans `/jsp/maps.jsp` :
```javascript
const GOOGLE_MAPS_API_KEY = 'VOTRE_NOUVELLE_CLE_ICI';
```

### 4. Fonctionnalités implémentées

- ✅ Affichage des clubs sur la carte
- ✅ Affichage des événements sur la carte
- ✅ Géocodage automatique des adresses
- ✅ Info windows avec détails
- ✅ Lien vers itinéraire Google Maps
- ✅ Toggle entre vue Clubs et vue Événements

### 5. Utilisation

- **Fédération** : Accès depuis le dashboard → "Voir sur la carte"
- **Président** : Accès depuis le dashboard → "Voir sur la carte"
- **Membre** : Accès depuis le dashboard → "Voir les clubs sur la carte"

### 6. Vérification et dépannage

**Si vous voyez l'erreur "Impossible de charger Google Maps correctement" :**

1. ✅ Vérifiez que l'essai gratuit est activé
2. ✅ Vérifiez que "Maps JavaScript API" est activée (API et services → Bibliothèque)
3. ✅ Vérifiez que "Geocoding API" est activée
4. ✅ Vérifiez que la facturation est activée (même avec le crédit gratuit)
5. ✅ Vérifiez que les restrictions de la clé API incluent `localhost:*`
6. ✅ Attendez 5-10 minutes après activation pour que les changements prennent effet

**Console développeur (F12)** :
- Ouvrez la console (F12) et vérifiez les erreurs
- Les erreurs "REQUEST_DENIED" indiquent un problème de clé API ou de restrictions

### 7. Coûts

- Google Maps offre un crédit gratuit de $200/mois avec facturation activée
- Avec l'essai gratuit : $300 de crédit offert
- Cela couvre environ 28 000 chargements de carte par mois
- Pour un usage local/développement : généralement gratuit

