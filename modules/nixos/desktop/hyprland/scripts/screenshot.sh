area () {
  grimblast --notify --freeze copysave area "$SCREENSHOT_DIR/$NOW.png"
}

active () {
  grimblast --notify --freeze copysave active "$SCREENSHOT_DIR/$NOW.png"
}

all () {
  grimblast --notify --freeze copysave screen "$SCREENSHOT_DIR/$NOW.png"
}

SCREENSHOT_DIR="$HOME/Pictures/Screenshots"
if [ -z "$SCREENSHOT_DIR" ]; then
  mkdir -p "$SCREENSHOT_DIR"    
fi

NOW="$(date +%Y-%m-%d_%H-%m-%s)"
case "$1" in
    area) area ;;
    active) active ;;
    all) all ;;
esac