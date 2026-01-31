"""Mock pharmacy provider for development."""

from typing import Optional
import math


class MockPharmacyProvider:
    """Mock provider returning sample pharmacy data."""

    # Sample data for Istanbul
    MOCK_PHARMACIES = [
        {
            "id": "p1",
            "name": "Hayat Eczanesi",
            "address": "Bağdat Cad. No:123",
            "city": "İstanbul",
            "district": "Kadıköy",
            "phone": "0216 123 45 67",
            "latitude": 40.9833,
            "longitude": 29.0333,
            "is_on_duty": True,
        },
        {
            "id": "p2",
            "name": "Sağlık Eczanesi",
            "address": "Moda Cad. No:45",
            "city": "İstanbul",
            "district": "Kadıköy",
            "phone": "0216 234 56 78",
            "latitude": 40.9789,
            "longitude": 29.0245,
            "is_on_duty": True,
        },
        {
            "id": "p3",
            "name": "Merkez Eczanesi",
            "address": "İstiklal Cad. No:78",
            "city": "İstanbul",
            "district": "Beyoğlu",
            "phone": "0212 345 67 89",
            "latitude": 41.0336,
            "longitude": 28.9784,
            "is_on_duty": True,
        },
        {
            "id": "p4",
            "name": "Güneş Eczanesi",
            "address": "Nispetiye Cad. No:12",
            "city": "İstanbul",
            "district": "Beşiktaş",
            "phone": "0212 456 78 90",
            "latitude": 41.0766,
            "longitude": 29.0117,
            "is_on_duty": True,
        },
        {
            "id": "p5",
            "name": "Yıldız Eczanesi",
            "address": "Atatürk Bulvarı No:56",
            "city": "Ankara",
            "district": "Çankaya",
            "phone": "0312 567 89 01",
            "latitude": 39.9208,
            "longitude": 32.8541,
            "is_on_duty": True,
        },
        {
            "id": "p6",
            "name": "Cumhuriyet Eczanesi",
            "address": "Kızılay Meydanı No:34",
            "city": "Ankara",
            "district": "Çankaya",
            "phone": "0312 678 90 12",
            "latitude": 39.9179,
            "longitude": 32.8627,
            "is_on_duty": True,
        },
        {
            "id": "p7",
            "name": "Ege Eczanesi",
            "address": "Kordon Boyu No:89",
            "city": "İzmir",
            "district": "Konak",
            "phone": "0232 789 01 23",
            "latitude": 38.4237,
            "longitude": 27.1428,
            "is_on_duty": True,
        },
        {
            "id": "p8",
            "name": "Akdeniz Eczanesi",
            "address": "Lara Cad. No:67",
            "city": "Antalya",
            "district": "Muratpaşa",
            "phone": "0242 890 12 34",
            "latitude": 36.8841,
            "longitude": 30.7056,
            "is_on_duty": True,
        },
    ]

    @staticmethod
    def _calculate_distance(lat1: float, lon1: float, lat2: float, lon2: float) -> float:
        """Calculate distance between two points in km (Haversine formula)."""
        R = 6371  # Earth's radius in km

        lat1_rad = math.radians(lat1)
        lat2_rad = math.radians(lat2)
        delta_lat = math.radians(lat2 - lat1)
        delta_lon = math.radians(lon2 - lon1)

        a = (
            math.sin(delta_lat / 2) ** 2
            + math.cos(lat1_rad) * math.cos(lat2_rad) * math.sin(delta_lon / 2) ** 2
        )
        c = 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a))

        return R * c

    async def get_by_city(
        self, city: str, district: Optional[str] = None
    ) -> list[dict]:
        """Get pharmacies by city and optionally district."""
        city_normalized = city.lower().replace("i̇", "i")

        results = []
        for pharmacy in self.MOCK_PHARMACIES:
            pharmacy_city = pharmacy["city"].lower().replace("i̇", "i")
            if pharmacy_city == city_normalized or city_normalized in pharmacy_city:
                if district:
                    district_normalized = district.lower().replace("i̇", "i")
                    pharmacy_district = pharmacy["district"].lower().replace("i̇", "i")
                    if district_normalized not in pharmacy_district:
                        continue
                results.append(pharmacy.copy())

        return results

    async def get_by_location(
        self, lat: float, lon: float, radius_km: float = 10.0
    ) -> list[dict]:
        """Get pharmacies near a location."""
        results = []
        for pharmacy in self.MOCK_PHARMACIES:
            distance = self._calculate_distance(
                lat, lon, pharmacy["latitude"], pharmacy["longitude"]
            )
            if distance <= radius_km:
                pharmacy_with_distance = pharmacy.copy()
                pharmacy_with_distance["distance_km"] = round(distance, 2)
                results.append(pharmacy_with_distance)

        # Sort by distance
        results.sort(key=lambda x: x.get("distance_km", float("inf")))
        return results
