#!/bin/bash

./bootstrap.sh

#source setup.env

cd bundles
for b in $(ls); do
	if [ -d $b ];then
		cd $b
		./build.sh
		cd ..
	fi
done
