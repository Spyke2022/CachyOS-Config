function fish_prompt
    set_color magenta
    echo -n "Silas-CachyOS "
    set_color normal
    echo -n (prompt_pwd)
    set_color magenta
    echo -n " ❯ "
    set_color normal
end
