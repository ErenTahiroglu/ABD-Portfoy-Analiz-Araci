"""
Hisse/ETF Analiz Programı
Otomatik olarak son 5 yılın verilerini çeker ve analiz eder
"""

import yfinance as yf
import pandas as pd
import pandas_datareader as pdr
from datetime import datetime, timedelta
import numpy as np
from typing import List, Dict
import warnings
warnings.filterwarnings('ignore')

class HisseAnaliz:
    def __init__(self):
        """Sınıf başlatıcı - son 5 yılı otomatik hesaplar"""
        self.bugun = datetime.now()
        self.bu_yil = self.bugun.year
        
        # Son 5 yılı otomatik hesapla
        self.yillar = [self.bu_yil - i for i in range(5, 0, -1)]
        
        print(f"\n{'='*60}")
        print(f"Analiz Tarihi: {self.bugun.strftime('%d.%m.%Y')}")
        print(f"Analiz Edilen Yıllar: {self.yillar[0]} - {self.yillar[-1]}")
        print(f"{'='*60}\n")
        
        # Enflasyon verilerini çek (yıllık ve aylık)
        self.enflasyon_verileri = self._enflasyon_verisi_al()
        self.aylik_enflasyon = self._aylik_enflasyon_al()
    
    def _enflasyon_verisi_al(self) -> Dict[int, float]:
        """ABD enflasyon verilerini FRED'den çeker"""
        print("📊 ABD enflasyon verileri çekiliyor (FRED)...")
        
        try:
            # FRED'den CPI verisi çek
            baslangic = datetime(self.yillar[0] - 1, 1, 1)
            bitis = datetime(self.bu_yil, 12, 31)
            
            cpi = pdr.get_data_fred('CPIAUCSL', start=baslangic, end=bitis)
            
            # Yıllık enflasyon hesapla
            enflasyon = {}
            for yil in self.yillar:
                try:
                    yil_basi = cpi[cpi.index.year == yil].iloc[0].values[0]
                    yil_sonu = cpi[cpi.index.year == yil].iloc[-1].values[0]
                    enflasyon[yil] = ((yil_sonu - yil_basi) / yil_basi) * 100
                except:
                    enflasyon[yil] = 3.0  # Ortalama tahmin
            
            print("✅ Enflasyon verileri başarıyla alındı\n")
            return enflasyon
            
        except Exception as e:
            print(f"⚠️  FRED'den veri alınamadı, tahmini değerler kullanılıyor: {e}\n")
            # Tahmini enflasyon değerleri
            return {yil: 3.0 for yil in self.yillar}
    
    def _aylik_enflasyon_al(self) -> pd.DataFrame:
        """Aylık CPI verilerini çeker"""
        print("📊 Aylık enflasyon verileri çekiliyor...")
        
        try:
            # Son 2 yıllık aylık CPI verisi
            baslangic = self.bugun - timedelta(days=730)
            cpi = pdr.get_data_fred('CPIAUCSL', start=baslangic, end=self.bugun)
            
            print("✅ Aylık enflasyon verileri alındı\n")
            return cpi
            
        except Exception as e:
            print(f"⚠️  Aylık enflasyon verisi alınamadı: {e}\n")
            # Boş DataFrame döndür
            return pd.DataFrame()
    
    def _yfinance_verisi_al(self, sembol: str) -> Dict:
        """Yahoo Finance'ten veri çeker"""
        print(f"  📥 Yahoo Finance'ten veri çekiliyor...")
        
        try:
            ticker = yf.Ticker(sembol)
            
            # Son 6 yıllık veri al (hesaplamalar için)
            baslangic = datetime(self.yillar[0] - 1, 1, 1)
            gecmis = ticker.history(start=baslangic, end=self.bugun)
            
            if gecmis.empty:
                return None
            
            # Temettü bilgileri
            temettular = ticker.dividends
            
            sonuclar = {
                'fiyat_verileri': gecmis,
                'temettular': temettular,
                'bilgi': ticker.info
            }
            
            print(f"  ✅ Yahoo Finance verisi alındı")
            return sonuclar
            
        except Exception as e:
            print(f"  ❌ Yahoo Finance hatası: {e}")
            return None
    
    def _yillik_getiri_hesapla(self, fiyat_verileri: pd.DataFrame, yil: int) -> float:
        """Belirli bir yıl için getiri hesaplar"""
        try:
            yil_verileri = fiyat_verileri[fiyat_verileri.index.year == yil]
            
            if len(yil_verileri) < 2:
                return None
            
            baslangic_fiyat = yil_verileri.iloc[0]['Close']
            bitis_fiyat = yil_verileri.iloc[-1]['Close']
            
            getiri = ((bitis_fiyat - baslangic_fiyat) / baslangic_fiyat) * 100
            return getiri
            
        except Exception as e:
            return None
    
    def _toplam_getiri_hesapla(self, fiyat_verileri: pd.DataFrame, baslangic_yil: int, bitis_yil: int) -> float:
        """Belirli yıllar arası toplam getiri hesaplar"""
        try:
            baslangic_verileri = fiyat_verileri[fiyat_verileri.index.year == baslangic_yil]
            bitis_verileri = fiyat_verileri[fiyat_verileri.index.year == bitis_yil]
            
            if len(baslangic_verileri) == 0 or len(bitis_verileri) == 0:
                return None
            
            baslangic_fiyat = baslangic_verileri.iloc[0]['Close']
            bitis_fiyat = bitis_verileri.iloc[-1]['Close']
            
            getiri = ((bitis_fiyat - baslangic_fiyat) / baslangic_fiyat) * 100
            return getiri
            
        except Exception as e:
            return None
    
    def _yillik_temettü_hesapla(self, temettular: pd.Series, fiyat_verileri: pd.DataFrame, yil: int) -> float:
        """Yıllık temettü verimi hesaplar"""
        try:
            # O yılın temettülerini al
            yil_temettuleri = temettular[temettular.index.year == yil]
            
            if len(yil_temettuleri) == 0:
                return 0.0
            
            toplam_temettü = yil_temettuleri.sum()
            
            # Yıl başı fiyatı
            yil_baslangic = fiyat_verileri[fiyat_verileri.index.year == yil].iloc[0]['Close']
            
            temettü_verimi = (toplam_temettü / yil_baslangic) * 100
            return temettü_verimi
            
        except Exception as e:
            return 0.0
    
    def _donemsel_getiri_hesapla(self, fiyat_verileri: pd.DataFrame, ay_sayisi: int) -> tuple:
        """Belirtilen ay sayısı için getiri ve enflasyondan arındırılmış getiri hesaplar"""
        try:
            # Başlangıç ve bitiş tarihlerini hesapla
            bitis_tarihi = self.bugun
            baslangic_tarihi = bitis_tarihi - timedelta(days=ay_sayisi * 30)
            
            # Tarihlere en yakın veriyi bul
            baslangic_verisi = fiyat_verileri[fiyat_verileri.index >= baslangic_tarihi].iloc[0]
            bitis_verisi = fiyat_verileri.iloc[-1]
            
            baslangic_fiyat = baslangic_verisi['Close']
            bitis_fiyat = bitis_verisi['Close']
            
            # Getiri hesapla
            getiri = ((bitis_fiyat - baslangic_fiyat) / baslangic_fiyat) * 100
            
            # Enflasyondan arındırılmış getiri hesapla
            enflasyon_orani = self._donem_enflasyon_hesapla(baslangic_verisi.name, bitis_verisi.name)
            reel_getiri = getiri - enflasyon_orani
            
            return getiri, reel_getiri, enflasyon_orani
            
        except Exception as e:
            return None, None, None
    
    def _donem_enflasyon_hesapla(self, baslangic_tarihi, bitis_tarihi) -> float:
        """İki tarih arası enflasyon oranını hesaplar"""
        try:
            if self.aylik_enflasyon.empty:
                # Aylık veri yoksa yıllık tahmini oran kullan
                gun_farki = (bitis_tarihi - baslangic_tarihi).days
                yillik_enflasyon = 3.0  # Varsayılan
                return (yillik_enflasyon / 365) * gun_farki
            
            # Tarihlere en yakın CPI değerlerini bul
            baslangic_cpi = self.aylik_enflasyon[self.aylik_enflasyon.index <= baslangic_tarihi].iloc[-1].values[0]
            bitis_cpi = self.aylik_enflasyon[self.aylik_enflasyon.index <= bitis_tarihi].iloc[-1].values[0]
            
            # Enflasyon oranını hesapla
            enflasyon = ((bitis_cpi - baslangic_cpi) / baslangic_cpi) * 100
            return enflasyon
            
        except Exception as e:
            # Hata durumunda tahmini oran
            gun_farki = (bitis_tarihi - baslangic_tarihi).days
            return (3.0 / 365) * gun_farki
    
    def hisse_analiz_et(self, sembol: str) -> Dict:
        """Bir hisse/ETF için tam analiz yapar"""
        print(f"\n{'='*60}")
        print(f"🔍 {sembol} Analiz Ediliyor...")
        print(f"{'='*60}")
        
        # Yahoo Finance'ten veri al
        yfinance_veri = self._yfinance_verisi_al(sembol)
        
        if not yfinance_veri:
            print(f"❌ {sembol} için veri alınamadı!\n")
            return None
        
        fiyat_verileri = yfinance_veri['fiyat_verileri']
        temettular = yfinance_veri['temettular']
        
        # Sonuç sözlüğü
        sonuc = {
            'sembol': sembol,
            'yillik_getiriler': {},
            'yillik_reel_getiriler': {},
            'yillik_temettü_verimleri': {},
            'son_5_yil_getiri': None,
            'son_3_yil_getiri': None,
            'aylik_donemler': {}
        }
        
        # Yıl yıl hesaplamalar
        print(f"\n📈 Yıllık Analizler:")
        for yil in self.yillar:
            getiri = self._yillik_getiri_hesapla(fiyat_verileri, yil)
            temettü = self._yillik_temettü_hesapla(temettular, fiyat_verileri, yil)
            
            if getiri is not None:
                enflasyon = self.enflasyon_verileri.get(yil, 3.0)
                reel_getiri = getiri - enflasyon
                
                sonuc['yillik_getiriler'][yil] = getiri
                sonuc['yillik_reel_getiriler'][yil] = reel_getiri
                sonuc['yillik_temettü_verimleri'][yil] = temettü
                
                print(f"  {yil}: Getiri: {getiri:>7.2f}% | " 
                      f"Enf. Arındırılmış: {reel_getiri:>7.2f}% | "
                      f"Temettü: {temettü:>6.2f}%")
        
        # Son 5 yıl toplam getiri
        son_5_yil = self._toplam_getiri_hesapla(fiyat_verileri, self.yillar[0], self.yillar[-1])
        sonuc['son_5_yil_getiri'] = son_5_yil
        
        # Son 3 yıl toplam getiri
        son_3_yil = self._toplam_getiri_hesapla(fiyat_verileri, self.yillar[2], self.yillar[-1])
        sonuc['son_3_yil_getiri'] = son_3_yil
        
        # Aylık dönem analizleri
        print(f"\n📅 Aylık Dönem Analizleri:")
        aylik_donemler = [1, 2, 3, 6, 9]
        
        for ay in aylik_donemler:
            getiri, reel_getiri, enflasyon = self._donemsel_getiri_hesapla(fiyat_verileri, ay)
            
            if getiri is not None:
                sonuc['aylik_donemler'][ay] = {
                    'getiri': getiri,
                    'reel_getiri': reel_getiri,
                    'enflasyon': enflasyon
                }
                
                print(f"  Son {ay:>2} Ay: Getiri: {getiri:>7.2f}% | "
                      f"Enf. Arındırılmış: {reel_getiri:>7.2f}% | "
                      f"Dönem Enflasyonu: {enflasyon:>5.2f}%")
        
        print(f"\n📊 Özet:")
        print(f"  Son 5 Yıl Toplam Getiri ({self.yillar[0]}-{self.yillar[-1]}): {son_5_yil:.2f}%" if son_5_yil else "  Son 5 Yıl: Veri yok")
        print(f"  Son 3 Yıl Toplam Getiri ({self.yillar[2]}-{self.yillar[-1]}): {son_3_yil:.2f}%" if son_3_yil else "  Son 3 Yıl: Veri yok")
        
        return sonuc
    
    def coklu_analiz(self, semboller: List[str]) -> pd.DataFrame:
        """Birden fazla hisse/ETF için analiz yapar ve karşılaştırma tablosu oluşturur"""
        tum_sonuclar = []
        
        for sembol in semboller:
            sonuc = self.hisse_analiz_et(sembol)
            if sonuc:
                tum_sonuclar.append(sonuc)
        
        # Karşılaştırma tablosu oluştur
        if not tum_sonuclar:
            print("\n❌ Hiçbir sembol için veri alınamadı!")
            return None
        
        return self._karsilastirma_tablosu_olustur(tum_sonuclar)
    
    def _karsilastirma_tablosu_olustur(self, sonuclar: List[Dict]) -> pd.DataFrame:
        """Sonuçları tablo formatında düzenler"""
        print(f"\n\n{'='*80}")
        print(f"📊 KARŞILAŞTIRMA TABLOSU")
        print(f"{'='*80}\n")
        
        # DataFrame oluştur
        data = []
        
        for sonuc in sonuclar:
            satir = {'Sembol': sonuc['sembol']}
            
            # Yıllık getiriler
            for yil in self.yillar:
                if yil in sonuc['yillik_getiriler']:
                    satir[f'{yil} Getiri'] = f"{sonuc['yillik_getiriler'][yil]:.2f}%"
                    satir[f'{yil} Reel'] = f"{sonuc['yillik_reel_getiriler'][yil]:.2f}%"
                    satir[f'{yil} Temettü'] = f"{sonuc['yillik_temettü_verimleri'][yil]:.2f}%"
            
            # Toplam getiriler
            if sonuc['son_5_yil_getiri']:
                satir['Son 5 Yıl'] = f"{sonuc['son_5_yil_getiri']:.2f}%"
            if sonuc['son_3_yil_getiri']:
                satir['Son 3 Yıl'] = f"{sonuc['son_3_yil_getiri']:.2f}%"
            
            # Aylık dönemler
            for ay in [1, 2, 3, 6, 9]:
                if ay in sonuc['aylik_donemler']:
                    donem = sonuc['aylik_donemler'][ay]
                    satir[f'Son {ay}A Getiri'] = f"{donem['getiri']:.2f}%"
                    satir[f'Son {ay}A Reel'] = f"{donem['reel_getiri']:.2f}%"
            
            data.append(satir)
        
        df = pd.DataFrame(data)
        print(df.to_string(index=False))
        
        return df
    
    def excel_kaydet(self, df: pd.DataFrame, dosya_adi: str = None):
        """Sonuçları Excel'e kaydeder"""
        if df is None:
            return
        
        if dosya_adi is None:
            dosya_adi = f"hisse_analiz_{datetime.now().strftime('%Y%m%d_%H%M%S')}.xlsx"
        
        try:
            df.to_excel(dosya_adi, index=False, engine='openpyxl')
            print(f"\n✅ Sonuçlar kaydedildi: {dosya_adi}")
        except Exception as e:
            print(f"\n❌ Excel kaydetme hatası: {e}")


