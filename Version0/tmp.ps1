Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

function Show-FolderBrowserDialog {
    $folderBrowser = New-Object System.Windows.Forms.FolderBrowserDialog
    $folderBrowser.Description = "Sélectionnez l'emplacement pour créer le dossier"
    if ($folderBrowser.ShowDialog() -eq "OK") {
        return $folderBrowser.SelectedPath
    } else {
        return $null
    }
}

# Étape 1 : Choisir l'emplacement
$selectedPath = Show-FolderBrowserDialog

if (-not $selectedPath) {
    Write-Host "Aucun emplacement sélectionné. Script arrêté."
    exit
}

# Étape 2 : Créer un dossier dans l'emplacement choisi
$dossierNom = "MonDossierTemporaire"
$nouveauDossier = Join-Path -Path $selectedPath -ChildPath $dossierNom

if (-not (Test-Path -Path $nouveauDossier)) {
    New-Item -Path $nouveauDossier -ItemType Directory | Out-Null
    Write-Host "Dossier créé à : $nouveauDossier"
} else {
    Write-Host "Le dossier existe déjà : $nouveauDossier"
}

# Étape 3 : Attendre quelques minutes avant de supprimer le contenu
$delaiMinutes = 2 # Remplace 2 par le délai souhaité
Write-Host "Le contenu sera supprimé dans $delaiMinutes minutes..."
Start-Sleep -Seconds ($delaiMinutes * 60)

# Étape 4 : Supprimer le contenu du dossier
Get-ChildItem -Path $nouveauDossier | Remove-Item -Recurse -Force
Write-Host "Le contenu du dossier temporaire '$dossierNom' a été supprimé."

# (Optionnel) Supprimer le dossier lui-même
Remove-Item -Path $nouveauDossier -Recurse -Force
