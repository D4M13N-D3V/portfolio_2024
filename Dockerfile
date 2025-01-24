# We use Node 18 alpine as our base image for its small size and good performance
FROM node:18-alpine AS builder

# Set working directory for all build stages
WORKDIR /app

# Install dependencies for native builds
RUN apk add --no-cache libc6-compat

# Install dependencies based on the preferred package manager
COPY package.json package-lock.json* ./
RUN npm ci

# Copy all project files
COPY . .

# Next.js collects completely anonymous telemetry data about general usage.
# Learn more here: https://nextjs.org/telemetry
# Uncomment the following line if you want to disable telemetry during the build
# ENV NEXT_TELEMETRY_DISABLED 1

# Build Next.js based on the preferred package manager
RUN npm run build

# Production image, copy all the files and run next
FROM node:18-alpine AS runner

WORKDIR /app

# Create a non-root user
RUN addgroup --system --gid 1001 nodejs
RUN adduser --system --uid 1001 nextjs
RUN mkdir .next
RUN chown nextjs:nodejs .next

# Set node environment to production
ENV NODE_ENV production
ENV NEXT_TELEMETRY_DISABLED 1

# Copy package files
COPY --from=builder /app/package.json ./
COPY --from=builder /app/package-lock.json ./

# Copy necessary build files
COPY --from=builder --chown=nextjs:nodejs /app/.next/standalone ./
COPY --from=builder --chown=nextjs:nodejs /app/.next/static ./.next/static
COPY --from=builder --chown=nextjs:nodejs /app/public ./public
COPY --from=builder --chown=nextjs:nodejs /app/next.config.mjs ./

# Install only production dependencies
RUN npm ci --only=production

# Switch to non-root user
USER nextjs

# Set the correct permission for nextjs
RUN chmod 1001 .next

# Expose port 3000
EXPOSE 3000

# Set hostname to allow connections from outside the container
ENV PORT 3000
ENV HOSTNAME "0.0.0.0"

# Start the application
CMD ["node", "server.js"]