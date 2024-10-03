FROM node:16-slim

WORKDIR /app

COPY package*.json ./

# Using npm ci for cleaner installs
RUN npm ci

COPY . .

EXPOSE 3003  
# Change to the port your app listens to

# Optional: Set NODE_ENV for production
ENV NODE_ENV=production

# Optional: Add a health check
HEALTHCHECK CMD curl --fail http://localhost:3003/ || exit 1

CMD ["node", "server.js"]
