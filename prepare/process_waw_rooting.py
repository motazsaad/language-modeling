import argparse

from nltk.stem.isri import ISRIStemmer

#source ~/py3env/bin/activate

def get_root_word(arabic_word):
    arabic_stemmer = ISRIStemmer()
    arabic_root = arabic_stemmer.stem(arabic_word)
    return arabic_root


def separate_waw(text):
    words = line.split()
    sentence = ''
    replacement = dict()
    for word in words:
        except_list=['وداد','وجود','وزراء','وزرائه','وزرائها','وسام','وسطاء','وصفت','وصول','وعاء','وعود','وفاق','وكالات','والدتنا','وفود',
'وقوع','وقوف','ولد','ولي','وليام','وليامز','وليمز','وجهة','وارزازات']
        if word.startswith('و') and word not in except_list:
            root = get_root_word(word)
            if root.startswith('و'):
                sentence += word + ' '
            else:
                sentence += 'و ' + word[1:] + ' '
                replacement[word] = 'و ' + word[1:]
                #print('{} changed to {}'.format(word, 'و ' + word[1:]))
        else:
            sentence += word + ' '
    return sentence,replacement


parser = argparse.ArgumentParser(description='separate the '
                                             'conjunction waw from '
                                             'Arabic words')

parser.add_argument('-i', '--infile', type=argparse.FileType(mode='r', encoding='utf-8'),
                    help='input file.', required=True)
parser.add_argument('-o', '--outfile', type=argparse.FileType(mode='w', encoding='utf-8'),
                    help='out file.', required=True)

if __name__ == '__main__':
    args = parser.parse_args()
    lines = args.infile.readlines()
    clean_lines = list()
    replacement = dict()
    for line in lines:
        new_text, line_replacement =separate_waw(line)
        clean_lines.append(new_text)
        for key, value in line_replacement.items() :
            replacement[key]=value
    args.outfile.write('\n'.join(clean_lines))
    for key, value in replacement.items() :
        print(key,value)
