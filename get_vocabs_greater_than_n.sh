#!/usr/bin/env bash
if [ $# -ne 2 ]; then
    echo "usage ${0} gt text_dir vocab_dir";
    echo "gt: words that have frequency greater than gt";
    echo "text_dir: text data directory";
    echo "vocab_dir: vocab directory";
    exit 1;
fi

source ~/py3env/bin/activate

g=${1}
vocab_dir=${2}
mkdir -p ${vocab_dir}

printf "words greater than  %s\n" "${g}"
for corpus in train/*.arb
do
    filename=$(basename "$corpus")
    corpus_name="${filename%%.*}"
    printf "%s\n" "generating vocab for ${corpus}"
    python wordfreq2vocab.py -t ${corpus} \
    -v vocabs/${corpus_name}.gt${g}.vocab \
    -f vocabs/${corpus_name}.gt${g}.freq \
    -gt ${g}
done
