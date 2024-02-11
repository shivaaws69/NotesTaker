# (cd backend && python main.py) & (cd frontend && yarn && yarn start)


#!/bin/bash

# Start the backend
cd /app/backend
pip install -r requirements.txt
python app.py &

# Start the frontend
cd /app/frontend
yarn install
yarn dev
