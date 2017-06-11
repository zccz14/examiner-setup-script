# Examiner Setup Script

A set shell script to automate the procedure of setting up 
an usable environment for examiner preparing for server 
and client in LAN.

## Base Point
The script are prepared to use on a *bare* Ubuntu 16.04 LTS installation
without modifying the default configuration. For the server of hosting 
examination, the tested platform is a fresh installation of Ubuntu 
Server 16.04.2 LTS with update-to-date packages, while for the client 
for student to have the examination, the tested platform is a fresh 
installation of Ubuntu 16.04.2 LTS (Unity DE).

## Component

### Server (for examiner)

* Configuration
All server related configuration entries are set in files matching
 `./config/server-*`. 

* Setup Scripts
Setup scripts are used for installation and configurations of various 
services required to host an examination.

* Examination Scheduling Scripts

### Client (for student)
* Configuration
All client related configuration entries are set in files matching
 `./config/client-*`. 

 * Setup Scripts
Setup scripts are used for installation and configurations of various 
services required to connect to examination server and have an 
examination. This set of scripts should be executed after setting up
the examination server.

 * Examination Scripts

 ## Setup Flow

