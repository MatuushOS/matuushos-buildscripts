#!/bin/bash
source ./fn.sh
header="MatuusOS"
desc="Utility to set up Steam/Heroic, Wine and Proton-GE"
figlet "$header" | lolcat
printf "\t$desc\t\n\tValid options are:\n\t\t1 for full setup\n\t\t2 for setting up Steam\n\t\t3 for setiing up Wine or Proton\n"
read -p "Select what you want: " choice
if [ $choice = 1 ]; then
	full
elif [ $choice = 2 ]; then
	steam
elif [ $choice = 3 ]; then
	wineproton
else
	exit 1
fi
