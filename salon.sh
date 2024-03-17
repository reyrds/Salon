#!/bin/bash

PSQL="psql -X --username=freecodecamp --dbname=salon --tuples-only -c"

echo -e "\n~~~~~ MY SALON ~~~~~\n"

MAIN_MENU(){
  if [[ $1 ]]; then
    echo -e "\n$1"
  fi
  
  echo -e "\nHow can I help you?\n"
  
  AVAILABLE_SERVICES=$($PSQL "SELECT * FROM services")
  
  echo "$AVAILABLE_SERVICES" | while read SERVICE_ID BAR SERVICE; do
    ID=$(echo $SERVICE_ID | sed 's/ //g')
    NAME=$(echo $SERVICE | sed 's/ //g')
    echo -e "$ID) $SERVICE\n"
  done
  
  read SERVICE_ID_SELECTED
  
  case $SERVICE_ID_SELECTED in
    [1-3]) NEXT ;;
    *) MAIN_MENU "Please enter a valid option." ;;
  esac
}

NEXT(){
  echo -e  "Please enter your phone number."
  read CUSTOMER_PHONE
  NAME=$($PSQL "SELECT name FROM customers WHERE phone='$CUSTOMER_PHONE'")
  if [[ -z $NAME ]]
  then
    echo -e "Please enter your name"
    read CUSTOMER_NAME
    INSERT_NEW_CUSTOMER=$($PSQL "INSERT INTO customers(name, phone) VALUES('$CUSTOMER_NAME','$CUSTOMER_PHONE')")
  fi
  echo -e "\nWhat time would you like for your appointment?"
  read SERVICE_TIME
  CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE phone='$CUSTOMER_PHONE'")
  INSERT_DATA=$($PSQL "INSERT INTO appointments(customer_id,service_id,time) VALUES($CUSTOMER_ID, $SERVICE_ID_SELECTED, '$SERVICE_TIME')")
  SERVICE_SELECTED=$($PSQL "SELECT name FROM services WHERE service_id=$SERVICE_ID_SELECTED")

  echo -e "I have put you down for a $SERVICE_SELECTED service at $SERVICE_TIME, $CUSTOMER_NAME."
}

MAIN_MENU
