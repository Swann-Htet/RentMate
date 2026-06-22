FROM node:18-alpine

# Set working directory
WORKDIR /app

# Copy the root package.json
COPY package*.json ./

# Install root dependencies
RUN npm install

# Copy backend package files
COPY backend/package*.json ./backend/

# Install backend dependencies
RUN cd backend && npm install

# Copy the rest of the application
COPY . .

# Copy and make entrypoint executable
RUN chmod +x entrypoint.sh

# Expose port (as defined in server.js)
EXPOSE 3000

# Use entrypoint: runs DB setup then starts the server
ENTRYPOINT ["sh", "entrypoint.sh"]