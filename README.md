# CleanTempFolder
Automatiser la suppression d'un dossier Bureau

# Usage:
Copier-coller le Script et ouvrez votre terminal placer vous dans le dossier se trouvant le Script.
Exécutez le avec <code>.\CleanTempFolder.ps1<cpde>
Il créera un dossier temporaire de 30s puis supprime les contenu du dossiers (donc penser à mettre quelque chose dont vous avez envie de supprimer).

## AJuster la durée de suppression de votre dossier.

## Exécution en mode totalement caché
Pour lancer le script sans afficher de fenêtre PowerShell :
### Créer un fichier batch : 
Créez un fichier .bat (LaunchTempScript.bat) pour exécuter le script PowerShell en arrière-plan.
Ouvrez votre notebloc ou Vscode selon votre choix.
Créez un fichier nommé LaunchTempScript.bat.
Ajoutez ce contenu :
<code> powershell -WindowStyle Hidden -NoProfile -File "C:\Users\elhad\Bureau\CleanTempFolder.ps1" <code>
Double-cliquez sur le fichier LaunchTempScript.bat pour exécuter le script sans fenêtre visible.

## Convertir en application exécutable
Utilisez un convertisseur PowerShell vers EXE comme PS2EXE.
<code>Install-Module -Name ps2exe -Scope CurrentUser <code>
Convertissez votre script avec la commande:
<code>ps2exe.ps1 -inputFile MonScript.ps1 -outputFile MonApplication.exe<code>
Une fois converti, votre application peut être lancée comme un programme standard.

