#!/usr/bin/env bash
source ~/py3env/bin/activate

for c in corpus_compressed/*.arb 
do 
	echo $c 
	filename=$(basename "$c")
	echo ${filename}
	corpus_name="${filename%%.*}"
	nohup python prepare_text_for_lm.py -i "$c" -o train/${filename} &> train/${filename}.out& 
done 

#cd train/
#for f in *.arb; do head -n 100 $f > ../head_dir/$f ; done 

