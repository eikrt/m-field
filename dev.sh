inotifywait -e close_write,moved_to,create -m . |
	while read -r directory events filename; do
		if [ "$filename" = "main.lua" ]; then
			love .
		fi
	done
