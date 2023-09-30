# Use the base image of your choice (Alpine or Debian)
FROM debian:11

# Install OpenSSL (no need to update on Debian, use 'apt-get' for package management)
RUN apt-get update \
    && apt-get install -y openssl nginx \
    && apt-get clean

RUN mkdir -p /etc/nginx/ssl

# Generate a new SSL private key (unencrypted)
RUN openssl genpkey -algorithm RSA -out /etc/nginx/ssl/ssl_priv_key.key

# Generate a self-signed SSL certificate with the specified subject
# Customize the subject information and file name as needed
RUN openssl req -new -key /etc/nginx/ssl/ssl_priv_key.key \
    -out /etc/nginx/ssl/ssl_self_signed_cert.csr \
    -subj "/C=US/ST=BW/L=HN/O=42-HN/OU=Magrathea/CN=pgorner.42.fr"

# Generate the final SSL certificate using the CSR and private key
# The output file should be /etc/nginx/ssl/ssl_final_cert.crt
RUN openssl x509 -req -days 365 \
    -in /etc/nginx/ssl/ssl_self_signed_cert.csr \
    -signkey /etc/nginx/ssl/ssl_priv_key.key \
    -out /etc/nginx/ssl/ssl_final_cert.crt

# Clean up the CSR (no longer needed)
RUN rm /etc/nginx/ssl/ssl_self_signed_cert.csr

# Copy your NGINX configuration
COPY /conf/nginx.conf /etc/nginx/nginx.conf

# Create the directory for NGINX to store runtime files
RUN mkdir -p /run/nginx

# Expose port 443
EXPOSE 443

# Start NGINX in the foreground
RUN echo "INFO: SETUP DONE"

CMD ["nginx", "-g", "daemon off;"]
