#!/bin/bash
# SDL 3.4.18 nativo para o Pi 5 (KMSDRM, udev, ALSA, PulseAudio, sem X/Wayland).
# Substitui o shim libs.aarch64/libSDL3.so.0, que não repassava a reconexão do controle.
# Uso, a partir da raiz do repositório (gera out/libSDL3.so.0):
#   docker run --rm --platform linux/arm64 -v "$PWD/out:/out" \
#     -v "$PWD/pi5/build-sdl3.sh:/b.sh" debian:bookworm bash /b.sh
set -ex
export DEBIAN_FRONTEND=noninteractive
apt-get update -qq
apt-get install -y -qq build-essential cmake ninja-build git pkg-config libudev-dev libdrm-dev libgbm-dev libegl-dev libgles-dev \
  libasound2-dev libpulse-dev libdbus-1-dev libibus-1.0-dev >/dev/null
git clone -q --depth 1 -b release-3.4.18 https://github.com/libsdl-org/SDL /tmp/SDL
cmake -S /tmp/SDL -B /tmp/b -G Ninja -DCMAKE_BUILD_TYPE=Release -DSDL_SHARED=ON -DSDL_STATIC=OFF -DSDL_TESTS=OFF -DSDL_UNIX_CONSOLE_BUILD=ON \
  -DSDL_X11=OFF -DSDL_WAYLAND=OFF -DSDL_KMSDRM=ON -DSDL_OPENGLES=ON -DSDL_OPENGL=OFF -DSDL_VULKAN=OFF \
  -DSDL_ALSA=ON -DSDL_PULSEAUDIO=ON -DSDL_PIPEWIRE=OFF -DSDL_JACK=OFF -DSDL_SNDIO=OFF \
  -DSDL_HIDAPI_JOYSTICK=ON -DSDL_LIBUDEV=ON > /out/cmake.log 2>&1 || { grep -iE -B2 -A8 "error" /out/cmake.log | head -60; exit 1; }
cmake --build /tmp/b
cp -L /tmp/b/libSDL3.so.0 /out/
