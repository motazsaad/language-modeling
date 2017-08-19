 #!/usr/bin/env bash

filename=$(basename "${1}")
corpus_name="${filename%%.*}"
printf "%s\n" "building language mode for ${1}"
ngram-count -kndiscount -interpolate -text ${1} -vocab vocabs/${corpus_name}.gt5.vocab  -lm lms/${corpus_name}.lm
ngram -lm lms/${corpus_name}.lm -prune 1e-8 -write-lm lms/${corpus_name}_pruned.lm   

