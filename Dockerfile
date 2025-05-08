############################
# ---- 1. BUILD stage ---- #
############################
FROM node:18-alpine AS build
WORKDIR /app

# 1‑a  install ALL deps (needs tsc from dev‑deps)
COPY package*.json ./
RUN npm install

# 1‑b  copy sources & compile → dist/
COPY . .
RUN npm run build

###############################
# ---- 2. RUNTIME stage ----  #
###############################
FROM node:18-alpine
WORKDIR /app

# runtime deps only
COPY package*.json package-lock.json* ./
RUN npm install --omit=dev
COPY --from=build /app/dist ./dist

ENV NODE_ENV=production
EXPOSE 8080
CMD ["node", "dist/http.js"]
