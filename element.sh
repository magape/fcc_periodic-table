#! /bin/bash

PSQL="psql --username=freecodecamp --dbname=periodic_table --tuples-only -c"

# if no argument provided
if [[ -z $1 ]]
then
  echo "Please provide an element as an argument."
# if atomic number is provided
else
  if [[ $1 =~ ^[0-9]+$ ]]
  then
    ELEMENT_PROPERTIES=$($PSQL "SELECT e.atomic_number, e.name, e.symbol, t.type, p.atomic_mass, p.melting_point_celsius, p.boiling_point_celsius FROM elements e INNER JOIN properties p ON e.atomic_number = $1 AND e.atomic_number = p.atomic_number  INNER JOIN types t USING (type_id)")
# if symbol or name is provided
  else
    ELEMENT_PROPERTIES=$($PSQL "SELECT e.atomic_number, e.name, e.symbol, t.type, p.atomic_mass, p.melting_point_celsius, p.boiling_point_celsius FROM elements e INNER JOIN properties p USING (atomic_number) INNER JOIN types t USING (type_id) WHERE e.symbol = '$1' OR e.name = '$1'")
  fi

# if the argument is not an atomic_number, symbol, or name in database
  if [[ -z $ELEMENT_PROPERTIES ]]
  then
    echo "I could not find that element in the database."
# display information requested database information
  else
    echo "$ELEMENT_PROPERTIES" | while read ATOMIC_NUMBER BAR NAME BAR SYMBOL BAR TYPE BAR ATOMIC_MASS BAR MELTING_POINT_CELSIUS BAR BOILING_POINT_CELSIUS
    do
      echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MELTING_POINT_CELSIUS celsius and a boiling point of $BOILING_POINT_CELSIUS celsius."
    done
  fi
fi
