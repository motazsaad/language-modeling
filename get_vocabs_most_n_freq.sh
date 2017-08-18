#!/usr/bin/env bash
source ~/py3env/bin/activate
echo ${0}
if [ $# -ne 2 ]; then
    echo "usage ${0} n text_dir vocab_dir";
    echo "n: the most n frequent words";
    echo "text_dir: text data directory";
    echo "vocab_dir: vocab directory";
    exit 1;
fi

n=${1}
vocab_dir=${2}
mkdir -p ${vocab_dir}

printf "most frequent %s\n" "${n}"
for corpus in train_data/*
do
    filename=$(basename "$corpus")
    corpus_name="${filename%%.*}"
    printf "%s\n" "generating vocab for ${corpus}"
    mkdir vocabs/${corpus_name}
    python word_freq2vocab.py -t ${corpus} \
    -v ${vocab_dir}/${corpus_name}/${corpus_name}.${n}.vocab \
    -f ${vocab_dir}/${corpus_name}/${corpus_name}.${n}.freq \
    -top ${n}
done
