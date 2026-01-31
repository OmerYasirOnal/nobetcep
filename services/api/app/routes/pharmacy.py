"""Pharmacy routes."""

from fastapi import APIRouter, Query, HTTPException
from pydantic import BaseModel
from typing import Optional

from app.providers.mock_provider import MockPharmacyProvider
from app.core.cache import cache

router = APIRouter()

# Provider instance (will be configurable via env)
provider = MockPharmacyProvider()


class Pharmacy(BaseModel):
    """Pharmacy model."""

    id: str
    name: str
    address: str
    city: str
    district: str
    phone: str
    latitude: float
    longitude: float
    is_on_duty: bool = True
    distance_km: Optional[float] = None


class PharmacyResponse(BaseModel):
    """Response model for pharmacy list."""

    pharmacies: list[Pharmacy]
    total: int
    cached: bool = False


@router.get("/on-duty", response_model=PharmacyResponse)
async def get_on_duty_pharmacies(
    city: Optional[str] = Query(None, description="Şehir adı"),
    district: Optional[str] = Query(None, description="İlçe adı"),
    lat: Optional[float] = Query(None, description="Enlem"),
    lon: Optional[float] = Query(None, description="Boylam"),
):
    """
    Nöbetçi eczaneleri getir.

    - city/district ile arama
    - lat/lon ile yakınlık bazlı arama
    """
    # Validate input
    if not city and not (lat and lon):
        raise HTTPException(
            status_code=400,
            detail="Şehir veya konum (lat/lon) belirtmelisiniz",
        )

    # Check cache
    cache_key = f"pharmacies:{city}:{district}:{lat}:{lon}"
    cached_data = cache.get(cache_key)
    if cached_data:
        return PharmacyResponse(
            pharmacies=cached_data,
            total=len(cached_data),
            cached=True,
        )

    # Fetch from provider
    if lat and lon:
        pharmacies = await provider.get_by_location(lat, lon)
    else:
        pharmacies = await provider.get_by_city(city, district)

    # Cache result
    cache.set(cache_key, pharmacies)

    return PharmacyResponse(
        pharmacies=pharmacies,
        total=len(pharmacies),
        cached=False,
    )
