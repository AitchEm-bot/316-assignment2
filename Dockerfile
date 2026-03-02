FROM python:3.10-slim

WORKDIR /app

# Install system dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    && rm -rf /var/lib/apt/lists/*

# Copy requirements and install
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copy project
COPY configs/ configs/
COPY scripts/ scripts/
COPY checkpoints/ checkpoints/

# Expose API port
EXPOSE 5000

# Health check
HEALTHCHECK --interval=30s --timeout=10s CMD curl -f http://localhost:5000/health || exit 1

# Run inference API
CMD ["python", "scripts/serve.py"]
