Vertica Extension Packages
Copyright 2020 Vertica, a Microfocus Company

This repository contains SQL code and Shell scripts to load and manage
publicly available weather data. This data is for personal use or for 
use during a Vertica Workshop.

All code is provided under the license found in LICENSE.txt

This is a read-only repository.

If you wish to contribute, please contact curtis.bennett2@vertica.com


*******************
Current files
*******************

sample queries.sql: 
  Description: some sample queries for use with the weather data

flat.sql
  Description: SQL to build a flattened table

setup.sql: 
  Description: SQL queries used for DDL to create the weather data tables

get_all.sh: 
  Description: script to get all the weather data from the source

load_all.sh:
  Description: loads all the weather data into a Vertica database (run setup.sql first)