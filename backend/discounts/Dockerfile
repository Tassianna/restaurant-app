FROM node:16-slim

# Install curl for healthcheck
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
    curl \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

# Copy only package.json and package-lock.json first for dependency installation
COPY package*.json ./

# Install dependencies
RUN npm install --production \
    && npm cache clean --force \
    && mv /app/node_modules /node_modules

# Copy the rest of the application files
COPY . .

# Expose the port
EXPOSE 3002

# Start the application
CMD ["node", "server.js"]