def main():
    """Ana program"""
    print("\n" + "="*60)
    print("  HİSSE/ETF ANALİZ PROGRAMI")
    print("  Otomatik Son 5 Yıl Analizi")
    print("="*60)
    
    # Analiz nesnesi oluştur
    analiz = HisseAnaliz()
    
    # Kullanıcıdan semboller al
    print("\n📝 Analiz etmek istediğiniz hisse/ETF kodlarını girin")
    print("   (Virgülle ayırın, örnek: AAPL,MSFT,VOO,QQQ)")
    print("   Veya Enter'a basarak örnek kodlarla devam edin\n")
    
    girdi = input("Kodlar: ").strip()
    
    if girdi:
        semboller = [s.strip().upper() for s in girdi.split(',')]
    else:
        # Örnek semboller
        semboller = ['AAPL', 'MSFT', 'VOO', 'QQQ']
        print(f"Örnek kodlarla devam ediliyor: {', '.join(semboller)}\n")
    
    # Analiz yap
    df = analiz.coklu_analiz(semboller)
    
    # Excel'e kaydet
    if df is not None:
        kaydet = input("\n💾 Sonuçları Excel'e kaydetmek ister misiniz? (E/H): ").strip().upper()
        if kaydet == 'E':
            dosya_adi = input("   Dosya adı (boş bırakın otomatik isim için): ").strip()
            analiz.excel_kaydet(df, dosya_adi if dosya_adi else None)
    
    print("\n" + "="*60)
    print("  Program tamamlandı!")
    print("="*60 + "\n")


if __name__ == "__main__":
    main()