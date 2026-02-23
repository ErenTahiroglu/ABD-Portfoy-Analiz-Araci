; ============================================================================
; ABD Portföy Analiz Aracı — Inno Setup Kurulum Scripti
; Gereksinim : Inno Setup 6+ kurulu olmalı (https://jrsoftware.org/isdl.php)
; Çalıştır   : .\create_installer.ps1
; ============================================================================

#define AppName      "ABD Portföy Analiz Aracı"
#define AppVersion   "5.0"
#define AppPublisher ""
#define AppURL       ""
#define AppExeName   "ABD Portföy Analiz.exe"
#define AppId        "{B9D3449F-EBE6-416F-B7C3-13B25E1EB732}"

; ── Kurulum genel ayarları ───────────────────────────────────────────────────
[Setup]
AppId                       = {{#AppId}
AppName                     = {#AppName}
AppVersion                  = {#AppVersion}
AppVerName                  = {#AppName} v{#AppVersion}
AppPublisher                = {#AppPublisher}
AppPublisherURL             = {#AppURL}
AppSupportURL               = {#AppURL}
AppUpdatesURL               = {#AppURL}

; Varsayılan kurulum dizini (yönetici hakları gerekmez)
DefaultDirName              = {autopf}\ABD Portfoy Analiz Araci
DefaultGroupName            = {#AppName}
DisableProgramGroupPage     = yes

; Çıktı
OutputDir                   = dist
OutputBaseFilename          = ABD_Portfoy_Analiz_Setup_v{#AppVersion}

; Sıkıştırma
Compression                 = lzma2/ultra
SolidCompression            = yes

; Görünüm
WizardStyle                 = modern
WizardResizable             = no

; Yönetici hakkı — isterseniz "admin" yapın, o zaman Program Files'a kurar
; "lowest" → kullanıcı dizinine kurar, UAC çıkmaz
PrivilegesRequired          = lowest
PrivilegesRequiredOverridesAllowed = dialog

; ── Diller ──────────────────────────────────────────────────────────────────
[Languages]
Name: "turkish"; MessagesFile: "compiler:Languages\Turkish.isl"
Name: "english"; MessagesFile: "compiler:Default.isl"

; ── Opsiyonel görevler (kurulum sırasında onay kutusu çıkar) ─────────────────
[Tasks]
Name: "desktopicon"; \
    Description: "Masaüstüne kısayol oluştur"; \
    GroupDescription: "Ek seçenekler:"; \
    Flags: unchecked

; ── Kopyalanacak dosyalar ────────────────────────────────────────────────────
[Files]
Source: "dist\{#AppExeName}"; \
    DestDir: "{app}"; \
    Flags: ignoreversion

; ── Başlat Menüsü ve masaüstü kısayolları ────────────────────────────────────
[Icons]
; Başlat Menüsü
Name: "{group}\{#AppName}";                     Filename: "{app}\{#AppExeName}"
Name: "{group}\{cm:UninstallProgram,{#AppName}}"; Filename: "{uninstallexe}"
; Masaüstü (yalnızca yukarıdaki görev seçilirse)
Name: "{autodesktop}\{#AppName}"; \
    Filename: "{app}\{#AppExeName}"; \
    Tasks: desktopicon

; ── Kurulum sonrası ──────────────────────────────────────────────────────────
[Run]
Filename: "{app}\{#AppExeName}"; \
    Description: "ABD Portföy Analiz Aracı'nı şimdi başlat"; \
    Flags: nowait postinstall skipifsilent
