FROM node:18-alpine
WORKDIR /app

# install runtime deps
COPY package*.json ./
RUN npm install --omit=dev

# copy source
COPY . .

ENV NODE_ENV=production
EXPOSE 8080
CMD ["node", "src/http.js"]
