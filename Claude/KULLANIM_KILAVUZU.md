# HİSSE/ETF ANALİZ PROGRAMI - KURULUM VE KULLANIM KILAVUZU

## 📋 PROGRAM ÖZELLİKLERİ

✅ **Otomatik Tarih Hesaplama**: Program çalıştığında son 5 yılı otomatik hesaplar
✅ **Çoklu Kaynak**: Yahoo Finance + FRED (Federal Reserve)
✅ **Kapsamlı Analiz**:
   - Yıl yıl getiriler (örn: 2020, 2021, 2022, 2023, 2024)
   - Son 5 yıl toplam getiri
   - Son 3 yıl toplam getiri
   - Her yıl için enflasyondan arındırılmış getiri
   - Yıllık temettü verimleri
   - **YENİ:** Son 1, 2, 3, 6, 9 aylık getiriler
   - **YENİ:** Her aylık dönem için enflasyondan arındırılmış getiri
✅ **Excel Dışa Aktarma**: Sonuçları Excel dosyasına kaydedebilme
✅ **Çoklu Hisse Karşılaştırma**: Birden fazla hisse/ETF'i aynı anda analiz edebilme

---

## 🔧 VISUAL STUDIO 2022'DE KURULUM

### Adım 1: Python Desteği Kurulumu

1. **Visual Studio Installer**'ı açın
2. **Modify** butonuna tıklayın
3. **Workloads** sekmesinde şunları seçin:
   - ☑️ **Python development** (Python geliştirme)
4. **Modify** butonuna tıklayarak kurulumu tamamlayın

### Adım 2: Yeni Python Projesi Oluşturma

1. Visual Studio 2022'yi açın
2. **Create a new project** seçin
3. Arama kutusuna **"Python"** yazın
4. **Python Application** şablonunu seçin
5. Proje adı: **HisseAnaliz**
6. **Create** butonuna tıklayın

### Adım 3: Gerekli Dosyaları Ekleme

1. Solution Explorer'da projeye sağ tıklayın
2. **Add → Existing Item** seçin
3. Şu dosyaları ekleyin:
   - `hisse_analiz.py` (ana program)
   - `requirements.txt` (kütüphane listesi)

### Adım 4: Kütüphaneleri Yükleme

**Yöntem 1: Visual Studio Terminal**
1. **View → Terminal** menüsünden terminal açın
2. Aşağıdaki komutu çalıştırın:
```bash
pip install -r requirements.txt
```

**Yöntem 2: Python Environments**
1. **View → Other Windows → Python Environments**
2. Environment'ı seçin
3. **Packages** sekmesine geçin
4. Aşağıdaki paketleri tek tek arayıp yükleyin:
   - yfinance
   - pandas
   - pandas-datareader
   - numpy
   - openpyxl

---

## 🚀 PROGRAMI ÇALIŞTIRMA

### Visual Studio'da Çalıştırma

1. `hisse_analiz.py` dosyasını açın
2. **F5** tuşuna basın veya **Debug → Start Debugging**
3. Program terminal/console'da çalışacak

### Alternatif: Komut Satırından

```bash
cd ProjeKlasoru
python hisse_analiz.py
```

---

## 📝 KULLANIM ÖRNEĞİ

Program çalıştığında size hisse kodları soracak:

```
============================================================
  HİSSE/ETF ANALİZ PROGRAMI
  Otomatik Son 5 Yıl Analizi
============================================================

Analiz Tarihi: 17.02.2026
Analiz Edilen Yıllar: 2021 - 2025
============================================================

📊 ABD enflasyon verileri çekiliyor (FRED)...
✅ Enflasyon verileri başarıyla alındı

📝 Analiz etmek istediğiniz hisse/ETF kodlarını girin
   (Virgülle ayırın, örnek: AAPL,MSFT,VOO,QQQ)
   Veya Enter'a basarak örnek kodlarla devam edin

Kodlar: 
```

### Örnek Girişler:

```
AAPL,MSFT,GOOGL          # Birden fazla hisse
VOO,VTI,SPY              # ETF'ler
AAPL                     # Tek hisse
```

### Program Çıktısı:

