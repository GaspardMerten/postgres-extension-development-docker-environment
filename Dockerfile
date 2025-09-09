FROM ubuntu:24.04

# Install Postgres 16, build tools, and LLVM 15
RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y \
        postgresql-16 \
        build-essential wget ca-certificates \
        make git && \
    rm -rf /var/lib/apt/lists/*

# Ensure LLVM 15 is default
RUN update-alternatives --install /usr/bin/clang clang /usr/bin/clang-15 100 && \
    update-alternatives --install /usr/bin/clang++ clang++ /usr/bin/clang++-15 100 && \
    update-alternatives --install /usr/bin/llvm-config llvm-config /usr/bin/llvm-config-15 100

# Set environment variables to force build with LLVM 15
ENV CC=clang-15
ENV CXX=clang++-15
ENV LLVM_CONFIG=/usr/lib/llvm-15/bin/llvm-config
ENV PATH="/usr/lib/llvm-15/bin:${PATH}"

# Copy your PostgreSQL extension source
COPY extension /extension
WORKDIR /extension

# Build the extension
RUN make clean && make

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
