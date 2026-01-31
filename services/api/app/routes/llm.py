"""LLM Chat routes with safety rails."""

from fastapi import APIRouter, HTTPException
from pydantic import BaseModel
from typing import Optional

router = APIRouter()

# Safety keywords that should trigger warnings
MEDICAL_ADVICE_KEYWORDS = [
    "dozaj",
    "doz",
    "kaç mg",
    "kaç tablet",
    "ne kadar almalı",
    "teşhis",
    "tanı koy",
    "hastalığım ne",
    "hangi ilacı",
    "reçete",
    "tedavi",
]

DISCLAIMER = (
    "⚠️ Önemli: Bu bilgiler yalnızca genel bilgilendirme amaçlıdır. "
    "Tıbbi tavsiye yerine geçmez. İlaç kullanımı ve dozaj konusunda "
    "mutlaka doktorunuza veya eczacınıza danışın."
)


class ChatRequest(BaseModel):
    """Chat request model."""

    message: str
    conversation_id: Optional[str] = None


class ChatResponse(BaseModel):
    """Chat response model."""

    response: str
    conversation_id: str
    has_disclaimer: bool = False


def contains_medical_advice_request(message: str) -> bool:
    """Check if message asks for medical advice."""
    message_lower = message.lower()
    return any(keyword in message_lower for keyword in MEDICAL_ADVICE_KEYWORDS)


def get_safe_response(message: str) -> str:
    """Generate a safe response (stub for now)."""
    message_lower = message.lower()

    # Check for dangerous medical advice requests
    if contains_medical_advice_request(message):
        return (
            "Bu konuda size yardımcı olmak isterim, ancak dozaj ve tedavi "
            "önerileri vermem uygun olmaz. Lütfen bu konuda doktorunuza "
            "veya eczacınıza danışın. 👨‍⚕️\n\n"
            "Size şu konularda yardımcı olabilirim:\n"
            "- İlaçların genel bilgileri\n"
            "- Yan etki bilgilendirmesi\n"
            "- Nöbetçi eczane bulma\n"
            "- İlaç hatırlatma ayarlama"
        )

    # General pharmacy/medication info responses (stub)
    if "eczane" in message_lower or "nöbetçi" in message_lower:
        return (
            "Nöbetçi eczane bulmak için ana ekrandaki 'Nöbetçi Eczane' "
            "butonunu kullanabilirsiniz. Konumunuzu paylaşırsanız "
            "size en yakın nöbetçi eczaneleri gösterebilirim. 📍"
        )

    if "hatırlat" in message_lower or "alarm" in message_lower:
        return (
            "İlaç hatırlatmalarınızı ayarlamak için 'İlaçlarım' sekmesine "
            "gidin ve '+' butonuyla yeni ilaç ekleyin. Sabit saat veya "
            "aralıklı hatırlatma seçenekleri mevcut. ⏰"
        )

    # Default helpful response
    return (
        "Merhaba! Size nöbetçi eczane bulma, ilaç hatırlatmaları "
        "ve genel ilaç bilgileri konusunda yardımcı olabilirim. "
        "Ne öğrenmek istersiniz? 💊"
    )


@router.post("/chat", response_model=ChatResponse)
async def chat(request: ChatRequest):
    """
    AI Eczacı sohbet endpoint.

    Güvenlik kuralları:
    - Dozaj önerisi vermez
    - Teşhis koymaz
    - Her yanıtta disclaimer ekler
    """
    if not request.message.strip():
        raise HTTPException(status_code=400, detail="Mesaj boş olamaz")

    # Generate conversation ID if not provided
    conversation_id = request.conversation_id or f"conv_{hash(request.message) % 10000}"

    # Get response
    response_text = get_safe_response(request.message)

    # Add disclaimer
    has_medical_content = contains_medical_advice_request(request.message)
    if has_medical_content:
        response_text = f"{response_text}\n\n{DISCLAIMER}"

    return ChatResponse(
        response=response_text,
        conversation_id=conversation_id,
        has_disclaimer=has_medical_content,
    )
