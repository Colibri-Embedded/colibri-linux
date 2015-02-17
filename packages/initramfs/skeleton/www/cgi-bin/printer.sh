#!/bin/bash

while true; do

while read line; do echo "What has been passed through the pipe is ${line}"; done<myPipe

done
