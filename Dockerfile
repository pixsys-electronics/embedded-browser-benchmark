FROM arm64v8/debian:bullseye

# Environment configuration
ENV DEBIAN_FRONTEND=noninteractive \
    LANG=C.UTF-8 \
    WPE_BACKEND=fdo

# Install dependencies
RUN apt-get update && apt-get install -y \
    cog \
    libwpe-1.0-1 \
    libwpebackend-fdo-1.0-1 \
    libglib2.0-0 \
    libegl1 \
    libgles2 \
    libwayland-client0 \
    libwayland-egl1 \
    libxkbcommon0 \
    ca-certificates \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# Set Cog as the entrypoint
ENTRYPOINT ["cog", "https://example.com"]
