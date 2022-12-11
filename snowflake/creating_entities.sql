-- set variables (these need to be uppercase)
 set airbyte_role = '<role_name>';
 set airbyte_username = '<user_name>';
 set airbyte_warehouse = '<warehouse_name>';
 set airbyte_database = '<db_name>';
 set airbyte_schema = '<db_schema>';

 -- set user password
 set airbyte_password = '<my_passwd>';

 begin;

 -- create Airbyte role
 use role securityadmin;
 create role if not exists identifier($airbyte_role);
 grant role identifier($airbyte_role) to role SYSADMIN;

 -- create Airbyte user
 create user if not exists identifier($airbyte_username)
 password = $airbyte_password
 default_role = $airbyte_role
 default_warehouse = $airbyte_warehouse;

 grant role identifier($airbyte_role) to user identifier($airbyte_username);

 -- change role to sysadmin for warehouse / database steps
 use role sysadmin;

 -- create Airbyte warehouse
 create warehouse if not exists identifier($airbyte_warehouse)
 warehouse_size = xsmall
 warehouse_type = standard
 auto_suspend = 60
 auto_resume = true
 initially_suspended = true;

 -- create Airbyte database
 create database if not exists identifier($airbyte_database);

 -- grant Airbyte warehouse access
 grant USAGE
 on warehouse identifier($airbyte_warehouse)
 to role identifier($airbyte_role);

 -- grant Airbyte database access
 grant OWNERSHIP
 on database identifier($airbyte_database)
 to role identifier($airbyte_role);

 commit;

 begin;

 USE DATABASE identifier($airbyte_database);

 -- create schema for Airbyte data
 CREATE SCHEMA IF NOT EXISTS identifier($airbyte_schema);

 commit;

 begin;

 -- grant Airbyte schema access
 grant OWNERSHIP
 on schema identifier($airbyte_schema)
 to role identifier($airbyte_role);

 commit;