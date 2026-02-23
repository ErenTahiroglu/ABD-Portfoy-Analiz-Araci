<#
.SYNOPSIS
    ABD Portföy Analiz Aracı — PyInstaller .exe build scripti
.DESCRIPTION
    gui_app.py'yi bağımsız tek .exe dosyası olarak paketler.
    Python veya herhangi bir kurulum gerektirmez.
    Çıktı: dist\ABD Portföy Analiz.exe  (~80-120 MB)
.EXAMPLE
    .\build.ps1
#>

Set-Location $PSScriptRoot

$Python    = ".\env\Scripts\python.exe"
$AnaDosya  = "ABD_Portföy_Analiz_Aracı.py"
$ExeAdi    = "ABD Portföy Analiz"

# ── Python kontrolü ───────────────────────────────────────────────────────────
if (-not (Test-Path $Python)) {
    Write-Host "  ❌ Python bulunamadı: $Python" -ForegroundColor Red
    Write-Host "  Önce 'py -m venv env' ve pip install -r requirements.txt çalıştırın."
    exit 1
}

# ── Ana dosya kontrolü ────────────────────────────────────────────────────────
if (-not (Test-Path $AnaDosya)) {
    Write-Host "  ❌ Bulunamadı: $AnaDosya" -ForegroundColor Red
    exit 1
}

Write-Host ""
Write-Host "  ╔══════════════════════════════════════════════╗" -ForegroundColor Cyan
Write-Host "  ║   ABD Portföy Analiz Aracı  —  .exe Build   ║" -ForegroundColor Cyan
Write-Host "  ║   Bu işlem 3-8 dakika sürebilir...           ║" -ForegroundColor Cyan
Write-Host "  ╚══════════════════════════════════════════════╝" -ForegroundColor Cyan
Write-Host ""

# ── Eski dist/ temizle ────────────────────────────────────────────────────────
if (Test-Path "dist\$ExeAdi.exe") {
    Remove-Item "dist\$ExeAdi.exe" -Force
    Write-Host "  🗑️  Önceki .exe temizlendi." -ForegroundColor Gray
}

# ── PyInstaller ───────────────────────────────────────────────────────────────
& $Python -m PyInstaller `
    gui_app.py `
    --onefile `
    --noconsole `
    --name $ExeAdi `
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

# ── Sonuç ─────────────────────────────────────────────────────────────────────
if ($LASTEXITCODE -eq 0) {
    $exePath = "dist\$ExeAdi.exe"
    $boyutMB = [math]::Round((Get-Item $exePath).Length / 1MB, 1)

    Write-Host ""
    Write-Host "  ✅ Build tamamlandı!" -ForegroundColor Green
    Write-Host "  📁 Konum : $((Resolve-Path $exePath).Path)" -ForegroundColor Green
    Write-Host "  📦 Boyut : $boyutMB MB" -ForegroundColor Green
    Write-Host ""
    Write-Host "  Çalıştırmak için:" -ForegroundColor Yellow
    Write-Host "  .\dist\'ABD Portföy Analiz.exe'" -ForegroundColor White
} else {
    Write-Host ""
    Write-Host "  ❌ Build başarısız. Yukarıdaki hata mesajlarını inceleyin." -ForegroundColor Red
    exit 1
}
