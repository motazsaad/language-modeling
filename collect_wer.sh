#!/usr/bin/env bash


for h in hyp/jsc*.hyp
do
echo ${h}
perl /usr/local/lib/sphinxtrain/scripts/decode/word_align.pl \
jsc_test.transcription ${h} | grep 'TOTAL Percent'
done



for h in hyp/N7*.hyp
do
echo ${h}
perl /usr/local/lib/sphinxtrain/scripts/decode/word_align.pl \
N7_020723_RMC_AR.transcription ${h} | grep 'TOTAL Percent'
done



for h in hyp/kacst*.hyp
do
echo ${h}
perl /usr/local/lib/sphinxtrain/scripts/decode/word_align.pl \
kacst2_test.transcription ${h} | grep 'TOTAL Percent'
done




