FROM nginx:alpine

# Create non-root user
RUN addgroup -S devopsgroup && adduser -S devopsuser -G devopsgroup

# Copy web file
COPY index.html /usr/share/nginx/html/index.html

# Fix ALL possible Nginx paths for non-root usage
RUN mkdir -p /var/cache/nginx/client_temp /var/cache/nginx/proxy_temp /var/cache/nginx/fastcgi_temp /var/cache/nginx/uwsgi_temp /var/cache/nginx/scgi_temp && \
    chown -R devopsuser:devopsgroup /var/cache/nginx /var/run /var/log/nginx /etc/nginx/conf.d && \
    chmod -R 770 /var/cache/nginx /var/run /var/log/nginx /etc/nginx/conf.d

# Use a non-standard PID path in a user-writable folder
RUN sed -i 's|/var/run/nginx.pid|/tmp/nginx.pid|g' /etc/nginx/nginx.conf

USER devopsuser

# Ensure we listen on 8080
RUN sed -i 's/listen\(.*\)80;/listen 8080;/' /etc/nginx/conf.d/default.conf

EXPOSE 8080
CMD ["nginx", "-g", "daemon off;"]
