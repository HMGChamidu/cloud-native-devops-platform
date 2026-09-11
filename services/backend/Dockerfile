# Stage 1: Dependencies
FROM node:20-alpine AS builder
WORKDIR /app
COPY package*.json ./
RUN npm install --omit=dev

# Stage 2: Minimal Runtime
FROM node:20-alpine AS runner
WORKDIR /app
RUN addgroup -S appgroup && adduser -S appuser -G appgroup
COPY package*.json ./
COPY --from=builder /app/node_modules ./node_modules
COPY server.js ./

USER appuser
EXPOSE 5000
CMD ["npm", "start"]
