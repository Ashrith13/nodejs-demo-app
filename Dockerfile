# Use a smaller Node.js base image for faster builds and reduced size
FROM node:18-slim

# Set a custom working directory inside the container
WORKDIR /usr/src/app

# Copy only the package files and install dependencies
COPY package*.json ./
RUN npm ci --omit=dev

# Copy the remaining source code into the container
COPY . .

# Set environment variable
ENV NODE_ENV=production

# Expose a different port (e.g., 8080 instead of 3000)
EXPOSE 8080

# Run the application with node instead of npm (assuming entry point is index.js)
CMD ["node", "index.js"]
