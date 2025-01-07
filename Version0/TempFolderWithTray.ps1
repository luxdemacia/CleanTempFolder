# Ajout des composants nécessaires pour Windows Forms et Drawing
Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

# Ajout de l'icône à la barre système (systray)
Add-Type -TypeDefinition @"
using System;
using System.Drawing;
using System.Windows.Forms;
public class TrayApp : Form {
    private NotifyIcon trayIcon;
    public TrayApp() {
        trayIcon = new NotifyIcon();
        trayIcon.Text = "Script en arrière-plan";
        trayIcon.Icon = SystemIcons.Application;
        trayIcon.Visible = true;

        // Ajouter un menu contextuel
        ContextMenu contextMenu = new ContextMenu();
        contextMenu.MenuItems.Add(new MenuItem("Quitter", QuitApp));
        trayIcon.ContextMenu = contextMenu;
    }
    private void QuitApp(object sender, EventArgs e) {
        trayIcon.Visible = false;
        Application.Exit();
    }
}
"@

# Fonction pour minimiser la fenêtre
Add-Type -TypeDefinition @"
using System;
using System.Runtime.InteropServices;
public class WinAPI {
    [DllImport("user32.dll")]
    public static extern bool ShowWindow(IntPtr hWnd, int nCmdShow);
    [DllImport("kernel32.dll")]
    public static extern IntPtr GetConsoleWindow();
}
"@

$consolePtr = [WinAPI]::GetConsoleWindow()
[WinAPI]::ShowWindow($consolePtr, 2) # Minimize console window

# Boîte de dialogue pour demander le nom du dossier
$form = New-Object System.Windows.Forms.Form
$form.Text = "Nom du dossier temporaire"
$form.Width = 400
$form.Height = 200

# Boîte de texte pour entrer le nom du dossier
$textBox = New-Object System.Windows.Forms.TextBox
$textBox.Location = New-Object System.Drawing.Point(50, 50)
$textBox.Width = 300
$form.Controls.Add($textBox)

# Bouton "OK"
$buttonOK = New-Object System.Windows.Forms.Button
$buttonOK.Text = "OK"
$buttonOK.Location = New-Object System.Drawing.Point(150, 100)
$buttonOK.Add_Click({
    $global:folderName = $textBox.Text
    $form.Close()
})
$form.Controls.Add($buttonOK)

# Afficher la boîte de dialogue
$form.ShowDialog()

# Vérifier si un nom a été saisi
if (-not $folderName -or $folderName.Trim() -eq "") {
    Write-Output "Aucun nom de dossier n'a été saisi. Le script s'arrête."
    exit
}

# Chemin du dossier basé sur le nom saisi
$path = "C:\Users\elhad\Bureau\$folderName"

# Créer le dossier s'il n'existe pas
if (-Not (Test-Path $path)) {
    New-Item -ItemType Directory -Path $path
    Write-Output "Le dossier temporaire '$folderName' a été créé à l'emplacement : $path"
} else {
    Write-Output "Le dossier '$folderName' existe déjà."
}

# Ajouter une icône dans la barre système
$trayApp = New-Object TrayApp
Start-Job -ScriptBlock {
    [System.Windows.Forms.Application]::Run($trayApp)
}

# Attendre 30 secondes
Write-Output "Le contenu du dossier sera supprimé dans 30 secondes..."
Start-Sleep -Seconds 30

# Supprimer le contenu du dossier
if (Test-Path $path) {
    Get-ChildItem $path | Remove-Item -Recurse -Force
    Write-Output "Le contenu du dossier temporaire '$folderName' a été supprimé."
} else {
    Write-Output "Le dossier n'existe plus ou a été supprimé manuellement."
}

# Quitter proprement l'application de la barre système
[System.Windows.Forms.Application]::Exit()