# Check for input argument
#!/bin/bash

# Database name
DB="periodic_table"

# Handle no argument
if [[ -z $1 ]]; then
  echo "Please provide an element as an argument."
  exit
fi

# PSQL Command
PSQL="psql --username=postgres --dbname=$DB --no-align --tuples-only -c"

# Determine condition
if [[ $1 =~ ^[0-9]+$ ]]; then
  COND="e.atomic_number = $1"
else
  COND="e.symbol = INITCAP('$1') OR e.name = INITCAP('$1')"
fi

# Query the database
RESULT=$($PSQL "
SELECT e.atomic_number, e.name, e.symbol, t.type, p.atomic_mass, p.melting_point_celsius, p.boiling_point_celsius
FROM elements e
JOIN properties p USING(atomic_number)
JOIN types t USING(type_id)
WHERE $COND;
")

# Handle no result
if [[ -z $RESULT ]]; then
  echo "I could not find that element in the database."
  exit
fi

# Parse and print result
IFS='|' read -r ATOMIC_NUMBER NAME SYMBOL TYPE MASS MELTING BOILING <<< "$RESULT"

echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $MASS amu. $NAME has a melting point of $MELTING celsius and a boiling point of $BOILING celsius."
# Formatting improved
# Support for atomic_number, name, or symbol
# Query the database to get element details
# Handle case where no element is found
