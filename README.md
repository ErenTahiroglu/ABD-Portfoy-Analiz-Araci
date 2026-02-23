# 📊 ABD Portföy Analiz Aracı

ABD hisse senetleri ve ETF'lerin finansal performansını **nominal ve reel (enflasyondan arındırılmış)** bazda karşılaştırmalı olarak analiz eden masaüstü GUI uygulaması.

---

## 🚀 Özellikler

- **Masaüstü arayüz** — Koyu/açık tema, sekme tabanlı görünüm
- **Yıllık getiri analizi** — Son 5 yılın yıl yıl nominal ve reel getirileri
- **Kısa vadeli performans** — Son 1, 3, 6 ve 9 aylık dönemler
- **Temettü verimi** — Her yıl için otomatik hesaplama
- **Toplam getiri** — 3 yıllık ve 5 yıllık kümülatif performans
- **Reel getiri** — ABD enflasyonu (FRED – CPI) ile arındırılmış değerler
- **Çoklu kaynak doğrulama** — Yahoo Finance + Stooq + Alpha Vantage; fiyat farkı > %2 ise uyarı
- **Grafikler** — Yıllık getiri, 5Y/3Y karşılaştırma, aylık dönem grafikleri
- **Excel export** — Oturumun tüm sonuçları tek dosyaya

---

## 🛠️ Kurulum (kaynak koddan çalıştırma)

### 1. Python'ı yükle
[python.org](https://www.python.org/downloads/) adresinden **Python 3.9+** indir ve kur.
Kurulum sırasında **"Add Python to PATH"** seçeneğini işaretle.

### 2. Repoyu indir
```bash
git clone https://github.com/ErenTahiroglu/ABD-Portfoy-Analiz-Araci.git
cd ABD-Portfoy-Analiz-Araci
```
Ya da GitHub'da **Code → Download ZIP** ile indir, çıkart.

### 3. Sanal ortam oluştur ve bağımlılıkları yükle
```bash
py -m venv env
.\env\Scripts\pip install -r requirements.txt
```

### 4. Uygulamayı başlat
```bash
.\env\Scripts\python gui_app.py
```

İlk açılışta API anahtarı sorulur — geçmek için "Şimdilik Geç" tıklanabilir.

---

## 📦 Hazır .exe (Windows kurulum paketi)

Kaynak kodu derleyip kurulum paketi oluşturmak için:

1. [Inno Setup 6](https://jrsoftware.org/isdl.php) kur
2. PowerShell'de çalıştır:
   ```powershell
   .\create_installer.ps1
   ```
3. `dist\ABD_Portfoy_Analiz_Setup_v5.0.exe` oluşur — çift tıkla, kur, kullan.

---

## 📡 Veri Kaynakları

| Kaynak | Kullanım | Notlar |
|---|---|---|
| **Yahoo Finance** | Fiyat (birincil) | `yfinance` + `curl_cffi` Chrome impersonate |
| **Stooq** | Fiyat (ikincil, doğrulama) | API key gerektirmez |
| **Alpha Vantage** | Fiyat (üçüncül, doğrulama) | Ücretsiz key, 25 istek/gün |
| **FRED – CPIAUCSL** | Enflasyon | Federal Reserve, aylık ve yıllık CPI |

---

## 🔑 Alpha Vantage API Key (opsiyonel)

[alphavantage.co](https://www.alphavantage.co/support/#api-key) adresinden ücretsiz alınır.

- Uygulama ilk açılışta sizi API anahtarı girmeye davet eder.
- Girdiğiniz anahtar `.env` dosyasına kaydedilir (bir daha sorulmaz).
- İstediğiniz zaman ana ekrandaki **AV Key** alanından değiştirebilirsiniz.

---

## 📁 Proje Yapısı

```
ABD-Portfoy-Analiz-Araci/
│
├── gui_app.py                     # Masaüstü GUI (buradan başlatılır)
├── ABD_Portföy_Analiz_Aracı.py    # Çekirdek analiz motoru
├── requirements.txt               # Bağımlılıklar
├── create_installer.ps1           # PyInstaller + Inno Setup build pipeline
├── installer.iss                  # Inno Setup kurulum scripti
├── github_push.ps1                # Manuel GitHub yedekleme scripti
└── .vscode/                       # VS Code ayarları (isteğe bağlı)
```

---

## 📋 Gereksinimler

- Python 3.9+
- Windows 10/11 (macOS/Linux'ta GUI kısmen çalışabilir, test edilmemiştir)

---

## 🤖 Geliştirme Notu

Bu proje **Claude Sonnet 4.6** (Anthropic) yapay zeka modeli yardımıyla geliştirilmiştir.
