# Use lightweight official Node.js image
FROM node:18-alpine

# Set working directory inside the container
WORKDIR /usr/src/app

# Copy dependency definitions
COPY package*.json ./

# Install production dependencies
RUN npm install --only=production

# Copy application code into container
COPY . .

# Expose application port
EXPOSE 3000

# Command to run the application
CMD ["node", "server.js"]