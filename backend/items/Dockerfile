FROM node:16-slim

WORKDIR /app

COPY package*.json ./

RUN npm install

COPY . .

EXPOSE 88

CMD ["node", "server.js"]