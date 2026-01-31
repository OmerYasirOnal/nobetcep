"""FastAPI main application."""

from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware

from app.routes import pharmacy, llm

app = FastAPI(
    title="NobetCep API",
    description="Nöbetçi eczane ve ilaç hatırlatma servisi",
    version="1.0.0",
)

# CORS middleware
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],  # Production'da kısıtla
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# Routes
app.include_router(pharmacy.router, prefix="/api/v1/pharmacies", tags=["Pharmacies"])
app.include_router(llm.router, prefix="/api/v1/llm", tags=["LLM"])


@app.get("/health")
async def health_check():
    """Health check endpoint."""
    return {"status": "healthy", "service": "nobetcep-api"}


@app.get("/")
async def root():
    """Root endpoint."""
    return {
        "message": "NobetCep API",
        "docs": "/docs",
        "health": "/health",
    }
