# Use the official Node.js image as a base image for the frontend
FROM node:latest AS frontend
WORKDIR /app/frontend
COPY frontend/package*.json ./
RUN npm install
COPY frontend/ .
RUN npm run build

# Use the official Python image as a base image for the backend
FROM python:latest AS backend
WORKDIR /app/backend
COPY backend/requirements.txt ./
RUN pip install --no-cache-dir -r requirements.txt
COPY backend/ .

# Create a multi-stage build to optimize the final image size
FROM node:alpine
WORKDIR /app
COPY --from=frontend /app/frontend/out /app/frontend/out
COPY --from=backend /app/backend /app/backend
COPY start.sh /app/start.sh
RUN chmod +x /app/start.sh

# Expose the port
EXPOSE 3000

# Define environment variables
ENV NODE_ENV=production
ENV PORT=3000

# Command to run the application
CMD ["/app/start.sh"]
