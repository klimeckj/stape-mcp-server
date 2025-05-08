############################
# ---- 1. BUILD stage ---- #
############################
FROM node:18-alpine AS build
WORKDIR /app

# 1‑a  Copy manifests and install *all* deps (dev‑deps required for tsc)
COPY package*.json ./
RUN npm install

# 1‑b  Copy the rest of the source and compile TypeScript → dist/
COPY . .
RUN npm run build          # runs "tsc" → dist/

###############################
# ---- 2. RUNTIME stage ----  #
###############################
FROM node:18-alpine
WORKDIR /app

# 2‑a  Copy manifests and install *runtime‑only* deps
COPY package*.json package-lock.json* ./
RUN npm install --omit=dev

# 2‑b  Copy the already‑compiled app
COPY --from=build /app/dist ./dist

# 2‑c  Final settings
ENV NODE_ENV=production
EXPOSE 8080
CMD ["node", "dist/http.js"]
