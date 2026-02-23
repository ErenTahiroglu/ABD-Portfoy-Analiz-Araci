<#
.SYNOPSIS
    ABD Portföy Analiz Aracı — Otomatik GitHub izleyici
.DESCRIPTION
    Arka planda çalışır; her AralikSaniye'de bir git status kontrol eder.
    Değişiklik varsa github_push.ps1'i çağırır.

    VS Code açıldığında tasks.json üzerinden otomatik başlatılır.
    İzin vermek için: Ctrl+Shift+P → "Tasks: Manage Automatic Tasks in Folder"
                       → "Allow Automatic Tasks in Folder"
.PARAMETER AralikSaniye
    Kontrol sıklığı (saniye). Varsayılan: 60
#>

param(
    [int]$AralikSaniye = 60
)

$RepoKlasor = $PSScriptRoot
$PushScript = Join-Path $RepoKlasor "github_push.ps1"

Write-Host ""
Write-Host "  ╔══════════════════════════════════════════════════════╗" -ForegroundColor Cyan
Write-Host "  ║   Otomatik GitHub Yedekleme  —  AKTIF               ║" -ForegroundColor Cyan
Write-Host "  ║   Kontrol aralığı : ${AralikSaniye}s                           ║" -ForegroundColor Cyan
Write-Host "  ║   Durdurmak için  : terminali kapatın               ║" -ForegroundColor Cyan
Write-Host "  ╚══════════════════════════════════════════════════════╝" -ForegroundColor Cyan
Write-Host ""

# Push script erişilebilir mi?
if (-not (Test-Path $PushScript)) {
    Write-Host "  ❌ github_push.ps1 bulunamadı: $PushScript" -ForegroundColor Red
    exit 1
}

while ($true) {
    Start-Sleep -Seconds $AralikSaniye

    $durum = git -C "$RepoKlasor" status --porcelain 2>&1
    if ($durum) {
        $zaman = Get-Date -Format "HH:mm:ss"
        Write-Host "  🔄 [$zaman] Değişiklik tespit edildi — yedekleniyor..." -ForegroundColor Yellow

        # Aynı PowerShell sürecinde çalıştır (yol/encoding sorunlarından kaçın)
        & powershell.exe -ExecutionPolicy Bypass -NonInteractive -File "$PushScript"

        if ($LASTEXITCODE -eq 0) {
            Write-Host "  ✅ [$zaman] Yedekleme tamamlandı.`n" -ForegroundColor Green
        } else {
            Write-Host "  ⚠️  [$zaman] Yedekleme başarısız (exit: $LASTEXITCODE). Sonraki kontrolde tekrar denenecek.`n" -ForegroundColor Yellow
        }
    }
}
