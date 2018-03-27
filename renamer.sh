#	Razvan Raducu			
#	El programa:
#	· Puede recibir múltiples opciones con múltiples argumentos. Por ejemplo:  
#			./renamer.sh -p preffix file1 file2 file3 -s suffix file4 file5 -r expression replacemen file6 file7
#	· Puede trabajar con ficheros dashed (que empiezan por guión).
#			./renamer.sh -p PREFF ./-testFile resultará en cambiar de nombre -testFile a PREFF-testFile. 
#				(Se debe indicar el fichero con la ruta completa (./) para que el programa no lo interprete como opción)
#		De la misma forma:
#			./renamer.sh -s SUFF ./-testfile resultará en cambiar de nombre -testFile a -testFileSUFF.	
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
			exit 1
	fi

	case "$selectedOption" in ## PREGUNTA: Estaría bien imprimir unos logs por pantalla para ver qué se ha cambiado y qué no?
		
			# Basename is used to get the base name of the file. So ./-testFile becomes -testFile. This formula avoids
			# errors when executing something like ./renamer.sh -p PREFF ./-testFile. If 'basename' isn't used, error
			# "cant move PREFF./-testFile. File or directory not found" is prompted. 
		p) mv -- "$1" "${preffix}$(basename $1)"

		s) mv "$1" "$1${suffix}" ##PREGUNTA: Debe funcionar con espacios?? Debe funcionar con dashed files??

		r) echo "executeOption is r"
			echo "expression is: $expression"
			echo "replacement is: ${replacement}"
			echo "Arguments are: $@"	
			;;

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
		s) if [ ! $1 -gt 1  ]
				then
					echo -e "The option ${lightYellow}-$selectedOption${resetColor} needs atleast 2 arguments. ${purple}[suffix] ${purpleIntensity}files${resetColor}"
					printInfo
					echo -e "\nAborting."
					exit 1
			fi
			;;
		r) if [ ! $1 -gt 2  ]
				then
					echo -e "The option ${lightYellow}-$selectedOption${resetColor} needs atleast 3 arguments. ${purple}[expression] ${red}[replacement] ${purpleIntensity}files${resetColor}"
					printInfo
					echo -e "\nAborting."
					exit 1
				fi
			;;
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
					shift
					checkOptionsArgumentsLength $#
					preffix=$1
					shift
					;;


				-s)	selectedOption=s
					shift
					checkOptionsArgumentsLength $#
					suffix=$1
					shift
					;;

				-r) selectedOption=r
					shift
					checkOptionsArgumentsLength $#
					expression=$1
					replacement=$2
					shift 2
					;;
					# In r case, check whether parameters are atleast 4. -r expr repl file....
				
				*) 	
					if [ "$selectedOption" == 0 ] || [ ${1:0:1} = '-' ]
						then 
							echo -e "Unknown argument: ${lightYellow}$1${resetColor}.\nAborting." 
							exit 1 
					fi

					

					executeOption $1;
					shift
					;;



			esac 
			#
		done
