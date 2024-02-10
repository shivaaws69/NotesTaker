# Use the official lightweight Node.js 16 image
FROM node:16-alpine AS frontend

# Set the working directory in the container
WORKDIR /app/frontend

# Copy the frontend package.json and yarn.lock files
COPY frontend/package*.json ./

# Install frontend dependencies
RUN yarn install --frozen-lockfile

# Copy the frontend source code
COPY frontend .

# Build the frontend
RUN yarn build

# Use the official Python 3 image
FROM python:3.9-slim AS backend

# Set environment variables
ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONUNBUFFERED 1

# Set the working directory in the container
WORKDIR /app/backend

# Copy the backend requirements file
COPY backend/requirements.txt ./

# Install backend dependencies
RUN pip install --upgrade pip setuptools

RUN pip install --no-cache-dir -r requirements.txt

# Copy the backend source code
COPY backend .

# Expose port 8000 to allow communication to/from server
EXPOSE 8000

# Set the entrypoint to run the backend server
ENTRYPOINT ["python", "app.py"]

# Use a multi-stage build to reduce final image size
FROM node:16-alpine

# Set environment variables
ENV NODE_ENV production

# Set the working directory in the container
WORKDIR /app

# Copy the built frontend from the previous stage
COPY --from=frontend /app/frontend/public ./frontend/public

# Copy the built backend from the previous stage
COPY --from=backend /app/backend .

# Expose port 3000 for the frontend
EXPOSE 3000

# Run the frontend
CMD ["yarn", "start"]
