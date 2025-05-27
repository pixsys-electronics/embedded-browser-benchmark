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
# run on target
podman run -v /var/run/wayland-0:/var/run/wayland-0 -e WAYLAND_DISPLAY=/var/run/wayland-0 -e XDG_RUNTIME_DIR=/var/run -v /home/user/qt6-environment/tmp:/home/app/tmp -v /home/user/qt6-environment/dconf:/var/run/dconf -e HOME=/home/app/tmp --userns=keep-id --user $(id -u):$(id -g) --device=/dev/dri localhost/qt6-browser:arm64
```

**Note: these container have been tested against WP820-A-P2 and WP620-A-P2. The P4 family has compatibility problems with Panther drivers of the GPU: for QT, the page shows but it crashes at almost every interaction, while for COG the browser window doesn't appear. For a working version with full-library compatibility between the container and the host machine, check [this repo](https://github.com/pixsys-electronics/qt-arm64-demo).**

## Results
The target device is a WP820-A-P2. Each resource usage is comprehensive of the basic services running on a web panel (dbus, pixsys-monitor, weston, wp-config, pixsys-portal, NetworkManager). The base resources usage, in this case, are:
- CPU: 1%
- RAM: 260MB

The chromium@wp-control and chromium@main-app have been killed to ensure a stable environment.

Each web-browser has been tested against 3 different workloads:

- [browserbench.org](https://browserbench.org/) (speedometer): test the responsiveness
- [pixsys.net](https://www.pixsys.net/): animated banner and overlays
- collaudo software (webvisu.htm default page): interaction with HTML5 components

## pixsys.net
||QtWebEngine|COG|Chrome|
|-|-|-|-|
|RAM (MB)|500|450|500|
|CPU (idle) (%)|65|60|60|
|CPU (interaction) (%)|90|90|90|

## browserbench.net
||QtWebEngine|COG|Chrome|
|-|-|-|-|
|Speedometer (points)|X|X|0.3|

**Note: QtWebEngine stops at a fixed test step, showing the "broken page" icon and freezing the whole device. The RAM usage doesn't exceed the limit imposed by podman (it doesn't go over 500MB), so the icon is a mistery. COG refuses to run the benchmark, and due to the lack of logging, the cause is unknown.**

## collaudo
||QtWebEngine|COG|Chrome|
|-|-|-|-|
|RAM (MB)|450|300|450|
|CPU (idle) (%)|30|20|35|
|CPU (interaction) (%)|75|55|70|

**Note: using COG, HTML components *input type=range* like the slider and the big knob are not working as expected: the slider moves only when short presses are performed very close to the knob, while the big knob doesn't move at all. It looks like a continuous motion event is not handled correctly by the browser. These interactions, in chromium-based browsers, work correctly** 