#compdef nos
#autoload

_nos() {
	local line state

	_arguments -C \
		"1: :->cmds" \
		"*::arg:->args"

	case "$state" in
		cmds)
			_values "nos commands" \
				"rebuild" \
				"update" \
				"clean" \
				"repair" \
				"build-iso" \
				"update-pkg" \
				"update-pkgs" ;;
		args)
			case $line[1] in
				build-iso)
					_values "iso type"  \
						"minimal" ;;
				rebuild)
					_values "rebuild arg"  \
						"switch" "boot" "test" "dry" "build" ;;
			esac ;;
	esac
}