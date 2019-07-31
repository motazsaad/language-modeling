import argparse
import hunspell
import operator

# sudo apt install hunspell-ar
# sudo apt install libhunspell-dev

#source ~/py3env/bin/activate


parser = argparse.ArgumentParser(description='Arabic corpus filter based on hunspell. The input is a file and the output is filtered file after removing lines that  contains a specific ratio of spelling errors.')  # type: ArgumentParser

parser.add_argument('-i', '--infile', type=argparse.FileType(mode='r', encoding='utf-8'), help='input file.', required=True)

if __name__ == '__main__':
    hobj = hunspell.HunSpell('/home/motaz/asr_dev/arabic-spell-check/dict/ar.dic', '/home/motaz/asr_dev/arabic-spell-check/dict/ar.aff')
    args = parser.parse_args()
    lines = args.infile.read().splitlines()
    error_words=0
    total_words=0
    total_len=0
    count=0
    max_len=0
    max_len_word=''
    for line in lines:
        for word in line.split():
            total_words += 1
            total_len += len(word)
            if len(word) >= 15:
                count += 1
            if max_len < len(word):
                max_len = len(word)
                max_len_word = word
            if not hobj.spell(word):
                error_words += 1
    print(error_words/total_words)
    print(total_len/total_words)
    print(count)
    print(max_len)
    print(max_len_word)

