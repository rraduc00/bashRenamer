#	Razvan Raducu			
#	El programa:
#	· Puede recibir múltiples opciones con múltiples argumentos. Por ejemplo:  
#			./renamer.sh -p preffix file1 file2 file3 -s suffix file4 file5 -r expression replacement file6 file7
#	· Puede trabajar con ficheros dashed (que empiezan por guión).
#			./renamer.sh -p PREFF ./-testFile resultará en cambiar de nombre -testFile a PREFF-testFile. 
#				(Se debe indicar el fichero con la ruta completa (./) para que el programa no lo interprete como opción)
#		De la misma forma:
#			./renamer.sh -s SUFF ./-testfile resultará en cambiar de nombre -testFile a -testFileSUFF.	
#	· Al reemplazar la expresión, reemplaza todas las ocurrencias de la misma en el nombre del fichero. (/g (global) al final)
#	· Es capaz de funcionar con ficheros y directorios que contienen espacios en el nombre.
#	· Es capaz de funcionar con ficheros y directorios cuyo nombre comienza por '-' (dash).
# 	· El programa hace control de errores y de parámetros. En caso de que el comando introducido por el usuario sea incorrecto
#		o no tenga los argumentos necesarios para las opciones especificadas, el programa lo notifica con detalle.
#	· El programa contiene ayuda al usuario "usage" con ejemplos, colores e invita al usuario a leer esta ayuda cada vez que
#		un comando insertado es incorrecto.
#####				


#!/bin/bash

set -e #In order to exit when a command return a non-zero value

printInfo() {
	echo -e "For more ${purple}information${resetColor} and ${purpleIntensity}help${resetColor} please run renamer.sh ${lightYellow}-h${resetColor}."
	echo -e "Developed by ${purpleIntensity}Razvan Raducu${resetColor}"
}

printHelp() {
	echo -e "Run the script passing the highlighted parameters in order to achieve the following funcitonality:"
	echo -e "renamer.sh ${lightYellow}-h${resetColor} Print this usage help."
	echo -e "renamer.sh ${lightYellow}-p ${purple}[prefix] ${purpleIntensity}files${resetColor} to add preffix to ${purpleIntensity}files${resetColor} name. Example:"
	echo -e "\trenamer.sh ${lightYellow}-p ${purple}OLD ${purpleIntensity}file1 file2 file3 ${resetColor}"
	echo -e "renamer.sh ${lightYellow}-s ${purple}[suffix] ${purpleIntensity}files${resetColor} to add suffix to ${purpleIntensity}files${resetColor} name. Example:"
	echo -e "\trenamer.sh ${lightYellow}-s ${purple}BCKP ${purpleIntensity}file4 file5 file6 ${resetColor}"
	echo -e "renamer.sh ${lightYellow}-r ${purple}[expression] ${red}[replacement] ${purpleIntensity}files${resetColor} to replace a pattern within the ${purpleIntensity}files${resetColor} names. Example:"
	echo -e "\trenamer.sh ${lightYellow}-r ${purple}F0000 ${red}NEW ${purpleIntensity}F0000photo1 F0000photo2${resetColor}"
	exit 0
}

executeOption() {

	if [ ! -d "$1" ] && [ ! -f "$1" ] 
		then
			echo -e "Unknown argument: ${lightYellow}$1${resetColor} is not a directory nor a file.\nAborting"		
			exit 1
	fi

	pathToFile=$(dirname "$1")
	fileName=$(basename "$1")

	case "$selectedOption" in 
		
		p) mv -- "$1" "${pathToFile}/${preffix}${fileName}" ;;

		s) mv -- "$1" "${pathToFile}/${fileName}${suffix}" ;; ##PREGUNTA: Debe funcionar con espacios?? Debe funcionar con dashed files??

		r) newFileName=$(echo ${fileName} | sed s/$expression/$replacement/g)  #FIXME No he sido capaz de hacerlo funcionar con sed
			mv "$1" "${pathToFile}/${newFileName}"
			
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
				-h) printHelp
					;;


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

					

					executeOption "$1";
					shift
					;;



			esac 
			#
		done
