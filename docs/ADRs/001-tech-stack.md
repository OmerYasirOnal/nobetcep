# ADR 001: Technology Stack Selection

## Status
Accepted

## Date
2024-01-31

## Context
NobetCep projesi için teknoloji stack'i seçilmesi gerekiyor. Hedefler:
- iOS, Android ve Web desteği
- Hızlı MVP geliştirme
- Bakımı kolay kod tabanı
- Offline-first yaklaşım

## Decision

### Frontend: Flutter
- **Seçim**: Flutter 3.16+ (Dart)
- **Gerekçe**:
  - Tek kod tabanı ile iOS/Android/Web
  - Zengin widget ekosistemi
  - Hot reload ile hızlı geliştirme
  - Güçlü typing (null safety)

### State Management: Riverpod
- **Seçim**: flutter_riverpod
- **Alternatif**: BLoC
- **Gerekçe**:
  - Compile-time güvenlik
  - Daha az boilerplate
  - Test kolaylığı
  - Modern ve aktif geliştirme

### Routing: go_router
- **Seçim**: go_router
- **Gerekçe**:
  - Declarative routing
  - Deep link desteği
  - Navigator 2.0 uyumlu

### Local Storage: Hive
- **Seçim**: Hive
- **Alternatif**: Isar, SQLite
- **Gerekçe**:
  - Hızlı NoSQL veritabanı
  - Kolay kullanım
  - Web desteği

### Backend: FastAPI
- **Seçim**: FastAPI (Python)
- **Alternatif**: NestJS, Express
- **Gerekçe**:
  - Hızlı prototipleme
  - Otomatik OpenAPI dokümantasyonu
  - Async desteği
  - ML entegrasyonu için uygun

## Consequences

### Positive
- Hızlı MVP geliştirme
- Tek kod tabanı ile çoklu platform
- Modern ve bakımı kolay mimari

### Negative
- Flutter web performansı native'e göre düşük
- Hive şema migrasyonu manuel
- Python deployment Node.js'e göre daha kompleks

### Risks
- Flutter major version değişiklikleri breaking changes getirebilir
- Hive büyük veri setlerinde yavaşlayabilir (mitigasyon: pagination)

## Related
- [Flutter architecture](https://docs.flutter.dev/app-architecture)
- [Riverpod documentation](https://riverpod.dev)
- [FastAPI documentation](https://fastapi.tiangolo.com)
