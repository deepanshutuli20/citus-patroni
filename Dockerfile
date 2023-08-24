# Start with the official Citus image
FROM citusdata/citus:latest

# Copy entrypoint script to set up Citus nodes
COPY docker-entrypoint.sh /docker-entrypoint.sh
RUN chmod +x /docker-entrypoint.sh

ENTRYPOINT ["/docker-entrypoint.sh"]
