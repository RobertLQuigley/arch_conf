#!/usr/bin/env bash

declare -A confmap

confmap[bashrc]="$HOME/.bashrc"
confmap[i3_config]="$HOME/.config/i3/config"
confmap[vimrc]="$Home/.vimrc"

function compare_md5() {
	md5_lhs=$(md5sum ./$1 | cut -d " " -f1)
	md5_rhs=$(md5sum $2 | cut -d " " -f1)

	if [[ $md5_lhs == $md5_rhs ]];
	then
		return 0;
	else
		echo -e "Different between $1 and $2";
		echo -e "$1: $md5_lhs";
		echo -e "$2: $md5_rhs";
		return 1;

	fi
}

for src in "${!confmap[@]}"; 
do
	echo -e $src;
	echo -e ${confmap[$src]};
	compare_md5 "$src" "${confmap[$src]}";
	if [[ $? -eq 0 ]];
	then
		echo -e "Nothing to do";
	else
		echo -e "Need to push";
	fi
done


