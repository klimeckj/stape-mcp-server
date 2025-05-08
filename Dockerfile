# ---- build stage -------------------------------------------------
FROM node:18-alpine AS build
WORKDIR /app
COPY package*.json ./
RUN npm install --omit=dev
COPY . .
RUN npm run build      # compiles src/ → dist/

# ---- runtime stage -----------------------------------------------
FROM node:18-alpine
WORKDIR /app
COPY --from=build /app /app
ENV NODE_ENV=production
EXPOSE 8080
CMD ["node","dist/http.js"]