```
============================================================
🔍 AAPL Analiz Ediliyor...
============================================================
  📥 Yahoo Finance'ten veri çekiliyor...
  ✅ Yahoo Finance verisi alındı

📈 Yıllık Analizler:
  2021: Getiri:   34.50% | Enf. Arındırılmış:   27.50% | Temettü:   0.55%
  2022: Getiri:  -26.40% | Enf. Arındırılmış:  -32.40% | Temettü:   0.58%
  2023: Getiri:   48.20% | Enf. Arındırılmış:   44.70% | Temettü:   0.52%
  2024: Getiri:   32.10% | Enf. Arındırılmış:   29.10% | Temettü:   0.46%
  2025: Getiri:   15.80% | Enf. Arındırılmış:   12.80% | Temettü:   0.44%

📅 Aylık Dönem Analizleri:
  Son  1 Ay: Getiri:    5.20% | Enf. Arındırılmış:    4.95% | Dönem Enflasyonu:  0.25%
  Son  2 Ay: Getiri:    8.50% | Enf. Arındırılmış:    7.98% | Dönem Enflasyonu:  0.52%
  Son  3 Ay: Getiri:   12.30% | Enf. Arındırılmış:   11.52% | Dönem Enflasyonu:  0.78%
  Son  6 Ay: Getiri:   18.70% | Enf. Arındırılmış:   17.13% | Dönem Enflasyonu:  1.57%
  Son  9 Ay: Getiri:   24.50% | Enf. Arındırılmış:   22.14% | Dönem Enflasyonu:  2.36%

📊 Özet:
  Son 5 Yıl Toplam Getiri (2021-2025): 142.35%
  Son 3 Yıl Toplam Getiri (2023-2025): 116.48%
```

---

## 📊 KARŞILAŞTIRMA TABLOSU

Birden fazla hisse girdiğinizde otomatik karşılaştırma tablosu oluşur:

```
================================================================================
📊 KARŞILAŞTIRMA TABLOSU
================================================================================

Sembol  2021 Getiri  2021 Reel  ...  Son 5 Yıl  Son 3 Yıl  Son 1A Getiri  Son 1A Reel  ...
------  -----------  ---------  ...  ---------  ---------  -------------  -----------  ...
AAPL    34.50%       27.50%     ...  142.35%    116.48%    5.20%          4.95%        ...
MSFT    51.20%       44.20%     ...  168.90%    128.32%    6.10%          5.85%        ...
VOO     28.70%       21.70%     ...  89.45%     65.23%     4.50%          4.25%        ...

Not: Tablo genişliğinden dolayı tüm kolonlar gösterilmemiştir.
     Son 2A, 3A, 6A, 9A getiri ve reel getiri kolonları da mevcuttur.
```

---

## 💾 EXCEL'E KAYDETME

Program sonunda size soracak:

```
💾 Sonuçları Excel'e kaydetmek ister misiniz? (E/H): E
   Dosya adı (boş bırakın otomatik isim için): 
```

- **E** yazıp Enter → Dosya kaydedilir
- Dosya adı boş bırakılırsa: `hisse_analiz_20260217_143025.xlsx`
- İsim girebilirsiniz: `apple_analiz.xlsx`

---

## 🔍 PROGRAM NASIL ÇALIŞIR?

### 1. Otomatik Tarih Hesaplama
```python
bugun = datetime.now()
bu_yil = bugun.year
yillar = [bu_yil - i for i in range(5, 0, -1)]
# Örnek: 2026 yılında çalıştırırsanız → [2021, 2022, 2023, 2024, 2025]
```

### 2. Veri Kaynakları

**Yahoo Finance (yfinance)**
- Hisse fiyatları
- Temettü ödemeleri
- Günlük işlem verileri

**FRED (Federal Reserve)**
- ABD CPI (Consumer Price Index) enflasyon verileri
- Reel getiri hesaplamaları için

### 3. Hesaplamalar

**Yıllık Getiri:**
```
Getiri = ((Yıl Sonu Fiyat - Yıl Başı Fiyat) / Yıl Başı Fiyat) × 100
```

