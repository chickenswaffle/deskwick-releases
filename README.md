# Desk Wick — releases

Flashable Raspberry Pi images for **Desk Wick**, a touchscreen market terminal
and macropad that boots straight into a full-screen touch UI.

**→ [Download and setup instructions](https://chickenswaffle.github.io/deskwick-releases/)**

## Quick version

1. Grab `deskwick.img.xz` from [the latest release](../../releases/latest).
2. In Raspberry Pi Imager: *Use custom* → select the file → write. Imager's
   customisation dialog stays greyed out — from 2.0 it only customises images
   Imager downloaded itself — and there's nothing you need it for.
3. Boot with the screen attached, wait through one automatic reboot. The image
   creates its own account (`deskwick`, no password, SSH off) and starts.
4. For WiFi, or to SSH in, run [`configure-card.sh`](configure-card.sh) against
   the card's `bootfs` volume before that first boot. It writes the cloud-init
   `user-data` / `network-config` files the Pi reads on boot.

Runs on simulated market data until you add an API key, so you can confirm the
device works before setting anything up.

The image is a starting point, not the newest build — the device updates its own
app from this repo's `app-v*` releases. *Settings → System → Update*, or tick
*Update automatically*.

## What's on the image

- Raspberry Pi OS (Trixie, 64-bit) with the Desk Wick service preinstalled at
  `/opt/deskwick`
- Kiosk autostart under labwc, screen blanking disabled
- USB HID gadget support for driving another computer as a keyboard

## Reaching it from another browser

The editor at `http://<pi>:8080/editor` — and anything else that is not the
panel itself — needs the device's token. Read it off the screen under *Settings
→ System → Remote access*; it is not fetchable over the network, so the panel in
front of you is the only place to get one.

## Requirements

Raspberry Pi 4 or 5, an 800×480 or 1024×600 touchscreen, and an 8GB or larger
card.

---

This repo holds the download page and built images. Source lives separately.
