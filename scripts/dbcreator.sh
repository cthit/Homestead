#!/usr/bin/env bash
db=$1

if mysqlshow -uhomestead -psecret | grep -q $db; then
    echo "Database already exists. Ignoring..."
else
    echo "Creating new database $db";
    mysql -uhomestead -psecret -e "create database $db";
fi
