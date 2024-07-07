#!/bin/bash
PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"

if [[ -z $1 ]]
then
  echo Please provide an element as an argument.
else

  if [[ ! $1 =~ ^[0-9]+$ ]]
  then
    ELEMENT=$($PSQL "select atomic_number from elements where symbol='$1' or name='$1'")
  else
    ELEMENT=$($PSQL "select atomic_number from elements where atomic_number=$1")
  fi

  if [[ -z $ELEMENT ]]
  then
    echo I could not find that element in the database.
  else
    ATOMIC_NUMBER=$(echo $($PSQL "select atomic_number from elements where atomic_number=$ELEMENT")| sed 's/ *//')
    NAME=$(echo $($PSQL "select name from elements where atomic_number=$ELEMENT")| sed 's/ *//')
    SYMBOL=$(echo $($PSQL "select symbol from elements where atomic_number=$ELEMENT")| sed 's/ *//')
    TYPE=$(echo $($PSQL "select type from types full join properties using(type_id) where atomic_number=$ELEMENT")| sed 's/ *//')
    MASS=$(echo $($PSQL "select atomic_mass from properties where atomic_number=$ATOMIC_NUMBER")| sed 's/ *//')
    MELTING=$(echo $($PSQL "select melting_point_celsius from properties where atomic_number=$ELEMENT")| sed 's/ *//')
    BOILING=$(echo $($PSQL "select boiling_point_celsius from properties where atomic_number=$ELEMENT")| sed 's/ *//')

    echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $MASS amu. $NAME has a melting point of $MELTING celsius and a boiling point of $BOILING celsius."
  fi
fi 
