# Start from the base Python 3.9 slim image
FROM docker.io/library/python:3.9-slim@sha256:bcdcaefe092335ff0a0ed421e8a8d12b86fc2c1feb1199fbdac27d67ba808a9c

# Update package lists and install necessary dependencies
RUN apt-get update && apt-get install -y \
    gcc \
    libasound-dev \
    portaudio19-dev \
    python3-dev \
    curl \
    gnupg \
    && rm -rf /var/lib/apt/lists/*

# Install Node.js and yarn
RUN curl -fsSL https://deb.nodesource.com/setup_16.x | bash - && \
    apt-get install -y nodejs && \
    npm install -g npm@latest && \
    npm install -g yarn

# Set the working directory inside the container
WORKDIR /app

# Copy the requirements file into the container at /app/
COPY backend/requirements.txt /app/

# Install Python dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Copy the current directory contents into the container at /app/
COPY . /app

# Install node packages in frontend/ & run frontend
WORKDIR /app/frontend
RUN yarn install

# Install pip packages in backend/ & run backend
WORKDIR /app/backend
RUN pip install -r requirements.txt

# Set execute permissions for start.sh
RUN chmod +x start.sh

# Expose the port
EXPOSE 3000

# Command to run the application
CMD ["/bin/bash", "./start.sh"]
