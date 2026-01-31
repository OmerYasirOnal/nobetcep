# NobetCep API

FastAPI backend servisi.

## Özellikler

- `/pharmacies/on-duty` - Nöbetçi eczane endpoint (mock/gerçek provider)
- `/llm/chat` - AI sohbet endpoint (güvenlik raylı)
- In-memory cache + rate limiting

## Kurulum

```bash
# Virtual environment oluştur
python -m venv venv
source venv/bin/activate  # Windows: venv\Scripts\activate

# Bağımlılıkları yükle
pip install -r requirements.txt

# Ortam değişkenlerini ayarla
cp ../../.env.example .env

# Çalıştır
uvicorn app.main:app --reload
```

## Docker

```bash
docker build -t nobetcep-api .
docker run -p 8000:8000 --env-file .env nobetcep-api
```

## API Endpoints

### Eczane

```
GET /api/v1/pharmacies/on-duty?city={city}&district={district}
GET /api/v1/pharmacies/on-duty?lat={lat}&lon={lon}
```

### Chat

```
POST /api/v1/llm/chat
Body: { "message": "string", "conversation_id": "string?" }
```

### Health

```
GET /health
```

## Ortam Değişkenleri

| Değişken | Açıklama |
|----------|----------|
| `USE_MOCK_PROVIDER` | `true` = mock veri, `false` = gerçek API |
| `PHARMACY_API_BASE_URL` | Gerçek eczane API URL |
| `PHARMACY_API_KEY` | API anahtarı |
| `LLM_API_KEY` | LLM API anahtarı |
