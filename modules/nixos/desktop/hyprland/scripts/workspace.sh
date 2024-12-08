focusedMonitor=$(hyprctl monitors -j | jq -r '.[] | select(.focused == true) | .id') 
workspaceOnMonitor=$(($2+(9*focusedMonitor)))

visit() {
	hyprctl dispatch workspace "$workspaceOnMonitor"
}

move() {
	hyprctl dispatch movetoworkspace "$workspaceOnMonitor"
}

movesilent() {
	hyprctl dispatch movetoworkspacesilent "$workspaceOnMonitor"
}

test(){
	echo "$workspaceOnMonitor"
}

doc() {
    echo """
Usage:
workspace [Command] [Workspace Id]
This tool is used for multiple monitor setups, 
it increments each workspace id with 10*(monitor_id).
Such that each monitor can have its own set of workspaces.

Command:
	visit       Visits the workspace
	move        Moves the active window to a workspace
	movesilent	Moves the active window to a workspace silently.
	test		Echo's the id of the workspace that will be used.
"""
}

case "$1" in 
  visit) 		visit ;;
  move) 		move ;; 
  movesilent) 	movesilent ;;
  test) 		test ;;
  *) doc;;
esac