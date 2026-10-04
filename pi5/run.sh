#!/bin/bash
# GTA San Andreas (Android v2.11.311) no Raspberry Pi 5 / RetroPie — github.com/ludufre/sa-pi5
cd "$(dirname "$0")"
export XDG_DATA_HOME="$PWD/conf"; mkdir -p conf
export LD_LIBRARY_PATH="$PWD/libs.aarch64:$PWD:$LD_LIBRARY_PATH"
# 8BitDo SN30 Pro (D-Input): mapeamento por posição (estilo Xbox) a partir do es_input.cfg.
# O mapeamento padrão do SDL trocava A/B e X/Y e lia L2/R2 como eixos (no controle são os botões 8/9).
export SDL_GAMECONTROLLERCONFIG="0500d640c82d00000161000000010000,8Bitdo SN30 Pro,a:b1,b:b0,x:b4,y:b3,back:b10,guide:b12,start:b11,leftstick:b13,rightstick:b14,leftshoulder:b6,rightshoulder:b7,lefttrigger:b8,righttrigger:b9,dpup:h0.1,dpdown:h0.4,dpleft:h0.8,dpright:h0.2,leftx:a0,lefty:a1,rightx:a2,righty:a3,platform:Linux,"
exec ./gtasa_linux > log.txt 2>&1
