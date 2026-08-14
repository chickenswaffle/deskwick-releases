# Desk Wick — releases

Flashable Raspberry Pi images for **Desk Wick**, a touchscreen market terminal
and macropad that boots straight into a full-screen touch UI.

**→ [Download and setup instructions](https://chickenswaffle.github.io/deskwick-releases/)**

## Quick version

1. Grab `deskwick.img.xz` from [the latest release](../../releases/latest).
2. In Raspberry Pi Imager: *Use custom* → select the file.
3. Fill in Imager's customisation dialog — username, WiFi, SSH. None of that is
   baked into the image, so the Pi can't reach your network without it.
4. Write, boot with the screen attached, wait through one automatic reboot.

Runs on simulated market data until you add an API key, so you can confirm the
device works before setting anything up.

## What's on the image

- Raspberry Pi OS (Trixie, 64-bit) with the Desk Wick service preinstalled at
  `/opt/deskwick`
- Kiosk autostart under labwc, screen blanking disabled
- USB HID gadget support for driving another computer as a keyboard

## Requirements

Raspberry Pi 4 or 5, an 800×480 or 1024×600 touchscreen, and an 8GB or larger
card.

---

This repo holds the download page and built images. Source lives separately.
