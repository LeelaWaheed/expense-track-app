# Use a minimal Python base image
FROM python:3.10-slim

# Set the working directory inside the container
WORKDIR /app

# Copy everything from your project into the container
COPY . .

# Install system dependencies (including bash and pip build tools)
RUN apt-get update && apt-get install -y \
    bash \
    build-essential \
    && rm -rf /var/lib/apt/lists/*

# Install Python dependencies
RUN pip install --no-cache-dir -r requirements.txt \
    && pip install pylint bandit

# Expose the Flask app's default port
EXPOSE 5000

# Run the Flask app
CMD ["python", "app.py"]
