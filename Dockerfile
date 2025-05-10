FROM node:18-alpine
WORKDIR /app

COPY package*.json ./
RUN npm install \
 && echo "===== server/index.js =====" \
 && head -n 40 node_modules/@modelcontextprotocol/sdk/dist/esm/server/index.js \
 && echo "===== server/stdio.js =====" \
 && head -n 40 node_modules/@modelcontextprotocol/sdk/dist/esm/server/stdio.js \
 && echo "=========== end ==========="

COPY . .

# current debug
RUN echo "===== shared dir listing =====" \
 && ls node_modules/@modelcontextprotocol/sdk/dist/esm/shared | head -20 \
 && echo "===== shared/transport.js =====" \
 && head -n 40 node_modules/@modelcontextprotocol/sdk/dist/esm/shared/transport.js \
 && echo "=========== end listing =========="

ENV NODE_ENV=production
EXPOSE 8080
CMD ["npm", "start"]
