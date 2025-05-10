############################
# ---- 1. BUILD stage ---- #
############################
FROM node:18-alpine AS build
WORKDIR /app

COPY package*.json ./
RUN npm install

# copy sources and compile -> dist/
COPY tsconfig.json ./
COPY src ./src
RUN npx tsc

###############################
# ---- 2. RUNTIME stage ----  #
###############################
FROM node:18-alpine
WORKDIR /app

COPY package*.json ./
RUN npm install --omit=dev

COPY --from=build /app/dist ./dist

ENV NODE_ENV=production
EXPOSE 8080
CMD ["node", "dist/http.js"]
