FROM node:18-alpine
WORKDIR /app

# install runtime + ts‑node deps
COPY package*.json ./
RUN npm install

# copy source
COPY . .

ENV NODE_ENV=production
EXPOSE 8080
CMD ["npm", "start"]
