#	Razvan Raducu			
#	El programa:
#	· Puede recibir múltiples argumentos 
#	·
#	·
#	·
#####				


#!/bin/bash

set -e #In order to exit when a command return a non-zero value

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

executeOption() {

	if [ -d $1 ] || [ -f $1 ] 
		then
			echo "ENTERED for the $selectedOption option with $1 argument"
		else 
			echo -e "Unknown argument: ${lightYellow}$1${resetColor} is not a directory not a file.\n Aborting"		
	fi

	case "$selectedOption" in
		p) echo "executeOption is p"
			selectedOption=0 ### IMPORTANT TO RESET THE FLAG
			;;
		s) echo "executeOption is r";;
		r) echo "executeOption is s";;
	esac

}

checkOptionsArgumentsLength(){
	case "$selectedOption" in
		p) if [ ! $1 -gt 1  ]
				then
					echo -e "The option ${lightYellow}-$selectedOption${resetColor} needs atleast 2 arguments. ${purple}[prefix] ${purpleIntensity}files${resetColor}"
					printInfo
					echo -e "\nAborting."
					exit 1
				fi
			;;
		s) echo "executeOption is r";;
		r) echo "executeOption is s";;
	esac
}

lightYellow='\e[93m'
purpleIntensity='\e[0;95m'
purple='\e[0;35m'
resetColor='\e[0m'
red='\e[0;31m'



####### Main Algorithm ########

selectedOption=0
suffix=0
preffix=0
expression=0
replacement=0

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


				-p) selectedOption=p
					##Pendiente hacer shift para asignar los registros del preifijo
					;;


				-s)	selectedOption=s
					
					;;

				-r) selectedOption=r
					
					;;
					# In r case, check whether parameters are atleast 4. -r expr repl file....
				
				*) 
					if [ "$selectedOption" == 0 ]
						then 
							echo -e "Unknown argument: $1.\nAborting." 
							exit 1 
					fi

					

					executeOption $1;

					;;



			esac 
			shift
			checkOptionsArgumentsLength $#
			
		done

############################
# Pendiente: Decidir qué modelo de shift se va a implementar. Encontrar una forma adecuada
# de comprobar el número de parámetros, de hacer shift y de asignar a los positional parameters $1, $2, $3... etc
# los valores correcto así como suffix, preffix, etc... mientras se limpian los registros
# tras cada operación.
################################