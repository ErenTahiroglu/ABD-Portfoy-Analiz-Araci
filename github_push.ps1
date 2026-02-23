<#
.SYNOPSIS
    ABD Portföy Analiz Aracı — GitHub yedekleme scripti
.DESCRIPTION
    .gitignore kurallarına göre hassas dosyaları (.env, *.xlsx vb.)
    dışarıda bırakarak tüm değişiklikleri commit + push yapar.
.PARAMETER Mesaj
    Commit mesajı. Boş bırakılırsa otomatik timestamp kullanılır.
.EXAMPLE
    .\github_push.ps1
    .\github_push.ps1 -Mesaj "Yeni özellik eklendi"
#>

param(
    [string]$Mesaj = ""
)

Set-Location $PSScriptRoot

# ── Remote bağlantısı var mı? ─────────────────────────────────────────────────
$remote = git remote 2>&1
if (-not $remote) {
    Write-Host "  ❌ Git remote tanımlı değil. 'git remote add origin <URL>' çalıştırın." -ForegroundColor Red
    exit 1
}

# ── Mevcut branch'i tespit et ─────────────────────────────────────────────────
$branch = git branch --show-current 2>&1
if (-not $branch) { $branch = "master" }

# ── Değişiklik var mı? ────────────────────────────────────────────────────────
$durum = git status --porcelain 2>&1
if (-not $durum) {
    Write-Host "  ℹ️  Yedeklenecek değişiklik yok." -ForegroundColor Yellow
    exit 0
}

Write-Host "`n  📦 Değişiklikler hazırlanıyor..." -ForegroundColor Cyan

# ── Stage'e ekle (.gitignore otomatik uygular) ────────────────────────────────
git add --all

# ── .env kesinlikle stage dışında bırak (çift güvence) ────────────────────────
git restore --staged .env 2>$null

# ── Stage boş mu? ─────────────────────────────────────────────────────────────
$staged = git diff --cached --name-only 2>&1
if (-not $staged) {
    Write-Host "  ℹ️  Stageable değişiklik yok (hassas dosyalar hariç tutuldu)." -ForegroundColor Yellow
    exit 0
}

Write-Host "  📋 Commit edilecek dosyalar:" -ForegroundColor Cyan
$staged | ForEach-Object { Write-Host "     $_" -ForegroundColor Gray }

# ── Commit mesajı ─────────────────────────────────────────────────────────────
if (-not $Mesaj) {
    $Mesaj = "Auto-backup $(Get-Date -Format 'dd.MM.yyyy HH:mm')"
}

git commit -m "$Mesaj"
if ($LASTEXITCODE -ne 0) {
    Write-Host "  ❌ Commit başarısız." -ForegroundColor Red
    exit 1
}

# ── Push ──────────────────────────────────────────────────────────────────────
Write-Host "  🚀 GitHub'a gönderiliyor... (branch: $branch)" -ForegroundColor Cyan
git push origin "$branch"
if ($LASTEXITCODE -ne 0) {
    Write-Host "  ❌ Push başarısız." -ForegroundColor Red
    Write-Host "  Olası nedenler:" -ForegroundColor Yellow
    Write-Host "    • İnternet bağlantısı yok" -ForegroundColor Gray
    Write-Host "    • GitHub kimlik doğrulaması yapılmamış (git credential manager)" -ForegroundColor Gray
    Write-Host "    • Remote URL hatalı: 'git remote -v' ile kontrol edin" -ForegroundColor Gray
    exit 1
}

Write-Host "  ✅ Yedeklendi [$branch]: $Mesaj`n" -ForegroundColor Green
