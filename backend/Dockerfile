FROM node:16-slim

RUN mkdir -p /home/node/app/node_modules && chown -R node:node /home/node/app

WORKDIR /home/node/app

COPY ./package*.json ./ 
RUN chown -R node:node ./package-lock.json

USER node

RUN npm install

COPY --chown=node:node . .

CMD ["npm", "run", "dev"]