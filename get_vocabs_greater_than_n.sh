#!/usr/bin/env bash

if [ $# -ne 4 ]; then
    echo "usage ${0} gt text_dir vocab_dir";
    echo "gt: words that have frequency greater than gt";
    echo "text_dir: text data directory";
    echo "vocab_dir: vocab directory";
    echo "py_dir: wordfreq2vocab.py directory";
    return -1;
fi

source ~/py3env/bin/activate

g=${1}
text_dir=${2}
vocab_dir=${3}
py_dir=${4}

mkdir -p ${vocab_dir}



for corpus in ${text_dir}/*.arb
do
    filename=$(basename "$corpus")
    corpus_name="${filename%%.*}"
    printf "generating vocab for %s \t words greater than %s \n" "${corpus}" "${g}"
    python ${py_dir}/wordfreq2vocab.py -t ${corpus} \
    -v vocabs/${corpus_name}.gt${g}.vocab \
    -f vocabs/${corpus_name}.gt${g}.freq \
    -gt ${g}
done
