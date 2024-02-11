# Use Node.js LTS version as base image for the frontend
FROM node:lts AS frontend

# Set working directory for frontend
WORKDIR /app/frontend

# Copy frontend source code
COPY frontend/package.json frontend/yarn.lock ./

# Install dependencies
RUN yarn install

# Copy the rest of the frontend source code
COPY frontend .

# Build frontend
RUN yarn build

# Use Python 3.9 as base image for the backend
FROM python:3.9-slim AS backend

# Set working directory for backend
WORKDIR /app/backend

# Copy backend source code
COPY backend/requirements.txt ./

# Install pip packages
RUN pip install --no-cache-dir -r requirements.txt

# Copy the rest of the backend source code
COPY backend .

# Expose port 3000 for the frontend
EXPOSE 3000

# Start the backend server
CMD ["python", "app.py"]
