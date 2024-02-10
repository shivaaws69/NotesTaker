# Use the official Python image as the base image
FROM python:3.9-slim

# Install necessary build dependencies for pyaudio
RUN apt-get update && apt-get install -y \
    gcc \
    libportaudio-dev \
    portaudio19-dev \
    python3-dev \
    && rm -rf /var/lib/apt/lists/*

# Set the working directory in the container
WORKDIR /app

# Copy the requirements file into the container
COPY backend/requirements.txt .

# Upgrade pip and setuptools
RUN pip install --upgrade pip setuptools

# Install Python dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Switch to frontend directory
WORKDIR /app/frontend

# Copy frontend package.json and yarn.lock
COPY frontend/package.json .
COPY frontend/yarn.lock .

# Install frontend dependencies
RUN yarn install --frozen-lockfile

# Copy the rest of the application code
COPY . .

# Set the working directory back to the root of the application
WORKDIR /app

# Expose port 3000 for the frontend
EXPOSE 3000

# Command to start the application
CMD ["./start.sh"]
