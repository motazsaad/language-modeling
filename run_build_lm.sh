#!/usr/bin/env bash

#text_file=${1}
#vocab_dir=${2}
#lm_dir=${3}

text_dir=
vocab_dir=
lm_dir=

g=100
p=8


for corpus in ${text_dir}/*.arb
do
    echo "building LM for ${corpus}"
    nohup ./build_lm.sh ${corpus} ${vocab_dir} ${lm_dir} ${g} ${p}  &> ${corpus}.srilm.out&
done 


