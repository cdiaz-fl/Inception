FROM alpine:3.18.5

#RUN apk --no-cache add docker

# Expose Portainer port
#EXPOSE 9443

#CMD ["docker", "run", "-d", "-p", "9000:9000", "--name", "portainer_in", "--restart=always", "-v", "/var/run/docker.sock:/var/run/docker.sock", "-v", "portainer_data:/data", "portainer/portainer-ce:latest"]

# Install dependencies
RUN apk --no-cache add curl tar

# Download and install Portainer
RUN curl -L -o /tmp/portainer.tar.gz https://github.com/portainer/portainer/releases/download/2.19.4/portainer-2.19.4-linux-amd64.tar.gz \
    && tar -xzf /tmp/portainer.tar.gz -C /tmp \
    && chmod +x /tmp/portainer/portainer \
    && mv /tmp/portainer /usr/local/bin/

# Expose Portainer port
EXPOSE 9443

# Command to run Portainer
CMD /usr/local/bin/portainer/portainer
