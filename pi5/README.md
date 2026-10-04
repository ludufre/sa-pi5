# GTA San Andreas no Raspberry Pi 5 (RetroPie)

Fork do [cdeletre/gtasa_linux](https://github.com/cdeletre/gtasa_linux) ajustado para um
Raspberry Pi 5 8 GB com Raspberry Pi OS Bookworm 64-bit + RetroPie, rodando direto no
KMSDRM (sem X) a partir do EmulationStation.

## O que muda em relação ao upstream

- **Limitador de 30 FPS desligado.** O `libGame.so` v2.11.311 nasce com a MobileSetting 30
  ligada (oculta no menu de controle) e `DoGameState` usa 30 FPS como alvo enquanto ela for
  diferente de zero. `source/hooks/game_linux.c` zera o valor a cada quadro, a menos que
  `fps_cap_30 1` esteja no `gtasa_nx.cfg`.
- **Lançador para o RetroPie** (`pi5/`), sem depender do PortMaster.
- **Mapeamento do 8BitDo SN30 Pro (D-Input)** no `run.sh`: o mapeamento padrão do SDL trocava
  A/B e X/Y e lia L2/R2 como eixos (no controle são os botões 8 e 9).

## Build (Mac Apple Silicon ou qualquer host arm64 com Docker)

```sh
docker buildx build --platform linux/arm64 -f Containerfile --target artifact \
  --output type=local,dest=out .
```

## Instalação no Pi

Os arquivos do jogo vêm de uma cópia comprada na Play Store (veja `ASSET_PREPARATION.md`) e
não fazem parte deste repositório.

```text
~/RetroPie/roms/ports/
├── Grand Theft Auto San Andreas.sh     # pi5/
└── gtasa/
    ├── run.sh                          # pi5/
    ├── gtasa_linux, libs.aarch64/, Adjustable.cfg, assetfile.txt   # out/gtasa/
    ├── libGame.so, libc++_shared.so    # lib/arm64-v8a/ do APK
    └── anim/ audio/ data/ models/ ...  # assets/ do APK
/opt/retropie/configs/ports/gtasa/emulators.cfg   # pi5/
```

Sair do jogo: Guide (coração) + Start.

## Desempenho medido (Pi 5, `arm_freq=2700`, `v3d_freq=1100`, TV em 1080p)

| Opções do jogo (Display) | FPS |
|---|---|
| Padrão, com o limitador | 29,5 |
| Sem limitador, resolução 100%, sombras Advanced | ~50 parado |
| Resolução 67%, distância 79%, sombras Classic | ~57 parado, ~51 andando na rua |

Com as opções da última linha, a thread principal do jogo fica perto de 100% de um núcleo
e a GPU em ~60%: o limite passa a ser a CPU. Sombras Advanced custam ~12 FPS na rua;
reflexos dos carros não mudam nada.
