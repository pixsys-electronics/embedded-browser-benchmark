FROM debian:bookworm

# Environment configuration
ENV DEBIAN_FRONTEND=noninteractive \
    LANG=C.UTF-8 \
    WPE_BACKEND=fdo \
    COG_PLATFORM_WL_VIEW_FULLSCREEN=1

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
    libwayland-cursor0 \
    libxkbcommon0 \
    ca-certificates \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# COG looks for libWPEBackend-default.so but it's missing, so we create a symlink to an existing backend
RUN ln -s /usr/lib/x86_64-linux-gnu/libWPEBackend-fdo-1.0.so /usr/lib/x86_64-linux-gnu/libWPEBackend-default.so

    # Set Cog as the entrypoint
ENTRYPOINT ["entrypoint.sh"]
