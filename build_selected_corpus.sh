#!/usr/bin/env bash


# newswire_1: hyt + aaw + jsc + xin + qds
cat train/hyt.arb train/aaw.arb train/jsc_2017_100k.arb train/xin.arb train/qds.arb > select_corpus/newswire_1.arb


# newswire_2 : newswire_1 + afp + wiki + ahr
cat select_corpus/newswire1.arb train/afp.arb train/arwiki_07_2017.arb train/ahr.arb > select_corpus/newswire_2.arb


# newswire_all
#cat train/*.arb execluded_train/bbc_2017.arb execluded_train/s0192.arb > select_corpus/newswire_all.arb


nohup bash language-modeling/get_vocabs_greater_than_n.sh 200 ~/mod_home/selected_newswire vocabs language-modeling &



text_dir=~/mod_home/selected_newswire
vocab_dir=vocabs
lm_dir=selected_lms
dmp_dir=selected_dmps
sh_dir=language-modeling

g=200
p=8


for corpus in ${text_dir}/*.arb
do
    echo "building LM for ${corpus}"
    nohup bash ${sh_dir}/build_lm.sh ${corpus} ${vocab_dir} ${lm_dir} ${g} ${p} ${dmp_dir} &> ${corpus}.srilm.out&
done
