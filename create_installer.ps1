<#
.SYNOPSIS
    ABD Portföy Analiz Aracı — Tam kurulum paketi oluşturucu
.DESCRIPTION
    1. PyInstaller → dist\ABD Portföy Analiz.exe üretir
    2. Inno Setup  → dist\ABD_Portfoy_Analiz_Setup_v5.0.exe üretir

    Gereksinimler:
      • Python sanal ortamı kurulu   : py -m venv env + pip install -r requirements.txt
      • Inno Setup 6 kurulu          : https://jrsoftware.org/isdl.php
.EXAMPLE
    .\create_installer.ps1
#>

Set-Location $PSScriptRoot

# ── Göreceli dosya yolları (proje taşınabilirliği için) ──────────────────────
$Python    = Join-Path -Path $PSScriptRoot -ChildPath "env\Scripts\python.exe"
$ISSFile   = Join-Path -Path $PSScriptRoot -ChildPath "installer.iss"
$GuiDosya  = Join-Path -Path $PSScriptRoot -ChildPath "gui_app.py"
$AnaDosya  = Join-Path -Path $PSScriptRoot -ChildPath "ABD_Portföy_Analiz_Aracı.py"
$DistDir   = Join-Path -Path $PSScriptRoot -ChildPath "dist"

# ── Ön kontroller ─────────────────────────────────────────────────────────────
Write-Host ""
Write-Host "  ╔══════════════════════════════════════════════════════╗" -ForegroundColor Cyan
Write-Host "  ║   ABD Portföy Analiz Aracı  —  Installer Build      ║" -ForegroundColor Cyan
Write-Host "  ╚══════════════════════════════════════════════════════╝" -ForegroundColor Cyan
Write-Host ""

if (-not (Test-Path $Python)) {
    Write-Host "  ❌ Python bulunamadı: $Python" -ForegroundColor Red
    Write-Host "     Önce: py -m venv env  ve  pip install -r requirements.txt"
    exit 1
}

# Inno Setup'ı bul
$InnoYollar = @(
    "C:\Program Files (x86)\Inno Setup 6\ISCC.exe",
    "C:\Program Files\Inno Setup 6\ISCC.exe",
    "C:\Program Files (x86)\Inno Setup 5\ISCC.exe",
    "C:\Program Files\Inno Setup 5\ISCC.exe"
)
$ISCC = $InnoYollar | Where-Object { Test-Path $_ } | Select-Object -First 1

if (-not $ISCC) {
    Write-Host "  ❌ Inno Setup bulunamadı." -ForegroundColor Red
    Write-Host "     İndirin ve kurun: https://jrsoftware.org/isdl.php" -ForegroundColor Yellow
    exit 1
}
Write-Host "  ✅ Inno Setup bulundu: $ISCC" -ForegroundColor Gray

# ── ADIM 1: PyInstaller ───────────────────────────────────────────────────────
Write-Host ""
Write-Host "  [1/2] PyInstaller — .exe oluşturuluyor..." -ForegroundColor Cyan
Write-Host "        (3-8 dakika sürebilir)`n"

& $Python -m PyInstaller `
    $GuiDosya `
    --onefile `
    --noconsole `
    --name "ABD Portföy Analiz" `
    "--add-data=$AnaDosya;." `
    --collect-all curl_cffi `
    --collect-all customtkinter `
    --collect-all yfinance `
    --hidden-import pandas_datareader `
    --hidden-import pandas_datareader.stooq.daily `
    --hidden-import pandas_datareader.fred `
    --hidden-import openpyxl `
    --hidden-import dotenv `
    --hidden-import certifi `
    --hidden-import PIL._tkinter_finder `
    --noconfirm `
    --clean

if ($LASTEXITCODE -ne 0) {
    Write-Host "  ❌ PyInstaller başarısız oldu." -ForegroundColor Red
    exit 1
}

$ExePath = Join-Path -Path $DistDir -ChildPath "ABD Portföy Analiz.exe"
if (-not (Test-Path $ExePath)) {
    Write-Host "  ❌ .exe dosyası bulunamadı: $ExePath" -ForegroundColor Red
    exit 1
}
$ExeMB = [math]::Round((Get-Item $ExePath).Length / 1MB, 1)
Write-Host "  ✅ .exe oluşturuldu ($ExeMB MB): $(Resolve-Path $ExePath)" -ForegroundColor Green

# ── ADIM 2: Inno Setup ────────────────────────────────────────────────────────
Write-Host ""
Write-Host "  [2/2] Inno Setup — kurulum paketi oluşturuluyor..." -ForegroundColor Cyan
Write-Host ""

& "$ISCC" $ISSFile

if ($LASTEXITCODE -ne 0) {
    Write-Host "  ❌ Inno Setup başarısız oldu." -ForegroundColor Red
    exit 1
}

# Çıktı dosyasını bul
$SetupExe = Get-ChildItem (Join-Path -Path $DistDir -ChildPath "ABD_Portfoy_Analiz_Setup_*.exe") |
            Sort-Object LastWriteTime -Descending |
            Select-Object -First 1

if ($SetupExe) {
    $SetupMB = [math]::Round($SetupExe.Length / 1MB, 1)
    Write-Host ""
    Write-Host "  ╔══════════════════════════════════════════════════════╗" -ForegroundColor Green
    Write-Host "  ║   ✅  Kurulum paketi hazır!                          ║" -ForegroundColor Green
    Write-Host "  ╚══════════════════════════════════════════════════════╝" -ForegroundColor Green
    Write-Host ""
    Write-Host "  📦 Dosya : $($SetupExe.FullName)" -ForegroundColor White
    Write-Host "  📏 Boyut : $SetupMB MB" -ForegroundColor White
    Write-Host ""
    Write-Host "  Bu Setup.exe dosyasını istediğiniz kişiyle paylaşabilirsiniz." -ForegroundColor Yellow
    Write-Host "  Çift tıkla → Kurulum sihirbazı → Başlat Menüsüne eklenir." -ForegroundColor Yellow
} else {
    Write-Host "  ⚠️  Setup dosyası beklenenden farklı bir isimde oluşmuş olabilir." -ForegroundColor Yellow
    Write-Host "  dist\ klasörünü kontrol edin." -ForegroundColor Yellow
}
