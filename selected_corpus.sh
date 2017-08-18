#!/usr/bin/env bash
source ~/py3env/bin/activate

#cat s0192.arb train/aaw.arb train/jsc_2017_100k.arb train/bbc_2017.arb train/arwikinews_07_2017.arb train/arwiki_07_2017.arb train/xin.arb train/enews_2008_2013.arb train/umh.arb train/hyt.arb train/qds.arb train/elaph_2013.arb train/cnn_2010.arb > train/newswire.arb 


#n=${1}
#for n in 10 100 150 200
for n in 250
do
python wordfreq2vocab.py -t train/newswire.arb -v vocabs/newswire_gt${n}.vocab -gt ${n}

cat vocabs/newswire_gt${n}.vocab vocabs/s0192.vocab | sort | uniq > vocabs/newswire_golden_gt${n}.vocab

vocab_file=vocabs/newswire_golden_gt${n}.vocab
#vocab_file=vocabs/newswire_gt${n}.vocab

newswire=train/newswire.arb 

p=8
filename=$(basename "${newswire}")
corpus_name="${filename%%.*}"
#printf "%s\n" "building language mode for ${newswire}"
ngram-count -kndiscount -interpolate -text ${newswire} -vocab ${vocab_file}  -lm lms/${corpus_name}_gt${n}.lm
printf "%s\n" "prunning the language model with 1e-${p}"
ngram -lm lms/${corpus_name}_gt${n}.lm -prune 1e-${p} -write-lm lms/${corpus_name}_gt${n}pruned${p}.lm 
#ngram -lm lms/${corpus_name}_gt${n}pruned${p}.lm -write-bin-lm lms/${corpus_name}_gt${n}pruned${p}.lm.DMP
sphinx_lm_convert -i lms/${corpus_name}_gt${n}pruned${p}.lm -o lms/${corpus_name}_gt${n}pruned${p}.lm.DM

lm=lms/${corpus_name}_gt${n}pruned${p}.lm

printf "%s\n" "vocab size"
wc -l vocabs/newswire*

printf "%s\n" "lm size"
ls -lh lms/newswire* 


printf "%s\n" "testing the language model"
for test_text in ./test_data/*.txt
do
    test_name=$(basename $test_text)
    printf "test text: %s\n---------\n\n" ${test_name}
    lm_name=$(basename $lm)
    printf "applying %s\n" ${lm_name}
    ngram -lm ${lm} -ppl ${test_text} 
    printf "%s\n" "------------------"
done

done 
