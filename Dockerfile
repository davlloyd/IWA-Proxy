# Container to provide an intermediate proxy service that looks after windows 
# authentication for services that do not support it and then passes traffic on.

# Using the Ubuntu image for Debian package support 
FROM ubuntu:16.04

# Add metadata for container identification
LABEL author="David Lloyd" \
      maintainer="davidlloyd0@mgail.com" \
      version="1.0" \
      description="This image uses the CNTML (http://cntlm.sourceforge.net/) \
    application to provide an Integrated Windows Authentication web proxy for \
    those services that do not support it natively. Examples can include call \
    home faclities without Windows support or Linux desktops using a non \
    windows supporting browser"

# Log in as root user
USER root

# Default environment variable to define listening port to apply to config
ENV listenport=0.0.0.0:3128

# Port which needs to be listened to as cntlm will be bound to it. Need to use '-p 3128:3128' arg in docker run
EXPOSE 3128

# Apply latest updates for OS
RUN apt-get update && apt-get install -y \
    && apt-get install -y apt-utils 

# Copy shell script that controls the creation of configuration and service executation activities
COPY entrypoint.sh /

# Copy install source of CNTLM for installation
COPY cntlm_0.92.3-1ubuntu1_amd64.deb /tmp/

# Run installation routine
RUN dpkg -i /tmp/cntlm_0.92.3-1ubuntu1_amd64.deb; apt-get -fy install

# Set entrypoint to run script at each container run task
ENTRYPOINT ["/bin/bash", "/entrypoint.sh"]

CMD ["/bin/sh -c"]
