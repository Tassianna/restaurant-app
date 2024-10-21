FROM node:16-slim

WORKDIR /app

COPY ./client/package*.json ./

RUN npm install

COPY ./client/ .

#install curl for testing connectivity
RUN apt-get update && apt-get install -y curl && apt-get clean 

CMD [ "npm", "run", "dev" ]