# Use a small Ubuntu base image
FROM ubuntu:20.04

# Install necessary packages
RUN apt-get update \
    && apt-get install -y jq \
    && rm -rf /var/lib/apt/lists/*

# Set working directory
WORKDIR /app

# Copy your script and JSON files into the container
COPY merge_json.sh main.json /app/

# Make the script executable
RUN chmod +x merge_json.sh

# Run the script
CMD ["./merge-json.sh"]
