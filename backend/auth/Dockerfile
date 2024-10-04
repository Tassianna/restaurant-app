FROM node:16-slim

# Add curl for healthcheck
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
    curl \
    && rm -rf /var/lib/apt/lists/*  # Clean up apt cache

WORKDIR /app

# Copy and install dependencies
COPY package*.json ./

# Install dependencies, clean up npm cache, and move node_modules
RUN npm install --production \
    && npm cache clean --force \
    && mv /app/node_modules /node_modules

# Copy the rest of the application files
COPY . .

# Expose the required port
EXPOSE 3001

# Start the application
CMD ["node", "server.js"]
