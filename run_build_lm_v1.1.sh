#!/usr/bin/env bash

text_dir=${1}
vocab_dir=${2}
lm_dir=${3}
dmp_dir=${4}
sh_dir=/home/motaz/asr_dev/lm_train2/scripts/language-modeling/build_lm

g=50
p=9

mkdir -p ${vocab_dir}
mkdir -p ${lm_dir}
mkdir -p ${dmp_dir}

for corpus in ${text_dir}/*.arb
do
    filename=$(basename "${corpus}")
    corpus_name="${filename%%.*}"
    ~/sphinx_source/cmuclmtk-0.7/src/programs/text2wfreq <${corpus}> ${vocab_dir}/${corpus_name}.freq
    ~/sphinx_source/cmuclmtk-0.7/src/programs/wfreq2vocab -gt ${g} \
    <${vocab_dir}/${corpus_name}.freq > ${vocab_dir}/${corpus_name}.gt${g}.vocab -records 4000000
    echo "building LM for ${corpus}"
    ${sh_dir}/build_lm.sh ${corpus} ${vocab_dir} ${lm_dir} ${g} ${p} ${dmp_dir}
done


