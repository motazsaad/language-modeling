#!/usr/bin/env bash

if [ $# -ne 1 ]; then
    echo "usage ${0} text_dir";
    echo "text_dir: text data directory";
    return -1;
fi

text_dir=${1}

for corpus in ${text_dir}/*.arb
do
    echo "building LM for ${corpus}"
    nohup ./build_lm.sh ${corpus} &> ${corpus}.srilm.out&
done 

