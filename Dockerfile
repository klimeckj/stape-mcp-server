############################
# ---- 1. BUILD stage ---- #
############################
FROM node:18-alpine AS build
WORKDIR /app

# install ALL dependencies (dev + prod)
COPY package*.json ./
RUN npm install

# copy sources and compile TypeScript → dist/
COPY tsconfig.json ./
COPY src ./src
RUN npm run build

###############################
# ---- 2. RUNTIME stage ----  #
###############################
FROM node:18-alpine
WORKDIR /app

# install only runtime dependencies
COPY package*.json ./
RUN npm install --omit=dev

# copy compiled JS
COPY --from=build /app/dist ./dist

ENV NODE_ENV=production
EXPOSE 8080
CMD ["node", "dist/http.js"]
