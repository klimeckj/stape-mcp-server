############################
# ---- 1. BUILD stage ---- #
############################
FROM node:18-alpine AS build
WORKDIR /app

# Install ALL deps (needs tsc from dev‑deps)
COPY package*.json ./
RUN npm install

# Copy sources & compile -> dist/
COPY . .
RUN npm run build

###############################
# ---- 2. RUNTIME stage ----  #
###############################
FROM node:18-alpine
WORKDIR /app

# Copy manifests and install runtime deps only
COPY package*.json ./
RUN npm install --omit=dev

# Copy the compiled JS
COPY --from=build /app/dist ./dist

ENV NODE_ENV=production
EXPOSE 8080
CMD ["node", "dist/http.js"]
