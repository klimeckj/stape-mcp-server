FROM node:18-alpine
WORKDIR /app

COPY package*.json ./
RUN npm install \
 && echo "===== SDK server dir listing =====" \
 && ls -R node_modules/@modelcontextprotocol/sdk/dist/esm/server | head -40 \
 && echo "=========== end listing =========="

COPY . .

# 👇 new – print the first 10 lines of http.ts inside the build log
RUN echo "===== http.ts inside image =====" \
 && head -n 10 src/http.ts \
 && echo "=========== end =============="

ENV NODE_ENV=production
EXPOSE 8080
CMD ["npm", "start"]
