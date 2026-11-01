# Builds the "chat" workspace: Signal over ZapZap, then Discord, then Thunderbird.
# Launches whichever of them isn't running, then puts every window back in place.
# Run at login (spawn-at-startup) and on Mod+Shift+C; running it again is harmless.

# app-id and the command that starts it.
apps=(
  "signal:signal-desktop"
  "com.rtosta.zapzap:zapzap"
  "discord:discord"
  "thunderbird:thunderbird"
)

windows() { niri msg --json windows; }

# Id of an app's window; for Thunderbird, prefer the main window over compose windows.
window_id() {
  windows | jq -r --arg app "$1" '
    [.[] | select(.app_id == $app)]
    | (map(select(.title | test("Mozilla Thunderbird$"))) + .)
    | first | .id // empty'
}

act() { niri msg action "$@"; }

for entry in "${apps[@]}"; do
  app=${entry%%:*}
  if [[ -z $(window_id "$app") ]]; then
    setsid -f "${entry#*:}" >/dev/null 2>&1
  fi
done

# Signal waits on KWallet and Discord may update itself first, so allow some time.
for _ in $(seq 60); do
  missing=0
  for entry in "${apps[@]}"; do
    [[ -z $(window_id "${entry%%:*}") ]] && missing=1
  done
  ((missing)) || break
  sleep 0.5
done

signal=$(window_id signal)
zapzap=$(window_id com.rtosta.zapzap)
discord=$(window_id discord)
thunderbird=$(window_id thunderbird)

chat=$(niri msg --json workspaces | jq -r '.[] | select(.name == "chat") | .id')
for id in $signal $zapzap $discord $thunderbird; do
  ws=$(windows | jq -r --argjson id "$id" '.[] | select(.id == $id) | .workspace_id')
  [[ $ws != "$chat" ]] && act move-window-to-workspace --window-id "$id" --focus false chat
done

column_of() {
  windows | jq -r --argjson id "$1" '.[] | select(.id == $id) | .layout.pos_in_scrolling_layout[0]'
}

if [[ -n $signal ]]; then
  act focus-window --id "$signal"
  act move-column-to-index 1
  if [[ -n $zapzap && $(column_of "$zapzap") != "$(column_of "$signal")" ]]; then
    act focus-window --id "$zapzap"
    act move-column-to-index 2
    act consume-or-expel-window-left
  fi
  act focus-window --id "$signal"
  act set-column-width 50%
  act reset-window-height --id "$signal"
  [[ -n $zapzap ]] && act reset-window-height --id "$zapzap"
fi

next=2
[[ -z $signal ]] && next=1
if [[ -n $discord ]]; then
  act focus-window --id "$discord"
  act move-column-to-index "$next"
  act set-column-width 800
  next=$((next + 1))
fi
if [[ -n $thunderbird ]]; then
  act focus-window --id "$thunderbird"
  act move-column-to-index "$next"
  act set-column-width 100%
fi

if [[ -n $signal ]]; then
  act focus-window --id "$signal"
else
  act focus-workspace chat
fi
