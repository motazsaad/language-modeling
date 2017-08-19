#!/usr/bin/env bash

for test_text in ./test_data/*.txt
do
    test_name=$(basename $test_text)
    printf "test text: %s\n---------\n\n" ${test_name}
    for lm in lms/*pruned*.lm
    do
        lm_name=$(basename $lm)
        printf "applying %s\n" ${lm_name}
        ngram -lm ${lm} -ppl ${test_text} > ppl_dir/${lm_name}_${test_name}.ppl
        printf "%s\n" "------------------"
    done
    printf "%s\n" "====================================="
    printf "%s\n" "====================================="
    for ppl_file in ppl_dir/*${test_name}.ppl
    do
        ppl=`grep ppl= ${ppl_file} | awk '{ printf ("%.1f\n", $6)}'`
        oov=`grep OOVs ${ppl_file}  | awk '{ print $7}'`
        words=`grep words ${ppl_file}  | awk '{ print $5}'`
        oov_rate=$(python -c "print($oov/float($words)*100)")
        printf "%s ppl\t %.1f %%oov\t %s\n" ${ppl} ${oov_rate} ${ppl_file} >> ppl_dir/${test_name}_results.txt
    done
    sort -n ppl_dir/${test_name}_results.txt > ppl_dir/${test_name}_results_sorted.txt
done





