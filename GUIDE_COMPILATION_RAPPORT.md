# Guide de Compilation du Rapport LaTeX

## Prérequis

Pour compiler le rapport `RAPPORT_TACHES.tex`, vous avez besoin d'une distribution LaTeX complète :

- **Windows** : MiKTeX ou TeX Live
- **Linux** : TeX Live
- **Mac** : MacTeX

## Packages Requis

Le rapport utilise les packages suivants (généralement inclus dans les distributions) :
- `inputenc` (UTF-8)
- `babel` (français)
- `graphicx` (images)
- `hyperref` (liens)
- `listings` (code)
- `xcolor` (couleurs)
- `geometry` (marges)
- `fancyhdr` (en-têtes/pieds de page)
- `titlesec` (formatage des titres)
- `enumitem` (listes)
- `booktabs` (tableaux)

## Compilation

### Méthode 1 : Avec pdflatex (Recommandé)

```bash
pdflatex RAPPORT_TACHES.tex
pdflatex RAPPORT_TACHES.tex  # Deuxième compilation pour les références
```

### Méthode 2 : Avec un éditeur LaTeX

1. Ouvrez `RAPPORT_TACHES.tex` dans un éditeur LaTeX (TeXstudio, TeXmaker, Overleaf, etc.)
2. Cliquez sur "Compile" ou utilisez le raccourci (généralement F1 ou F5)
3. Le PDF sera généré automatiquement

### Méthode 3 : En ligne avec Overleaf

1. Créez un compte sur [Overleaf.com](https://www.overleaf.com)
2. Créez un nouveau projet
3. Téléversez le fichier `RAPPORT_TACHES.tex`
4. Cliquez sur "Recompile"

## Structure du Rapport

Le rapport contient :

1. **Introduction** : Présentation générale du projet
2. **Tâche 1** : Système d'Authentification
   - Base de données
   - Composants backend/frontend
   - Scénarios d'utilisation
   - Emplacements des écrans
3. **Tâche 2** : Gestion des Événements (CRUD)
   - Structure de la table Evenement
   - Servlets et DAOs
   - Scénarios complets
4. **Tâche 3** : Tableau des Participants et Statistiques
   - Gestion des participations
   - Interface de sélection de représentants
5. **Tâche 4** : Système de Notifications
   - Types de notifications
   - Badge et modal dynamique
6. **Annexes** : Structure des packages et JSP

## Ajout de Captures d'Écran

Pour ajouter des captures d'écran dans le rapport, placez-les dans un dossier `images/` et utilisez :

```latex
\begin{figure}[h]
\centering
\includegraphics[width=0.8\textwidth]{images/capture_login.png}
\caption{Page de connexion}
\label{fig:login}
\end{figure}
```

Puis référencez-les avec `\ref{fig:login}`.

## Notes Importantes

- Le rapport est prêt à être compilé tel quel
- Les emplacements des écrans sont documentés dans des tableaux
- Tous les scénarios sont détaillés étape par étape
- Les chemins de fichiers sont précisés pour chaque composant


