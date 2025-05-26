FROM arm64v8/debian:bookworm

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
    libwayland-cursor0 \
    wayland-protocols \
    wayland-scanner++ \
    libxkbcommon0 \
    libinput10 \
    ca-certificates \
    && apt-get clean && rm -rf /var/lib/apt/lists/*


ENV COG_PLATFORM_WL_VIEW_FULLSCREEN=1

RUN ln -s /usr/lib/aarch64-linux-gnu/libWPEBackend-fdo-1.0.so /usr/lib/aarch64-linux-gnu/libWPEBackend-default.so

    # Set Cog as the entrypoint
ENTRYPOINT ["cog","-P","wl","192.168.1.61/webvisu.htm"]
