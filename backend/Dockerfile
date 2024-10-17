# Use Node.js slim version
FROM node:16-slim

# Set the working directory
WORKDIR /app

# Copy the package.json and package-lock.json from the backend folder to the container
COPY ./backend/package*.json ./

COPY ./backend/ .
# Install the dependencies
RUN npm install

# Run the development server using npm
CMD ["npm", "run", "dev"]
