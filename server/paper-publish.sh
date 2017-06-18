#!/usr/bin/env bash


# load config
source ../config/server-network.conf
declare -x max_index=0
awk -f ./paper-process.awk ../config/server-paper.conf