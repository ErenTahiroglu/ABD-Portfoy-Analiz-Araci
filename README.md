# 📊 ABD Portföy Analiz Aracı

ABD hisse senetleri ve ETF'lerin finansal performansını **nominal ve reel (enflasyondan arındırılmış)** bazda karşılaştırmalı olarak analiz eden, tamamen otomatik bir Python aracı.

---

## 🚀 Özellikler

- **Yıllık getiri analizi** — Son 5 yılın yıl yıl nominal ve reel getirileri
- **Kısa vadeli performans** — Son 1, 2, 3, 6 ve 9 aylık dönemler
- **Temettü verimi** — Her yıl için otomatik hesaplama
- **Toplam getiri** — 3 yıllık ve 5 yıllık kümülatif performans
- **Reel getiri** — ABD enflasyonu (FRED – CPI) ile arındırılmış değerler
- **Çoklu kaynak doğrulama** — Yahoo Finance + Stooq + Alpha Vantage karşılaştırması; kaynaklar arası fiyat farkı > %2 ise otomatik uyarı
- **Birikimli Excel export** — Oturum boyunca analiz edilen tüm semboller tek dosyada
- **Sürekli döngü** — İstediğiniz kadar sembol analiz edin, `kapat` yazana kadar devam edin

---

## 🛠️ Kurulum

```bash
git clone https://github.com/ErenTahiroglu/ABD-Portfoy-Analiz-Araci.git
cd ABD-Portfoy-Analiz-Araci

python -m venv env
env\Scripts\activate          # Windows
# source env/bin/activate     # Linux / macOS

pip install yfinance pandas pandas-datareader numpy openpyxl curl_cffi certifi requests
```

---

## ▶️ Kullanım

```bash
python ABD_Portföy_Analiz_Aracı.py
```

```
Kodlar → AAPL, MSFT, NVDA, VOO, QQQ
```

- Birden fazla sembol virgülle ayrılır
- Analiz bittikten sonra yeni semboller girilebilir
- `kapat` yazılınca oturumun tüm sonuçları Excel'e kaydedilebilir

---

## 📡 Veri Kaynakları

| Kaynak | Kullanım | Notlar |
|---|---|---|
| **Yahoo Finance** | Fiyat (birincil) | `yfinance` + `curl_cffi` Chrome impersonate |
| **Stooq** | Fiyat (ikincil, doğrulama) | API key gerektirmez |
| **Alpha Vantage** | Fiyat (üçüncül, doğrulama) | Ücretsiz key, 25 istek/gün |
| **FRED – CPIAUCSL** | Enflasyon | Federal Reserve, aylık ve yıllık CPI |

---

## 📁 Proje Yapısı

```
ABD-Portfoy-Analiz-Araci/
│
├── ABD_Portföy_Analiz_Aracı.py   # Ana program
├── github_push.ps1                # Güvenli GitHub yedekleme scripti
├── requirements.txt               # Bağımlılıklar
└── README.md
```

---

## 🔑 Alpha Vantage API Key

[alphavantage.co](https://www.alphavantage.co/support/#api-key) adresinden ücretsiz alınır. Ömür boyu geçerlidir, yenileme gerekmez.

Koda eklemek için `ABD_Portföy_Analiz_Aracı.py` içindeki şu satırı düzenleyin:

```python
_AV_KEY = os.environ.get("ALPHA_VANTAGE_KEY", "YOUR_API_KEY_HERE")
```

Ya da ortam değişkeni olarak tanımlayın:

```bash
set ALPHA_VANTAGE_KEY=your_key_here        # Windows
export ALPHA_VANTAGE_KEY=your_key_here     # Linux / macOS
```

---

## 📋 Gereksinimler

- Python 3.9+
- Windows / Linux / macOS

---

## 🤖 Geliştirme Notu

Bu proje **Claude Sonnet 4.6** (Anthropic) yapay zeka modeli yardımıyla yazılmıştır.
