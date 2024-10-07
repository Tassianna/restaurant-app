FROM node:16-slim AS build

WORKDIR /app

COPY ./package*.json ./
RUN npm install && npm install --save-dev @babel/plugin-proposal-private-property-in-object

COPY . .

RUN npm run build

# Stage 2: Serve with Nginx
FROM nginx:latest

# Remove default Nginx static assets
RUN rm -rf /usr/share/nginx/html/*


COPY --from=build /app/build /usr/share/nginx/html

EXPOSE 80

# Start Nginx
CMD ["nginx", "-g", "daemon off;"]