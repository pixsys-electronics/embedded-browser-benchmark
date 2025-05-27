# Performance comparison between embedded web-browsers
## Description
This repository contains a brief comparison between 3 different web browsers w.r.t. their resource usage (CPU, RAM) and compatibility on an ARM64 architecture. This test has been done to explore the available solutions for the embedded devices (in particular web panels) to find something different from the current state of art (Chrome). Apart from Chrome itself, 2 new web-browsers have been tested:

- QTWebBrowser, which is a simple browser application built on top of the [QTWebEngine](https://doc.qt.io/qt-6/qtwebengine-overview.html). This engine uses Chromium under the hood, which is the same engine used by Chrome.

- [COG](https://github.com/Igalia/cog), which is a single-window laucher, that provided ONLY single-page application in kiosk mode. This browser uses WebKit, a web engine developed by Apple, and it's ported from the [WebKit WPE](https://trac.webkit.org/wiki/WPE) (WebKit for embedded devices).

## Setup
If you'd like to test it yourself, you can deploy a working web-browser on ARM64 for both COG and QtWebBrowser using Docker.

### COG
For COG, you first need to have both an *entrypoint.sh* script and the Dockerfile inside your target device. Then, run:

```bash
# build on target
podman build -t cog:arm64 -f cog-arm64.Dockerfile .
# run on target
podman run -v /var/run/wayland-0:/var/run/wayland-0 -v $(pwd):/data/app -v $(pwd)/dconf:/var/run/dconf -e WAYLAND_DISPLAY=/var/run/wayland-0 -e XDG_RUNTIME_DIR=/var/run -e HOME=/data/app --userns=keep-id --user $(id -u):$(id -g) --device=/dev/dri --device=/dev/input localhost/cog:arm64
```

### QT
For QT6, you first need to get yourself the *simplebrowser* example from the [github](https://github.com/qt/qtwebengine). Make sure the QT version installed inside your container is the same as the version of the simplebrowser example. To change simplebrowser version, just choose the respective branch in github. The simplebrowser example should be [here](https://github.com/qt/qtwebengine/tree/dev/examples/webenginewidgets/simplebrowser). In this repository, *simplebrowser* is 6.7.3. Then, make sure you have the example folder and the Dockerfile inside your target device, then run:

```bash
# build on target
podman build -t qt6-browser:arm64 -f qt6-arm64.Dockerfile .
```

## Results

Each web-browser have been tested against 3 different workloads:

- browserbench

podman run -d -v /var/run/wayland-0:/var/run/wayland-0 -v /home/user/qt6-environment:/data/app -e WAYLAND_DISPLAY=/var/run/wayland-0 -e HOME=/data/app/tmp --userns=keep-id --user $(id -u):$(id -g) --device=/dev/dri localhost/qt-runtime:arm64

## Setup
podman run -v /var/run/wayland-0:/var/run/wayland-0 -v $(pwd):/data/app -v $(pwd)/dconf:/var/run/dconf -e WAYLAND_DISPLAY=/var/run/wayland-0 -e XDG_RUNTIME_DIR=/var/run -e HOME=/data/app --userns=keep-id --user $(id -u):$(id -g) --device=/dev/dri --device=/dev/input localhost/cog:arm64

# Report
The following browsers have been tested against several tests:
- QtWebEngine: Chromium-based
- COG: WebKit-based
- Chrome: Chromium-based

## pixsys.net
TODO

## browserbench.net
||QtWebEngine|COG|CodeSYS|
|-|-|-|-|
|RAM|||
|CPU|||

## collaudo
||QtWebEngine|COG|Chrome|
|-|-|-|-|
|RAM (MB)|x|300|450|
|CPU (idle) (%)|x|30|35|
|CPU (interaction) (%)|x|55|65|