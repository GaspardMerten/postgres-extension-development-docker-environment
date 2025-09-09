FROM ubuntu:24.04

# Install Postgres 16, build tools, and LLVM 15
RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y \
        postgresql-16 \
        build-essential wget ca-certificates \
        make git postgresql-server-dev-16 && \
    rm -rf /var/lib/apt/lists/*

COPY ./extension /usr/local/src/extension
WORKDIR /extension

# Copy pg-reload script
COPY pg-reload /usr/local/bin/pg-reload
RUN chmod +x /usr/local/bin/pg-reload

# Expose Postgres port
EXPOSE 5432

# Copy start script
COPY start.sh /usr/local/bin/start.sh
RUN chmod +x /usr/local/bin/start.sh

# Start PostgreSQL
CMD ["/usr/local/bin/start.sh"]
