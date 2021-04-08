#!/usr/bin/env bash

push=0
save=0

while getopts :ps flag
do
	case "${flag}" in
		p)	push=1
			;;
		s)  save=1
			;;
		\?) echo -e "Usage: push_conf.sh [-p] [-s]";
			echo -e "\t-p\tPush storage config to live if out of sync";
			echo -e "\t-s\tSave live config to storage if out of sync";
			exit
			;;
	esac

done

echo -e $push
echo -e $save

declare -A confmap

confmap[bashrc]="$HOME/.bashrc"
confmap[i3_config]="$HOME/.config/i3/config"
confmap[vimrc]="$HOME/.vimrc"

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

for storage in "${!confmap[@]}"; 
do
	live=${confmap[$storage]};
	compare_md5 "$storage" "$live";
	if [[ $? -eq 0 ]];
	then
		echo -e "Nothing to do";
	else
		case 1 in
			$push )
				echo "Pushing live config to storage..."
				cp "$storage" "$live"
				;;
			$save )
				echo "Saving live config..."
				cp "$live" "$storage";
				;;
			* )
				echo "Info for $storage and $live:";
				if [[ $storage -nt $live} ]];
				then
					echo -e "$storage is newer."
				else 		
					echo -e "$live is newer."
				fi
				;;
		esac	
	fi
done


