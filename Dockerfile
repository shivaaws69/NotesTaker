# Use the official Python image as a base
FROM python:3.9-slim

# Set environment variables
ENV APP_HOME /app

# Create and set the working directory in the container
WORKDIR $APP_HOME

# Copy the backend code into the container at /app
COPY backend/ $APP_HOME/backend/

# Copy the frontend code into the container at /app/frontend/
COPY frontend/ $APP_HOME/frontend/

# Install node packages for frontend
RUN apt-get update && \
    apt-get install -y nodejs npm && \
    npm install --prefix $APP_HOME/frontend

# Install pip packages for backend
RUN pip install --no-cache-dir -r $APP_HOME/backend/requirements.txt

# Expose the port the app runs on
EXPOSE 3000

# Set up the start script
COPY start.sh $APP_HOME/

# Give start.sh executable permissions
RUN chmod +x $APP_HOME/start.sh

# Start the application
CMD ["/bin/bash", "-c", "./start.sh"]



# # Use the official Python image as a base
# FROM python:3.9-slim

# # Install necessary build dependencies for pyaudio
# RUN apt-get update && apt-get install -y \
#     gcc \
#     libasound-dev \
#     portaudio19-dev \
#     python3-dev \
#     && rm -rf /var/lib/apt/lists/*

# # Set the working directory in the container
# WORKDIR /app

# # Copy the requirements file into the container at /app
# COPY backend/requirements.txt /app/

# # Install the requirements
# RUN pip install --no-cache-dir -r requirements.txt

# # Copy the rest of the application code into the container at /app
# COPY . /app

# # Expose port 3000 for the frontend
# EXPOSE 3000

# # Specify the command to run on container start
# CMD [ "python", "app.py" ]
