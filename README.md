# 📊 ABD Portföy Analiz Aracı — [ARCHIVED / DONDURULDU]

> ⚠️ **Bu proje ARCHIVED (arşivlenmiş) statüsündedir.** Daha fazla geliştirme yapılmayacak, sadece eğitim amaçlıdır.
> **Not:** Dış API'lar (Yahoo Finance, FRED, vb.) gelecekte değişse bile, `mock_data/` klasöründeki örnek CSV verisiyle çalışır.
>
> **Yasal Uyarı:** Bu araç tarafından sağlanan herhangi bir veri, analiz veya sonuç **yatırım tavsiyesi DEĞİLDİR**.
> Finansal kararlar alırken profesyonel danışman ile görüşün.

---

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

#### Çevrimiçi mod (varsayılan):
```bash
.\env\Scripts\python gui_app.py
```

#### Çevrimdışı mod (mock veri ile):
```bash
# Windows PowerShell
$env:USE_MOCK_DATA='true'
.\env\Scripts\python gui_app.py

# Windows CMD
set USE_MOCK_DATA=true
.\env\Scripts\python gui_app.py

# Unix/macOS/WSL
export USE_MOCK_DATA=true
./env/Scripts/python gui_app.py
```

**Not:** İlk açılışta API anahtarı sorulur — geçmek için "Şimdilik Geç" tıklanabilir.

**Mock Modu Hakkında:** Dış API'lar kırılsa bile `mock_data/` klasöründeki AAPL, MSFT, TSLA örnek verilerini kullanarak analizler yapabilirsiniz.

---

## 📦 Hazır .exe (Windows kurulum paketi)

### Manuel Derleme (Local Build)

Kaynak kodu derleyip kurulum paketi oluşturmak için:

1. [Inno Setup 6](https://jrsoftware.org/isdl.php) kur
2. PowerShell'de çalıştır:
   ```powershell
   .\create_installer.ps1
   ```
3. `dist\ABD_Portfoy_Analiz_Setup_v5.0-ARCHIVED.exe` oluşur — çift tıkla, kur, kullan.

### Build Betiklerinin Detayları

| Betik | Amaç | Kullanım |
|---|---|---|
| `build.ps1` | PyInstaller ile .exe oluştur | `.\build.ps1` |
| `create_installer.ps1` | PyInstaller + Inno Setup (tam setup paketi) | `.\create_installer.ps1` |
| `installer.iss` | Inno Setup yapılandırması (tarafından otomatik çalıştırılır) | Manual çalıştırılmaz |

**Not:** GitHub Actions otomatik build desteği ARCHIVED sürümlerde desteklenmeyebilir. **Lokal derlemeden çıkan .exe'yi kullanın.**

---

## 📡 Veri Kaynakları

### Çevrimiçi Kaynaklar (Varsayılan)

| Kaynak | Kullanım | Notlar |
|---|---|---|
| **Yahoo Finance** | Fiyat (birincil) | `yfinance` + `curl_cffi` Chrome impersonate |
| **Stooq** | Fiyat (ikincil, doğrulama) | API key gerektirmez |
| **Alpha Vantage** | Fiyat (üçüncül, doğrulama) | Ücretsiz key, 25 istek/gün |
| **FRED – CPIAUCSL** | Enflasyon | Federal Reserve, aylık ve yıllık CPI |

### Çevrimdışı Kaynaklar (Mock Mode)

`USE_MOCK_DATA=true` ayarlandığında:

| Kaynak | Dosya Yeri | Notlar |
|---|---|---|
| **Mock OHLCV** | `mock_data/{SEMBOL}.csv` | AAPL, MSFT, TSLA örnek verisi dahil |
| **Enflasyon** | Varsayılan %3.0 | CPI dosyası yok, tahmini değer kullanılır |

**Archived Projelerin Avantajı:** Dış API'lar kırılsa bile, `mock_data/` klasöründeki CSV verisiyle uygulama çalışmaya devam eder.

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
