#!/usr/bin/env bash
# Restaura as configurações do CachyOS a partir deste repositório
# Uso: rode de dentro da pasta CachyOS-Config após clonar
set -e

REPO="$(cd "$(dirname "$0")" && pwd)"

echo "Restaurando configurações do CachyOS a partir de $REPO ..."

# Fastfetch
mkdir -p ~/.config/fastfetch
cp "$REPO/fastfetch/config.jsonc" ~/.config/fastfetch/
cp "$REPO/fastfetch/logo.png" ~/.config/fastfetch/

# Fish
mkdir -p ~/.config/fish/functions
cp "$REPO/fish/config.fish" ~/.config/fish/
cp "$REPO/fish/functions/fish_prompt.fish" ~/.config/fish/functions/

# Cedilha
cp "$REPO/.XCompose" ~/
mkdir -p ~/.config/environment.d
cp "$REPO/environment.d/cedilha.conf" ~/.config/environment.d/ 2>/dev/null || true

# Limpa cache do fastfetch (para regerar o logo)
rm -rf ~/.cache/fastfetch

echo ""
echo "Restauração concluída!"
echo "Faça logout/login para o cedilha funcionar na sessão grafica."
echo "Rode exec fish ou abra um novo terminal para ver o prompt e o fastfetch."
