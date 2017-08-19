#!/usr/bin/env bash
if [ $# -ne 3 ]; then
    echo "usage ${0} gt text_dir vocab_dir";
    echo "n: top N words (most N frequent words)";
    echo "text_dir: text data directory";
    echo "vocab_dir: vocab directory";
    return -1;
fi

source ~/py3env/bin/activate

n=${1}
text_dir=${2}
vocab_dir=${3}
mkdir -p ${vocab_dir}

printf "most frequent %s\n" "${n}"
for corpus in ${text_dir}/*.arb
do
    filename=$(basename "$corpus")
    corpus_name="${filename%%.*}"
    printf "%s\n" "generating vocab for ${corpus}"
    python wordfreq2vocab.py -t ${corpus} \
    -v vocabs/${corpus_name}.${n}.vocab \
    -f vocabs/${corpus_name}.${n}.freq \
    -top ${n}
done
