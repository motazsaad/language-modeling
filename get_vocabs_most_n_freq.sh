#!/usr/bin/env bash
#source lm_cmds.sh > lm.log 2>&1
source ~/py3env/bin/activate
n=40000
printf "most frequent %s\n" "${n}"
for corpus in train_data/*
do
    filename=$(basename "$corpus")
    corpus_name="${filename%%.*}"
    printf "%s\n" "generating vocab for ${corpus}"
    mkdir vocabs/${corpus_name}
    python word_freq2vocab.py -t ${corpus} -v vocabs/${corpus_name}/${corpus_name}.${n}.vocab -top ${n}
done




#lm_name="s0192_spk.ext"
##corpus_name="train_newswire_all_s.txt"
##corpus_name="train_newswire_all.txt"
#corpus_name="train_all"
#
#n=3
#for gt in 3 5 10 100
#do
#    ngram-count -kndiscount -interpolate -text $corpus_name.txt -vocab "$corpus_name"_gt"$gt".vocab -lm "$lm_name"."$n"g_gt"$gt"_unpruned.lm
#    ngram -lm "$lm_name"."$n"g_gt"$gt"_unpruned.lm -prune 1e-8 -write-lm "$lm_name"."$n"g_gt"$gt".lm
#    echo "convert to DMP"
#    sphinx_lm_convert -i "$lm_name"."$n"g_gt"$gt".lm -o "$lm_name"."$n"g_gt"$gt".lm.DMP
#    cp "$lm_name"."$n"g_gt"$gt".lm.DMP ~/speechdata/elra/prepare/lms/
#done





# train vocab = 1240305
# news vocab = 1238224
# s0192 vocab = 36913

#cat data/cnn.2010.clean.arb data/jsc.2004.clean.arb data/arwikinews_07_2017.clean.arb data/enews.08_13.clean.arb data/jsc.2013.clean.arb > train_newswire_except_s0192_wiki.txt

#cat data/cnn.2010.clean.arb data/jsc.2004.clean.arb data/arwikinews_07_2017.clean.arb data/enews.08_13.clean.arb data/jsc.2013.clean.arb data/arwiki_07_2017.clean.arb > train_newswire_except_s0192.txt

#cat data/cnn.2010.clean.arb data/jsc.2004.clean.arb data/s0192.clean.arb data/arwikinews_07_2017.clean.arb data/enews.08_13.clean.arb data/jsc.2013.clean.arb > train_newswire_all.txt


#sed 's/.*/<s> & <\/s>/' train_newswire_all.txt > train_newswire_all_s.txt

#python word_freq2vocab.py -t train_all.txt -v train_all_gt100.vocab -gt 100
#python word_freq2vocab.py -t train_all.txt -v train_all_gt10.vocab -gt 10
#python word_freq2vocab.py -t train_all.txt -v train_all_gt5.vocab -gt 5
#python word_freq2vocab.py -t train_all.txt -v train_all_gt3.vocab -gt 3

