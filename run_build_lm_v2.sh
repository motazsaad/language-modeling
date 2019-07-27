#!/usr/bin/env bash

text_dir=${1}
vocab_dir=${2}
lm_dir=${3}
dmp_dir=${4}

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
    gt="top"
    if ((${g} <= 500 )); then
      gt="gt"  
    fi
  
    filename=$(basename "${corpus}")
    corpus_name="${filename%%.*}"

    unks=( -unk "" )
    interpolates=( -interpolate "" )
    discounts=( -ndiscount -wbdiscount -kndiscount -ukndiscount "" )

    /home/motaz/srilm/bin/i686-m64/ngram-count -unk -ukndiscount  -text ${corpus} \
      -vocab ${vocab_dir}/${corpus_name}.${gt}${g}.vocab \
      -lm ${lm_dir}/${corpus_name}.${gt}${g}.lm

    /home/motaz/srilm/bin/i686-m64/ngram \
      -lm ${lm_dir}/${corpus_name}.${gt}${g}.lm \
      -prune 1e-${p} \
      -write-lm ${lm_dir}/${corpus_name}.${gt}${g}_p${p}.lm

    sphinx_lm_convert \
      -i ${lm_dir}/${corpus_name}.${gt}${g}_p${p}.lm \
      -o ${dmp_dir}/${corpus_name}.${gt}${g}_p${p}.lm.DMP

    sphinx_lm_convert \
      -i ${lm_dir}/${corpus_name}.${gt}${g}.lm \
      -o ${dmp_dir}/${corpus_name}.${gt}${g}.lm.DMP

done


