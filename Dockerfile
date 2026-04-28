FROM nginx:alpine

# 1. Create the user
RUN addgroup -S devopsgroup && adduser -S devopsuser -G devopsgroup

# 2. Copy the HTML
COPY index.html /usr/share/nginx/html/index.html

# 3. CRITICAL: Redirect PID file and Cache to /tmp (which is world-writable)
RUN sed -i 's|/var/run/nginx.pid|/tmp/nginx.pid|g' /etc/nginx/nginx.conf && \
    sed -i '/http {/a \    proxy_temp_path /tmp/proxy_temp;\n    client_body_temp_path /tmp/client_body_temp;\n    fastcgi_temp_path /tmp/fastcgi_temp;\n    uwsgi_temp_path /tmp/uwsgi_temp;\n    scgi_temp_path /tmp/scgi_temp;' /etc/nginx/nginx.conf

# 4. Change Nginx to listen on 8080
RUN sed -i 's/listen\(.*\)80;/listen 8080;/' /etc/nginx/conf.d/default.conf

# 5. Fix permissions for the web directory just in case
RUN chown -R devopsuser:devopsgroup /usr/share/nginx/html /var/cache/nginx /var/log/nginx /etc/nginx/conf.d

USER devopsuser
EXPOSE 8080
CMD ["nginx", "-g", "daemon off;"]
