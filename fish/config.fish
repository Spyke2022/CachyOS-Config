source /usr/share/cachyos-fish-config/cachyos-config.fish

# overwrite greeting
# potentially disabling fastfetch
#function fish_greeting
#    # smth smth
#end
set -gx GTK_IM_MODULE xim
set -gx QT_IM_MODULE xim
set -U pure_symbol_ssh_prefix "Silas-CachyOS "
