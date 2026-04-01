FROM node:22-alpine

# Use corepack to enable pnpm
RUN corepack enable && corepack prepare pnpm@latest --activate

WORKDIR /usr/src/app

# Copy dependency files first to leverage Docker cache
COPY package.json pnpm-lock.yaml ./

# Install dependencies
RUN pnpm install

# Copy the rest of the application files
COPY . .

# Start the application in development watch mode
CMD ["pnpm", "run", "start:dev"]
