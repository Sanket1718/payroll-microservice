FROM nginx:alpine
RUN addgroup -S devopsgroup && adduser -S devopsuser -G devopsgroup
RUN chown -R devopsuser:devopsgroup /var/cache/nginx /var/run /var/log/nginx
USER devopsuser
COPY index.html /usr/share/nginx/html/index.html
EXPOSE 80
