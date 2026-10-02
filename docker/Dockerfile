# Base 
FROM python:3.9-slim

# Update system packages and clear cache to fix vulnerabilities
RUN apt-get update && apt-get upgrade -y && rm -rf /var/lib/apt/lists/*

# Create a non-root user and group for security (Trivy requirement)
RUN groupadd -r appgroup && useradd -r -g appgroup appuser

# Set working directory
WORKDIR /app

# Copy dependencies
COPY requirements.txt .

# Install Python tools and project dependencies
# hadolint ignore=DL3013
RUN pip install --no-cache-dir --upgrade pip setuptools wheel && \
    pip install --no-cache-dir -r requirements.txt

# Copy application files and change ownership to the non-root user
COPY --chown=appuser:appgroup . .

# Switch to the non-root user
# hadolint ignore=DL3066
USER appuser

# Expose application port
EXPOSE 5000

# Run the application
CMD ["python", "app.py"]
