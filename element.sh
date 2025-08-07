#!/bin/bash

PSQL="psql -X --username=freecodecamp --dbname=periodic_table --tuples-only -c"

MAIN_MENU(){
if [ ! -z $1 ]
then

# if an argument exists evaluate if it is a integer or String
	if [[ $1 =~ [0-9]{1,2} ]] #integer
	then
		# get element info using atomic_number
		ELEMENT_INFO_RESULT=$($PSQL "SELECT * FROM elements INNER JOIN properties USING(atomic_number) INNER JOIN types USING(type_id) WHERE atomic_number=$1;")
		DISPLAY_INFO $ELEMENT_INFO_RESULT
	elif [[ $1 =~ [A-Za-z] ]] # string
	then
		# get argument length to verify if is the symbol or name
		element_str=$1
		string_length=${#element_str}
		# if argument string_length<3 use the symbol
		if [[ $string_length < 3  ]]
		then
			ELEMENT_INFO_RESULT=$($PSQL "SELECT * FROM elements INNER JOIN properties USING(atomic_number) INNER JOIN types USING(type_id) WHERE symbol='$1';")
			# if no elemnt exist
			if [[ -z $ELEMENT_INFO_RESULT  ]]
			then
				EXIT_MENU "I could not find that element in the database."
			else
				DISPLAY_INFO $ELEMENT_INFO_RESULT
			fi
		else
		# if argument struing_length>1 use the name 
			ELEMENT_INFO_RESULT=$($PSQL "SELECT * FROM elements INNER JOIN properties USING(atomic_number) INNER JOIN types USING(type_id) WHERE name='$1';")
			DISPLAY_INFO $ELEMENT_INFO_RESULT
		fi
	fi
else
# no arguments given, go to the exit menu
	EXIT_MENU "Please provide an element as an argument."
fi
}

DISPLAY_INFO(){
	if [[ -z $1 ]]
	then
	# if no elements exist
		EXIT_MENU "I could not find that element in the database."
	else
	# display element info
		echo "The element with atomic number $3 is $7 ($5). It's a ${15}, with a mass of $9 amu. $7 has a melting point of ${11} celsius and a boiling point of ${13} celsius."

	fi
}


EXIT_MENU() {
  if [[ $1  ]]
  then
	echo $1
  fi
}

MAIN_MENU $1
