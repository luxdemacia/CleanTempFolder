
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

# Créez et lancez l'application de la barre système
$form = New-Object TrayApp
[System.Windows.Forms.Application]::Run($form)




# 2 : Minimize the window
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
[WinAPI]::ShowWindow($consolePtr, 2)



# Chemin du dossier temporaire (j'ai utilisé un dossier sur mon bureau pour l'exemple)
$path = "C:\Users\elhad\Bureau\tmp"

# Créer le dossier s'il n'existe pas
if (-Not (Test-Path $path)) {
    New-Item -ItemType Directory -Path $path
    Write-Output "Le dossier temporaire a été créé à l'emplacement : $path"
} else {
    Write-Output "Le dossier temporaire existe déjà."
}

# Attendre 2 minutes (30 secondes)
Write-Output "Le contenu du dossier sera supprimé dans 2 minutes..."
Start-Sleep -Seconds 30

# Supprimer le contenu du dossier
if (Test-Path $path) {
    Get-ChildItem $path | Remove-Item -Recurse -Force
    Write-Output "Le contenu du dossier temporaire a été supprimé."
} else {
    Write-Output "Le dossier n'existe plus ou a été supprimé manuellement."
}
