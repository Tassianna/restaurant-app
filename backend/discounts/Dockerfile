# Use a lightweight Node.js image
FROM node:16-slim

# Add curl for healthcheck
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
    curl \
    && rm -rf /var/lib/apt/lists/*

# Set the working directory
WORKDIR /app

# Copy package.json and package-lock.json (if available)
COPY package*.json ./

# Use npm ci for clean installs (faster and more reliable)
RUN npm ci

# Copy the rest of the application code
COPY . .

# Expose the port that the service will run on
EXPOSE 3002

# Optional: Set NODE_ENV for production
ENV NODE_ENV=production

# Optional: Add a health check to monitor service availability
HEALTHCHECK CMD curl --fail http://localhost:3002/ || exit 1

# Start the application
CMD ["node", "server.js"]

