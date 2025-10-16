FROM node:18-alpine AS builder

WORKDIR /app

# Copy package files
COPY package*.json ./

# INSTALL ALL DEPENDENCIES (Vue needs dev deps!)
RUN npm ci

# Copy source code
COPY . .

# Build the Vue app
RUN npm run build

# Production stage
FROM nginx:alpine AS production

# Copy built Vue app (Vue outputs to DIST folder!)
COPY --from=builder /app/dist /usr/share/nginx/html

# Nginx config for Vue routing
COPY nginx.conf /etc/nginx/nginx.conf

EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]