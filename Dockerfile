# Use the official Python image as a base
FROM python:3.9-slim

# Install necessary build dependencies for pyaudio
RUN apt-get update && apt-get install -y \
    gcc \
    libasound-dev \
    portaudio19-dev \
    python3-dev \
    && rm -rf /var/lib/apt/lists/*

# Set the working directory in the container
WORKDIR /app

# Copy the requirements file into the container at /app
COPY backend/requirements.txt /app/

# Install the requirements
RUN pip install --no-cache-dir -r requirements.txt

# Copy the rest of the application code into the container at /app
COPY . /app

# Expose port 3000 for the frontend
EXPOSE 3000

# Specify the command to run on container start
CMD [ "python", "app.py" ]
