# Use Debian 12.10 base image for ARM64 (armv8)
FROM debian:12.10

# Set environment variables
ENV DEBIAN_FRONTEND=noninteractive
ENV QT_QPA_PLATFORM=wayland
ENV DISPLAY=:0

# Install dependencies
RUN apt-get update && apt-get install -y \
    build-essential \
    cmake \
    ninja-build \
    qt6-base-dev \
    qt6-declarative-dev \
    qt6-webengine-dev \
    qt6-webengine-dev-tools \
    qt6-tools-dev \
    qt6-tools-dev-tools \
    qt6-wayland-dev \
    libwayland-dev \
    wayland-protocols \
    libqt6waylandclient6 \
    libqt6waylandcompositor6 \
    libwayland-client0 \
    libwayland-egl1 \
    libegl1 \
    mesa-utils \
    libgl1-mesa-dri \
    libglx-mesa0 \
    qt6-wayland \
    pkg-config \
    git \
    curl \
    sudo \
    dbus \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /home/app

COPY simplebrowser simplebrowser

WORKDIR /home/app/simplebrowser

# Build the simplebrowser using Ninja + CMake
RUN mkdir -p build && cd build && \
    cmake .. -GNinja && \
    ninja

# Set working directory to the built binary
WORKDIR /home/app/simplebrowser/build

# # Run the browser
CMD ["./simplebrowser"]