FROM golang:1.19-alpine

# Set destination for COPY
WORKDIR /app

# Set up ZSH
RUN apk --no-cache add zsh curl git
RUN mkdir -p /home/main/.antigen
RUN curl -L git.io/antigen > /home/main/.antigen/antigen.zsh

# Use custom .docker ZSH config file
COPY .dockershell.sh /home/main/.zshrc

# Start ZSH
RUN /bin/zsh /home/main/.zshrc

# Download Go modules or init them
RUN go mod init http-recover
COPY go.mod .
COPY go.sum .
RUN go mod download

# Copy the source code. Note the slash at the end, as explained in
# https://docs.docker.com/engine/reference/builder/#copy
COPY *.go ./

# Build
RUN go build -o /docker-recover

# This is for documentation purposes only.
# To actually open the port, runtime parameters
# must be supplied to the docker command.
EXPOSE 3000

# (Optional) environment variable that our dockerised
# application can make use of. The value of environment
# variables can also be set via parameters supplied
# to the docker command on the command line.
#ENV HTTP_PORT=8081

# Run
CMD [ "/docker-recover" ]
