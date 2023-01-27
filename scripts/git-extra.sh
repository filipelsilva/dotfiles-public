#!/bin/bash

echo "Updating the mlocate database"
sudo -v; sudo updatedb

echo "Finding diff_highlight..."
diff_highlight="$(locate '*/diff-highlight/diff-highlight')"
if [[ -n $diff_highlight ]]; then
	echo "Found"
else
	echo "Not found"
fi

echo "Finding git_jump..."
git_jump="$(locate '*/git-jump/git-jump')"
if [[ -n $git_jump ]]; then
	echo "Found"
else
	echo "Not found"
fi

echo "Linking files to /usr/local/bin..."
sudo -v; sudo ln -sf "$diff_highlight" /usr/local/bin
sudo -v; sudo ln -sf "$git_jump" /usr/local/bin
echo "Done"
