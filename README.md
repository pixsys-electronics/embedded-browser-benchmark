

podman run -d -v /var/run/wayland-0:/var/run/wayland-0 -v $(pwd):/data/app -v $(pwd)/dconf:/var/run/dconf -e WAYLAND_DISPLAY=/var/run/wayland-0 -e HOME=/data/app --userns=keep-id --user $(id -u):$(id -g) --device=/dev/dri localhost/cog:arm64

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