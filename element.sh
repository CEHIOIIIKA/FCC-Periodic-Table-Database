#!/bin/bash

PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"

PERIODIC_TABLE() {
  if [[ ! $1 ]]
  then
    echo "Please provide an element as an argument."
  else
    if [[ $1 =~ [0-9] ]]
    then
      PSQL_CONDITION=" WHERE atomic_number=$1"
    elif [[ $1 =~ [a-zA-Z]+ ]]
    then
      PSQL_CONDITION=" WHERE symbol='$1' OR name='$1'" 
    fi
    PROPERTIES_RESULT=$($PSQL "SELECT * FROM elements FULL JOIN properties USING (atomic_number) FULL JOIN types ON properties.type_id=types.type_id$PSQL_CONDITION")
    if [[ -z $PROPERTIES_RESULT ]]
    then
      echo "I could not find that element in the database."
    else
      echo $PROPERTIES_RESULT | sed 's/|/ /g' | while read ATOMIC_NUMBER ELEMENT_SYMBOL ELEMENT_NAME ATOMIC_MASS MELTING_POINT BOILING_POINT X X ELEMENT_TYPE
      do
        echo "The element with atomic number $ATOMIC_NUMBER is $ELEMENT_NAME ($ELEMENT_SYMBOL). It's a $ELEMENT_TYPE, with a mass of $ATOMIC_MASS amu. $ELEMENT_NAME has a melting point of $MELTING_POINT celsius and a boiling point of $BOILING_POINT celsius."
      done
    fi
  fi
}

PERIODIC_TABLE $1