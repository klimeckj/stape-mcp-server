FROM node:18-alpine
WORKDIR /app

COPY package*.json ./
RUN npm install \
 && echo "===== SDK server dir listing =====" \
 && ls -R node_modules/@modelcontextprotocol/sdk/dist/esm/server | head -40 \
 && echo "=========== end listing =========="

COPY . .

ENV NODE_ENV=production
EXPOSE 8080
CMD ["npm", "start"]
