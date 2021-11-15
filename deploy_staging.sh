#!/bin/bash

scp -i /home/userman/.ssh/id_rsa -r --exclude='.git/*' ../ASIR2-IAW-SCRIPT pablogontroya@35.205.84.234:
