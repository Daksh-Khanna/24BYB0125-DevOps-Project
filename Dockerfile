# ---- Online Portfolio Website: Docker image ----
FROM nginx:alpine

# Remove default nginx site
RUN rm -rf /usr/share/nginx/html/*

# Copy static site files
COPY src/ /usr/share/nginx/html/

# Custom nginx config (adds a /health endpoint used by Nagios)
COPY nginx.conf /etc/nginx/conf.d/default.conf

EXPOSE 80

HEALTHCHECK --interval=30s --timeout=3s \
  CMD wget -q -O- http://localhost/health.html || exit 1

CMD ["nginx", "-g", "daemon off;"]
