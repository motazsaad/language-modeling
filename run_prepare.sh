#!/usr/bin/env bash

for c in train/*.arb
do 
	echo $c 
	nohup ./prepare_text_for_lm.sh "$c" &> "$c".out& 
done 
