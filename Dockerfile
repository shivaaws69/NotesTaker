# Use the official Node.js 16 Alpine image
FROM node:16-alpine

# Install necessary build tools and dependencies
RUN apk update && \
    apk add --no-cache \
    build-base \
    alsa-lib-dev \
    portaudio-dev \
    python3 \
    python3-dev \
    py-pip \
    py-audio \
    libsndfile-dev

# Set working directory for the application
WORKDIR /app

# Copy package.json and yarn.lock for the frontend
COPY frontend/package*.json ./frontend/
COPY backend/requirements.txt ./backend/

# Install frontend dependencies
RUN cd frontend && \
    yarn install --frozen-lockfile

# Install backend dependencies within a virtual environment
RUN python3 -m venv /venv && \
    /venv/bin/pip install --no-cache-dir -r backend/requirements.txt

# Activate virtual environment
ENV PATH="/venv/bin:$PATH"

# Copy the rest of the application
COPY . .

# Expose port 3000 for the frontend
EXPOSE 3000

# Command to start the application
CMD ["node", "backend/server.js"]
