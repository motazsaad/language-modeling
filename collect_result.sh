#!/usr/bin/env bash

for ppl_file in ./ppl_dir/*
do
    ppl=`grep ppl= ${ppl_file} | awk '{ printf ("%.1f\n", $6)}'`
    oov=`grep OOVs ${ppl_file}  | awk '{ print $7}'`
    words=`grep words ${ppl_file}  | awk '{ print $5}'`
    oov_rate=$(python -c "print($oov/float($words)*100)")
    printf "ppl=%s\t oov-rate=%.1f\t %s\n" ${ppl} ${oov_rate} ${ppl_file} >> ppl_results.txt
done

sort -n ppl_results.txt > ppl_results_sorted.txt




