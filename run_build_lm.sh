#!/usr/bin/env bash

#text_file=${1}
#vocab_dir=${2}
#lm_dir=${3}

text_dir=train
vocab_dir=vocabs
lm_dir=lms
dmp_dir=dmps
sh_dir=language-modeling

g=100
p=8


for corpus in ${text_dir}/*.arb
do
    echo "building LM for ${corpus}"
    nohup bash ${sh_dir}/build_lm.sh ${corpus} ${vocab_dir} ${lm_dir} ${g} ${p} ${dmp_dir} &> ${corpus}.srilm.out&
done 


