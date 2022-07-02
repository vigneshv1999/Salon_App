#!/bin/bash

PSQL="psql -X --username=freecodecamp --dbname=salon --tuples-only -c"

echo -e "\n~~~~~ MY SALON ~~~~~\n"

MAIN_MENU(){
  if [[ $1 ]]
  then
    echo -e $1
  fi
  #Displays list of services
  A="$($PSQL "select service_id,name from services where service_id>=1")"
  echo "$A" | while read a bar b
  do
    echo "$a) $b"
  done
  #Read input
  read SERVICE_ID_SELECTED
  si=$($PSQL "select name from services where service_id='$SERVICE_ID_SELECTED'")
  #if empty
  if [[ -z $si ]]
  then
    MAIN_MENU "\nI could not find that service. What would you like today?"
  else
    echo -e "\nWhat's your phone number?"
    read CUSTOMER_PHONE
    CUSTOMER_NAME=$($PSQL "select name from customers where phone='$CUSTOMER_PHONE'")
    if [[ -z $CUSTOMER_NAME ]]
    then
      echo -e "\nI don't have a record for that phone number.What's your name?"
      read CUSTOMER_NAME 
      r1=$($PSQL "insert into customers(phone,name) values('$CUSTOMER_PHONE','$CUSTOMER_NAME')")
    fi
    CUSTOMER_ID=$($PSQL "select customer_id from customers where phone='$CUSTOMER_PHONE'")
    echo "What time would you like your $si, $CUSTOMER_NAME?"
    read SERVICE_TIME
    result=$($PSQL "insert into appointments(customer_id,service_id,time) values($CUSTOMER_ID,$SERVICE_ID_SELECTED,'$SERVICE_TIME')")
    echo -e "I have put you down for a $si at $SERVICE_TIME, $CUSTOMER_NAME."
  fi
}
MAIN_MENU "\nWelcome to My Salon, how can I help you?\n"