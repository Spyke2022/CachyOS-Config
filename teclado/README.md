# Teclado automatico — CachyOS / COSMIC

Objetivo: teclado interno do Lenovo Yoga Slim 7 14IMH9 em ABNT2 (`br`) e
HyperX Alloy Elite 2 (USB `03f0:058f`) em US Internacional (`us` + `intl`).

## Limitacao do COSMIC

O `cosmic-comp` **nao suporta layout por dispositivo**. Diferente do Hyprland
(bloco `device {}`) e do Sway (bloco `input "id"`), ele aplica um unico
`xkb_config` para o *seat* inteiro:

    ~/.config/cosmic/com.system76.CosmicComp/v1/xkb_config

## Solucao adotada

Manter **dois layouts** carregados e apenas **reordenar** qual e o grupo 0,
conforme a presenca fisica do HyperX:

| HyperX  | layout    | variant   | grupo 0    |
|---------|-----------|-----------|------------|
| plugado | `us,br`   | `intl,`   | US intl    |
| ausente | `br,us`   | `,intl`   | ABNT2      |

A opcao `grp:win_space_toggle` permanece ativa, entao **Super+Espaco** alterna
manualmente entre os dois a qualquer momento.

## Arquivos

| Repositorio | Destino no sistema |
|---|---|
| `local-bin/kb-cosmic-auto.sh` | `~/.local/bin/kb-cosmic-auto.sh` (chmod +x) |
| `kb-cosmic-auto.service` | `~/.config/systemd/user/kb-cosmic-auto.service` |
| `XCompose` | `~/.XCompose` |
| `cosmic/xkb_config` | `~/.config/cosmic/com.system76.CosmicComp/v1/xkb_config` |

Nao ha regra udev. O disparo e feito pelo proprio script, que escuta
`udevadm monitor --udev --subsystem-match=usb` em loop, supervisionado por um
servico systemd de usuario (`Restart=always`).

## Restauracao apos reinstalacao

    mkdir -p ~/.local/bin ~/.config/systemd/user
    cp local-bin/kb-cosmic-auto.sh ~/.local/bin/
    chmod +x ~/.local/bin/kb-cosmic-auto.sh
    cp kb-cosmic-auto.service ~/.config/systemd/user/
    cp XCompose ~/.XCompose
    systemctl --user daemon-reload
    systemctl --user enable --now kb-cosmic-auto.service

Depois: logout/login.

## Armadilhas (aprendidas na marra)

1. **Nunca usar `variant: abnt2`.** O layout `br` **ja e** ABNT2. A variante
   `abnt2` e invalida e faz o XKB cair em fallback silencioso para `us`.
2. **`~/.config/environment.d/` tem precedencia sobre `/etc/environment`** na
   sessao systemd. Um `cedilha.conf` ali declarando `GTK_IM_MODULE=fcitx`,
   `QT_IM_MODULE=fcitx` e `XMODIFIERS=@im=fcitx` roteava as teclas pelo fcitx5
   (que roda via autostart), quebrando o cedilha. Corrigido renomeando o arquivo
   para `cedilha.conf.off` — o systemd so le arquivos terminados em `.conf`.
   Com as variaveis vazias, os apps usam XKB/XCompose direto.
3. **`~/.XCompose` precisa de `include "%L"` na PRIMEIRA linha**, senao ele
   substitui a tabela padrao inteira em vez de estende-la. Sem isso, no us-intl
   a sequencia `apostrofo + c` gera `c` com acento agudo em vez de `c-cedilha`.
4. **Senha do sudo:** com o layout us-intl ativo, caracteres acentuados saem
   diferentes. Se o sudo recusar a senha, alterne com Super+Espaco antes.
5. O script tem guarda para nao reescrever o `xkb_config` quando ja esta na
   ordem correta — sem isso, a propria escrita gera evento e vira loop.
