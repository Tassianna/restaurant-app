FROM node:16-slim

WORKDIR /app

COPY ./client/package*.json ./

RUN npm install

COPY ./client/ .

CMD [ "npm", "run", "dev" ]