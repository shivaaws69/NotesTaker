# Start from the base Python 3.9 slim image
FROM python:3.9-slim

# Update package lists and install necessary dependencies
RUN apt-get update && apt-get install -y \
    gcc \
    libasound-dev \
    portaudio19-dev \
    python3-dev \
    && rm -rf /var/lib/apt/lists/*

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
