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

# ── Göreceli dosya yolları (proje taşınabilirliği için) ──────────────────────
$Python    = Join-Path -Path $PSScriptRoot -ChildPath "env\Scripts\python.exe"
$AnaDosya  = Join-Path -Path $PSScriptRoot -ChildPath "ABD_Portföy_Analiz_Aracı.py"
$GuiDosya  = Join-Path -Path $PSScriptRoot -ChildPath "gui_app.py"
$ExeAdi    = "ABD Portföy Analiz"
$DistDir   = Join-Path -Path $PSScriptRoot -ChildPath "dist"

# ── Python kontrolü ───────────────────────────────────────────────────────────
if (-not (Test-Path $Python)) {
    Write-Host "  ❌ Python bulunamadı: $Python" -ForegroundColor Red
    Write-Host "  Önce şu komutları çalıştırın:" -ForegroundColor Yellow
    Write-Host "    py -m venv env" -ForegroundColor White
    Write-Host "    .\env\Scripts\pip install -r requirements.txt" -ForegroundColor White
    exit 1
}

# ── Ana dosyalar kontrolü ─────────────────────────────────────────────────────
if (-not (Test-Path $AnaDosya)) {
    Write-Host "  ❌ Bulunamadı: $AnaDosya" -ForegroundColor Red
    exit 1
}

if (-not (Test-Path $GuiDosya)) {
    Write-Host "  ❌ Bulunamadı: $GuiDosya" -ForegroundColor Red
    exit 1
}

Write-Host ""
Write-Host "  ╔══════════════════════════════════════════════╗" -ForegroundColor Cyan
Write-Host "  ║   ABD Portföy Analiz Aracı  —  .exe Build   ║" -ForegroundColor Cyan
Write-Host "  ║   Bu işlem 3-8 dakika sürebilir...           ║" -ForegroundColor Cyan
Write-Host "  ╚══════════════════════════════════════════════╝" -ForegroundColor Cyan
Write-Host ""

# ── Eski dist/ temizle ────────────────────────────────────────────────────────
$ExePath = Join-Path -Path $DistDir -ChildPath "$ExeAdi.exe"
if (Test-Path $ExePath) {
    Remove-Item $ExePath -Force
    Write-Host "  🗑️  Önceki .exe temizlendi." -ForegroundColor Gray
}

# ── PyInstaller ───────────────────────────────────────────────────────────────
& $Python -m PyInstaller `
    $GuiDosya `
    --onefile `
    --noconsole `
    --name $ExeAdi `
    "--add-data=$AnaDosya;." `
    --collect-all curl_cffi `
    --collect-all customtkinter `
    --collect-all yfinance `
    --collect-all pandas_datareader `
    --hidden-import pandas_datareader `
    --hidden-import pandas_datareader.stooq `
    --hidden-import pandas_datareader.stooq.daily `
    --hidden-import pandas_datareader.fred `
    --hidden-import pandas_datareader.base `
    --hidden-import pandas_datareader.data `
    --hidden-import pandas.util._decorators `
    --hidden-import openpyxl `
    --hidden-import dotenv `
    --hidden-import certifi `
    --hidden-import PIL._tkinter_finder `
    --noconfirm `
    --clean

# ── Sonuç ─────────────────────────────────────────────────────────────────────
if ($LASTEXITCODE -eq 0) {
    $boyutMB = [math]::Round((Get-Item $ExePath).Length / 1MB, 1)

    Write-Host ""
    Write-Host "  ✅ Build tamamlandı!" -ForegroundColor Green
    Write-Host "  📁 Konum : $(Resolve-Path $ExePath)" -ForegroundColor Green
    Write-Host "  📦 Boyut : $boyutMB MB" -ForegroundColor Green
    Write-Host ""
    Write-Host "  Çalıştırmak için:" -ForegroundColor Yellow
    Write-Host "  & '$ExePath'" -ForegroundColor White
} else {
    Write-Host ""
    Write-Host "  ❌ Build başarısız. Yukarıdaki hata mesajlarını inceleyin." -ForegroundColor Red
    exit 1
}
