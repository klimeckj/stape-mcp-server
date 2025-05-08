# --- runtime‑only image ------------------------------------------
FROM node:18-alpine
WORKDIR /app

# 1. install production deps
COPY package*.json ./
RUN npm install --omit=dev

# 2. copy source (no compile step needed)
COPY . .

ENV NODE_ENV=production
EXPOSE 8080
CMD ["node", "src/http.js"]
