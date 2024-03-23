# Use a small Ubuntu base image
FROM ubuntu:latest as build

# Install necessary packages
RUN apt-get update \
    && apt-get install -y jq \
    && rm -rf /var/lib/apt/lists/*

# Set working directory
WORKDIR /json-merger

# Copy your script and JSON files into the container
COPY merge-json.sh main.json /json-merger/

# Copy the json_collection directory into the container
COPY json_collection /json-merger/json_collection

# Make merge-json.sh executable
RUN chmod +x merge-json.sh

# Execute merge-json.sh in the build stage
RUN ./merge-json.sh

# Use mockoon/cli as base image
FROM mockoon/cli

# Set working directory
WORKDIR /mockoon

# Copy generated JSON file from the build stage to the current image
COPY --from=build /json-merger/build/mock-collection.json /mockoon/mock-collection.json

# Expose port 3000
EXPOSE 3000

# Set command to run mockoon/cli with specified data file and port
CMD ["--data", "/mockoon/mock-collection.json", "--port", "3000"]
