import argparse
import operator


parser = argparse.ArgumentParser(description='Arabic corpus filter based on hunspell. The input is a file and the output is filtered file after removing lines that  contains a specific ratio of spelling errors.')  # type: ArgumentParser

parser.add_argument('-i', '--infile', type=argparse.FileType(mode='r', encoding='utf-8'), help='input file.', required=True)
parser.add_argument('-o', '--outfile', type=argparse.FileType(mode='w', encoding='utf-8'), help='output file.', required=True)

if __name__ == '__main__':
    args = parser.parse_args()
    lines = args.infile.read().splitlines()
    outfile = args.outfile
    for line in lines:
        del_line = False
        for word in line.split():
            if len(word) >= 12:
                del_line = True
                print(line)
                break
        if not del_line :
            outfile.write(line+'\n')


