function fish_prompt
    set -l last_status $status

    # Aktuelles Verzeichnis, verkürzt (z.B. ~/W/settingsmanager)
    set -l cwd (set_color cyan)(prompt_pwd)(set_color normal)

    # Git-Branch/Zweig, falls im Repo
    set -l git_info ""
    if command -sq git
        set -l branch (git branch --show-current 2>/dev/null)
        if test -n "$branch"
            set -l dirty ""
            if not git diff --quiet 2>/dev/null; or not git diff --cached --quiet 2>/dev/null
                set dirty (set_color red)" ✗"(set_color normal)
            end
            set git_info " "(set_color yellow)$branch(set_color normal)$dirty
        end
    end

    # Fehlercode vom letzten Befehl, nur anzeigen wenn nicht 0
    set -l status_info ""
    if test $last_status -ne 0
        set status_info " "(set_color red)"[$last_status]"(set_color normal)
    end

    echo -n "$cwd$git_info$status_info "(set_color magenta)"❯ "(set_color normal)
end
