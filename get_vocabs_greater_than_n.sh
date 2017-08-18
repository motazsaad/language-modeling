#!/usr/bin/env bash
source ~/py3env/bin/activate
n=5

printf "words greater than  %s\n" "${n}"
for corpus in train/*.arb
do
    filename=$(basename "$corpus")
    corpus_name="${filename%%.*}"
    printf "%s\n" "generating vocab for ${corpus}"
    python wordfreq2vocab.py -t ${corpus} -v vocabs/${corpus_name}.gt${n}.vocab -gt ${n}
done
