# NobetCep 💊

Türkiye'deki nöbetçi eczaneleri bulmanızı ve ilaç hatırlatmalarınızı yönetmenizi sağlayan mobil uygulama.

> ⚠️ **Yasal Uyarı**: Bu uygulama tıbbi tavsiye vermez. İlaç kullanımı ve dozaj konusunda mutlaka doktorunuza veya eczacınıza danışın.

## 🎯 Özellikler

### MVP (v1.0)
- **Nöbetçi Eczane Bulucu**: Şehir/ilçe bazlı arama + konum bazlı yakın eczaneler
- **İlaç Hatırlatıcı**: Sabit saat veya aralıklı hatırlatmalar, local notification
- **AI Eczacı Sohbet**: Bilgilendirici yanıtlar (tıbbi tavsiye değil)

### Planlanan
- Premium özellikler (reklamsız deneyim)
- Aile profilleri
- Eczane stok sorgulama

## 🏗️ Mimari

```
nobetcep/
├── apps/
│   └── mobile/          # Flutter (iOS/Android/Web)
├── services/
│   └── api/             # FastAPI backend
├── docs/
│   └── ADRs/            # Architecture Decision Records
└── .github/
    └── workflows/       # CI/CD
```

## 🚀 Kurulum

### Gereksinimler

- Flutter 3.16+ (Dart 3.2+)
- Python 3.11+
- iOS: Xcode 15+
- Android: Android Studio + SDK 34

### 1. Flutter SDK Kurulumu (eğer yoksa)

```bash
# macOS (Homebrew ile)
brew install --cask flutter

# veya manuel kurulum
# https://docs.flutter.dev/get-started/install/macos

# Kurulumu doğrula
flutter doctor
```

### 2. Repo'yu klonlayın

```bash
git clone https://github.com/OmerYasirOnal/nobetcep.git
cd nobetcep
```

### 3. Backend'i çalıştırın

```bash
cd services/api
python -m venv venv
source venv/bin/activate  # Windows: venv\Scripts\activate
pip install -r requirements.txt
cp ../../.env.example .env
uvicorn app.main:app --reload
```

Backend http://localhost:8000 adresinde çalışacak. API dokümantasyonu: http://localhost:8000/docs

### 4. Flutter uygulamasını çalıştırın

```bash
cd apps/mobile
flutter pub get
flutter run
```

### 5. Platform-spesifik kurulum

**iOS:**
```bash
cd apps/mobile/ios
pod install
cd ..
flutter run -d ios
```

**Android:**
```bash
flutter run -d android
```

**Web:**
```bash
flutter run -d chrome
```

## 🔧 Ortam Değişkenleri

`.env.example` dosyasını `.env` olarak kopyalayın ve değerleri doldurun:

| Değişken | Açıklama | Varsayılan |
|----------|----------|------------|
| `PHARMACY_API_BASE_URL` | Eczane API base URL | (mock için boş) |
| `PHARMACY_API_KEY` | API anahtarı | (mock için boş) |
| `LLM_API_KEY` | LLM API anahtarı | (stub için boş) |
| `USE_MOCK_PROVIDER` | Mock veri kullan | `true` |

## 🧪 Test

### Flutter
```bash
cd apps/mobile
flutter analyze
flutter test
```

### Backend
```bash
cd services/api
python -m pytest
```

## 📱 Platform Desteği

| Platform | Durum | Notlar |
|----------|-------|--------|
| iOS | ✅ | iOS 14+ |
| Android | ✅ | API 24+ (Android 7.0) |
| Web | ⚠️ | Liste görünümü (harita yok) |

## 🤝 Katkıda Bulunma

1. Fork yapın
2. Feature branch oluşturun (`git checkout -b feature/amazing-feature`)
3. Commit yapın (`git commit -m 'feat: add amazing feature'`)
4. Push yapın (`git push origin feature/amazing-feature`)
5. Pull Request açın

## 📄 Lisans

Bu proje MIT lisansı altında lisanslanmıştır.

## 📞 İletişim

- GitHub Issues: [Sorun bildir](https://github.com/OmerYasirOnal/nobetcep/issues)
