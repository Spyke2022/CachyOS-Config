# CachyOS-Config

Backup das configurações do terminal e sistema no CachyOS (Yoga Slim 7 14IMH9).

## Conteúdo

- **fastfetch/** — config do fastfetch (tema roxo) + logo do CachyOS em roxo
- **fish/** — config.fish e prompt customizado (Silas-CachyOS em magenta)
- **.XCompose** — regra do cedilha (dead_acute + c = ç)
- **environment.d/cedilha.conf** — variáveis de ambiente do cedilha (persistente no Wayland/COSMIC)

## Backup (salvar mudanças)

\`\`\`fish
~/backup-cachyos.sh
cd ~/CachyOS-Config
git add .
git commit -m "descrição"
git push
\`\`\`

## Restaurar (após reinstalar)

\`\`\`fish
git clone https://github.com/Spyke2022/CachyOS-Config.git
cd CachyOS-Config
./restaurar-cachyos.sh
\`\`\`

Depois faça logout/login para o cedilha valer na sessão gráfica.
