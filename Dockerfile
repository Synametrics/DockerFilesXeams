# Use Java 21 as base image
FROM eclipse-temurin:21-jre

LABEL "com.synametrics.vendor"="Synametrics Technologies, Inc."
LABEL description="Xeams - eXtended Email and Messaging Server"



# Set environment variables
ENV INSTALL_DIR=/opt/Xeams
ENV RUNNING_INSIDE_DOCKER=yes

# Install required tools
RUN apt-get update && \
    apt-get install -y wget tar && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Create installation directory
RUN mkdir -p ${INSTALL_DIR}

# Download and extract Xeams to a temporary location
RUN wget -O /tmp/XeamsJava.tar https://www.xeams.com/files/XeamsJava.tar && \
    tar -xf /tmp/XeamsJava.tar -C /tmp && \
    tar -xzf /tmp/Xeams.tar.gz -C /tmp && \
    rm /tmp/XeamsJava.tar /tmp/Xeams.tar.gz

# Store initial Xeams installation for volume initialization
RUN mv /tmp/Xeams /opt/Xeams-initial

# Copy entrypoint script and make scripts executable
COPY docker-entrypoint.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/docker-entrypoint.sh && \
    chmod +x /opt/Xeams-initial/runAtBoot.sh

# Expose required ports
# 25 - SMTP
# 80 - HTTP
# 587 - SMTP Submission
# 465 - SMTPS
# 443 - HTTPS
# 5272 - XMPP
# 110 - POP3
# 143 - IMAP
# 993 - IMAPS
# 995 - POP3S
EXPOSE 25 80 587 465 443 5272 110 143 993 995

# Set working directory
WORKDIR ${INSTALL_DIR}

# Define volume for persistent data
VOLUME ${INSTALL_DIR}

# Set entrypoint
ENTRYPOINT ["/usr/local/bin/docker-entrypoint.sh"]

# Run Xeams
CMD ["./runAtBoot.sh"]