**Enflasyondan Arındırılmış Getiri:**
```
Reel Getiri = Nominal Getiri - Enflasyon Oranı
```

**Temettü Verimi:**
```
Temettü Verimi = (Yıllık Toplam Temettü / Yıl Başı Fiyat) × 100
```

**Aylık Dönem Getirisi:**
```
Dönem Getirisi = ((Bugünkü Fiyat - N Ay Önceki Fiyat) / N Ay Önceki Fiyat) × 100
Dönem Reel Getiri = Dönem Getirisi - Dönem İçi Enflasyon
```

Not: Aylık enflasyon verileri FRED'den aylık CPI (Consumer Price Index) kullanılarak hesaplanır.

---

## ⚙️ GELİŞMİŞ ÖZELLEŞTİRME

### Farklı Zaman Aralığı (örn: Son 10 Yıl)

`hisse_analiz.py` dosyasında 17. satırı değiştirin:

```python
# Şu anki:
self.yillar = [self.bu_yil - i for i in range(5, 0, -1)]

# 10 yıl için:
self.yillar = [self.bu_yil - i for i in range(10, 0, -1)]
```

### Daha Fazla Kaynak Eklemek

Alpha Vantage veya diğer API'ler eklenebilir (ücretsiz API key gerekir):

```python
def _alphavantage_verisi_al(self, sembol: str, api_key: str):
    import requests
    url = f'https://www.alphavantage.co/query?function=TIME_SERIES_DAILY&symbol={sembol}&apikey={api_key}'
    response = requests.get(url)
    return response.json()
```

---

## 🐛 SORUN GİDERME

### Hata: "No module named 'yfinance'"
**Çözüm:** Kütüphaneleri yükleyin
```bash
pip install -r requirements.txt
```

### Hata: "FRED'den veri alınamadı"
**Çözüm:** İnternet bağlantınızı kontrol edin. Program tahmini enflasyon değerleriyle devam edecek.

### Hata: "Ticker not found"
**Çözüm:** Hisse kodunu kontrol edin. Kodlar Yahoo Finance formatında olmalı:
- ✅ Doğru: AAPL, MSFT, VOO
- ❌ Yanlış: Apple, Microsoft, Vanguard

### Excel Kayıt Hatası
**Çözüm:** openpyxl kütüphanesini yükleyin
```bash
pip install openpyxl
```

---

## 📚 ÖRNEK HISSE/ETF KODLARI

### Popüler ABD Hisseleri:
- **AAPL** - Apple
- **MSFT** - Microsoft
- **GOOGL** - Alphabet (Google)
- **AMZN** - Amazon
- **TSLA** - Tesla
- **NVDA** - NVIDIA
- **META** - Meta (Facebook)

### Popüler ETF'ler:
- **VOO** - Vanguard S&P 500
- **VTI** - Vanguard Total Market
- **SPY** - SPDR S&P 500
- **QQQ** - Invesco QQQ (Nasdaq 100)
- **VYM** - Vanguard High Dividend

### Temettü Odaklı:
- **SCHD** - Schwab US Dividend
- **VYM** - Vanguard High Dividend
- **DGRO** - iShares Dividend Growth

---

## 🔐 GÜVENİLİRLİK NOTLARI

1. **Yahoo Finance**: Dünyanın en çok kullanılan ücretsiz finans veri kaynağı
2. **FRED**: ABD Federal Reserve'in resmi veri portalı
3. **Tarihsel Veriler**: 20+ yıllık geçmişe sahip
4. **Güncel Veriler**: Günlük olarak güncellenir

---

## 📞 DESTEK VE GELİŞTİRME

Programı ihtiyaçlarınıza göre özelleştirebilirsiniz:
- Farklı zaman aralıkları
- Ek veri kaynakları
- Grafik görselleştirme
- Portföy analizi
- Risk metrikleri

---

## 📄 LİSANS

Bu program eğitim amaçlıdır. Finansal danışmanlık değildir.
Yatırım kararları almadan önce profesyonel danışman görüşü alın.

---

**Son Güncelleme:** Şubat 2026
**Uyumlu:** Python 3.8+, Visual Studio 2022
