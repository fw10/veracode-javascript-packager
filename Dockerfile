FROM golang:1.19

WORKDIR /app

# Download all required dependencies
COPY go.mod ./
COPY go.sum ./
RUN go mod download

# Copy all .go files into the container
COPY *.go ./

# Copy the file to compile the app into the container
COPY create-releases.sh ./

# Build the app
RUN ./create-releases.sh docker

# Change the directory into the JS app to package. This means we can provide `-source . -target .` which is less confusing for users
WORKDIR /app/js-app

# Run the tool
ENTRYPOINT ["/app/veracode-js-packager", "-source", ".", "-target", "."]
