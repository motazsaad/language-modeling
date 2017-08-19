 #!/usr/bin/env bash

if [ $# -ne 6 ]; then
    echo "usage ${0} gt text_dir vocab_dir";
    echo "text_dir: text data directory";
    echo "vocab_dir: vocab directory";
    echo "lm_dir: vocab directory";
    echo "gt: words that have frequency greater than gt";
    echo "p: pruning parameter";
    echo "dmp_dir: dmp language models directory";
    return -1;
fi

text_file=${1}
vocab_dir=${2}
lm_dir=${3}
dmp_dir=${4}
g=${5}
p=${6}

mkdir -p ${lm_dir}
mkdir -p ${dmp_dir}

filename=$(basename "${text_file}")
corpus_name="${filename%%.*}"
printf "%s\n" "building language mode for ${text_file}"
ngram-count -kndiscount -interpolate -text ${text_file} \
-vocab ${vocab_dir}/${corpus_name}.gt${g}.vocab  \
-lm ${lm_dir}/${corpus_name}.gt${g}.lm

printf "%s\n" "pruning the language model with 1e-${p}"
ngram -lm ${lm_dir}/${corpus_name}.gt${g}.lm -prune 1e-${p} -write-lm ${lm_dir}/${corpus_name}.gt${g}_pruned${p}.lm

printf "%s\n" "converting language model to DMP format"
sphinx_lm_convert \
-i ${lm_dir}/${corpus_name}.gt${g}_pruned${p}.lm \
-o ${dmp_dir}/${corpus_name}.gt${g}_pruned${p}.lm.DM