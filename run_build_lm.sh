#!/usr/bin/env bash
for corpus in train/*.arb
do
    echo "building LM for ${corpus}"
    nohup ./build_lm.sh ${corpus} &> ${corpus}.ngramcount&
done 

# cd lms
# for l in *.lm ; do head -n 100 $l > ../head_lm/$l; done 

