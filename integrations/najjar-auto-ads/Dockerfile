FROM node:20-alpine AS frontend
WORKDIR /frontend
ARG VITE_API_BASE_URL=/api
ENV VITE_API_BASE_URL=$VITE_API_BASE_URL
COPY frontend/package.json frontend/package-lock.json* ./
RUN npm install
COPY frontend/ ./
RUN npm run build

FROM node:20-alpine AS build
WORKDIR /app
RUN apk add --no-cache python3 make g++
COPY backend/package.json backend/package-lock.json* ./
RUN npm install
COPY backend/tsconfig.json ./
COPY backend/src ./src
RUN npm run build

FROM node:20-alpine
WORKDIR /app
ENV NODE_ENV=production
ENV NAJJAR_DATA_DIR=/app/data
RUN apk add --no-cache python3 make g++
COPY backend/package.json backend/package-lock.json* ./
RUN npm install --omit=dev
COPY --from=build /app/dist ./dist
COPY --from=frontend /frontend/dist ./public
RUN mkdir -p /app/data
EXPOSE 4000
CMD ["node", "dist/server.js"]
