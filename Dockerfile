# Build stage
FROM node:18-alpine AS builder

# Set working directory
WORKDIR /app

# Install dependencies needed for build
RUN apk add --no-cache libc6-compat

# Copy package files
COPY package.json package-lock.json* ./

# Install dependencies using clean install
RUN npm ci

# Copy all project files
COPY . .

# Build the application
RUN npm run build

# Production stage
FROM node:18-alpine AS runner

WORKDIR /app

# Create a non-root user
RUN addgroup --system --gid 1001 nodejs
RUN adduser --system --uid 1001 nextjs

# Set environment variables
ENV NODE_ENV production
ENV NEXT_TELEMETRY_DISABLED 1

# Copy necessary files from builder
COPY --from=builder /app/public ./public
COPY --from=builder /app/next.config.mjs ./
COPY --from=builder /app/package.json ./
COPY --from=builder /app/package-lock.json ./

# Copy build output with proper ownership
COPY --from=builder --chown=nextjs:nodejs /app/.next/static ./.next/static

# Conditionally copy standalone or regular build output
COPY --from=builder --chown=nextjs:nodejs /app/.next/standalone ./
COPY --from=builder --chown=nextjs:nodejs /app/.next/server ./server
COPY --from=builder --chown=nextjs:nodejs /app/.next/required-server-files.json ./.next/required-server-files.json

# Install production dependencies
RUN npm ci --only=production

# Switch to non-root user
USER nextjs

# Expose port and set hostname
EXPOSE 3000
ENV PORT 3000
ENV HOSTNAME "0.0.0.0"

# Start the application
CMD ["node", "server.js"]