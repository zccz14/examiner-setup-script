# Examiner Setup Script

A set shell script to automate the procedure of setting up 
an usable environment for examiner preparing for server 
and client in LAN.

## Base Point
The script are prepared to use on a *bare* Ubuntu 16.04 LTS installation
without modifying the default configuration. For the server of hosting 
examination, the tested platform is a fresh installation of Ubuntu 
Server 16.04.2 LTS (AMD64) with update-to-date packages, while for the client 
for student to have the examination, the tested platform is a fresh 
installation of Ubuntu 17.04 LTS (Unity DE).

## Component

### Server (for examiner)

* Configuration
All server related configuration entries are set in files matching
 `./config/server-*`. 

* Server Scripts
Server scripts are used for installation and configurations of various 
services required to host an examination.

* Examination Scheduling Scripts

### Client (for student)
* Configuration
All client related configuration entries are set in files matching
 `./config/client-*`. 

 * Client Scripts
Client scripts are used for installation and configurations of various 
services required to connect to examination server and have an 
examination. This set of scripts should be executed after setting up
the examination server been setup.

 * Examination Scripts

## Execution Instruction

The following scripts assuming that the current working directory is 
where the root of this code repository locates.

## Setup

Prepare proper configuration accordingly then execute the following commands
on server and client, respectively.

```
# setup the server
sudo ./bin/server-setup.sh 

# setup the client (after server setup)
sudo ./bin/client-setup.sh
```

## Server Scripts
```
# start register service
sudo ./bin/server-register-up.sh

# stop register service
sudo ./bin/server-register-down.sh

# schedule an exam process and start it at once
sudo ./bin/server-exam.sh
```

## Client Scripts 
```
# Register
./bin/client-register.sh

# Answer questions and upload answer
./bin/client-exam.sh

# Check score (launch browser)
./bin/client-check-score.sh
```

---
Under MIT License. Copyright © 2017 Jack Q