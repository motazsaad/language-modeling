# language-modeling
## scripts for language modeling 
This project is a collection of scripts that help for language modeling. These scripts include: 

 
* text cleaning 
* text normalization
* vocabulary counts and frequencies 
* language models building 
* testing language models 
* 

## steps for preparing texts: 
1. source ~/py3env/bin/activate 
2. prepare/prepare_text_for_lm.sh 
3. prepare/normalize_months.sh 

## steps for building Vocab: 
A Vocabulary can be built in two ways
1. Based on a frequency theshold (build_vocab/get_vocabs_greater_than_n.sh) 
2. Based on most frequent N terms (build_vocab/get_vocabs_most_freq.sh)

Both scripts use build_vocab/wordfreq2vocab.py 
```
usage: wordfreq2vocab.py [-h] -t TEXT -v VOCABULARY -f FREQUENCY
                         [-top TOP | -gt GT | -all]
```

## steps for building LM: 
```build_lm/build_lm.sh```

