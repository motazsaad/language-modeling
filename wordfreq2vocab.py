import argparse
from collections import Counter

parser = argparse.ArgumentParser(description='generate word frequencies from a text corpus')

parser.add_argument('-t', '--text', type=argparse.FileType(mode='r', encoding='utf-8'),
                    help='text corpus', required=True)
parser.add_argument('-v', '--vocabulary', type=argparse.FileType(mode='w', encoding='utf-8'),
                    help='the output vocabulary file', required=True)
parser.add_argument('-f', '--frequency', type=argparse.FileType(mode='w', encoding='utf-8'),
                    help='frequency file', required=True)

group = parser.add_mutually_exclusive_group()
group.add_argument('-top', type=int, help='top N words (most N frequent words)')
group.add_argument('-gt', type=int, help='words that have frequency greater than gt')
group.add_argument('-all', action='store_true', help='all words (vocabulary) in the corpus')


def get_most_n_frequent(text, outfile, freq_file, top):
    word_counter = Counter()
    word_counter.update(text.split())
    top_words = word_counter.most_common(top)
    outfile.write('\n'.join([w for w, f in word_counter.most_common(top)]))
    outfile.write('\n')
    sorted_top_words = sorted(top_words.items(), key=lambda pair: pair[1], reverse=True)
    freq_file.write('\n'.join(["{}\t{}".format(w, f) for w, f in sorted_top_words]))


def get_freqs_gt(text, outfile, freq_file, gt):
    word_counter = Counter()
    word_counter.update(text.split())
    outfile.write('\n'.join([w for w, f in word_counter.items() if f > gt]))
    outfile.write('\n')
    sorted_word_counter = sorted(word_counter.items(), key=lambda pair: pair[1], reverse=True)
    freq_file.write('\n'.join(["{}\t{}".format(w, f) for w, f in word_counter.items() if f > gt]))


def get_all_vocab(text, outfile):
    vocab = set(text.split())
    vocab.remove('<s>')
    vocab.remove('</s>')
    outfile.write('\n'.join(vocab))
    outfile.write('\n')


if __name__ == '__main__':
    args = parser.parse_args()
    infile = args.text.read()
    outfile = args.vocabulary
    freq_file = args.frequency
    freq_file.write('# text |w|={}\n'.format(len(infile.split())))
    freq_file.write('# text |v|={}\n'.format(len(set(infile.split()))))
    if args.top:
        get_most_n_frequent(infile, outfile, freq_file, args.top)
    if args.gt:
        get_freqs_gt(infile, outfile, freq_file, args.gt)
    if args.all:
        get_all_vocab(infile, outfile)
