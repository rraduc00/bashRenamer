#	Razvan Raducu			
#	El programa es capaz de:
#	·
#	·
#	·
#	·
#####				


#!/bin/bash
printInfo() {
	echo -e "For more ${purple}information${resetColor} and ${purpleIntensity}help${resetColor} please run renamer.sh ${lightYellow}-h${resetColor}."
	echo -e "Developed by ${purpleIntensity}Razvan Raducu${resetColor}"
}

printHelp() {
	echo -e "Usage v1. Run the script passing the highlighted parameters in order to achieve the following funcitonality:"
	echo -e "renamer.sh ${lightYellow}-h${resetColor} Print this usage help."
	echo -e "renamer.sh ${lightYellow}-p ${purple}[prefix] ${purpleIntensity}files${resetColor} to add preffix to ${purpleIntensity}files${resetColor} name. Example:"
	echo -e "\texaple in new line"
	echo -e "renamer.sh ${lightYellow}-s ${purple}[suffix] ${purpleIntensity}files${resetColor} to add suffix to ${purpleIntensity}files${resetColor} name. Example:"
	echo -e "\texaple in new line"
	echo -e "renamer.sh ${lightYellow}-r ${purple}[expression] ${red}[replacement] ${purpleIntensity}files${resetColor} to replace a pattern within the ${purpleIntensity}files${resetColor} names. Example:"
	echo -e "\texaple in new line"
}


lightYellow='\e[93m'
purpleIntensity='\e[0;95m'
purple='\e[0;35m'
resetColor='\e[0m'
red='\e[0;31m'



####### Main Algorithm ########
if [ $# -eq 0 ]
		then
			echo -e "\nWrong usage.\nNo parameters received.\nAborting\n"
			printInfo
			exit 1
	fi

	while test -n "$1"; # True if string is not empty
		do
			case "$1" in
				-h) printHelp;;
				-p) echo "ppp";; 
				-s)	echo "ssss";;
				-r) echo "rrrr";;
					# In r case, check whether parameters are atleast 4. -r expr repl file....
				*) echo -e "Unknown argument: $1.\nAborting." 
					exit 0 ;;
			esac
			shift
		done


################################