#!/usr/bin/env bash
#source ~/py3env/bin/activate

import argparse
import re
import string

from alphabet_detector import AlphabetDetector
from bs4 import BeautifulSoup

parser = argparse.ArgumentParser(description='convert numbers 2 words')

parser.add_argument('-i', '--infile', type=argparse.FileType(mode='r', encoding='utf-8', errors='replace'),
                    help='input file.', required=True)
parser.add_argument('-o', '--outfile', type=argparse.FileType(mode='w', encoding='utf-8'),
                    help='out file.', required=True)
arabic_diacritics = re.compile("""
                             ّ    | # Tashdid
                             َ    | # Fatha
                             ً    | # Tanwin Fath
                             ُ    | # Damma
                             ٌ    | # Tanwin Damm
                             ِ    | # Kasra
                             ٍ    | # Tanwin Kasr
                             ْ    | # Sukun
                             ـ     # Tatwil/Kashida
                         """, re.VERBOSE)


def remove_diacritics(text):
    text = re.sub(arabic_diacritics, '', text)
    return text


def remove_punctuation(s):
    my_punctuations = string.punctuation + "،" + "؛" + "؟" + "«" + "»"
    translator = str.maketrans('', '', my_punctuations)
    return s.translate(translator)


def remove_punctuation2(s): # replace punctuation with space
    my_punctuations = string.punctuation + "،" + "؛" + "؟" + "«" + "»"
    replace_table = str.maketrans(my_punctuations,  ' '*len(my_punctuations))
    return s.translate(replace_table)


def html2text(text):
    soup = BeautifulSoup(text, 'html.parser')
    return soup.get_text()


def remove_links(text):
    # return re.sub(r'\s*(?:https?://)?www\.\S*\.[A-Za-z]{2,5}\s*', ' ', text, flags=re.MULTILINE).strip()
    # return re.sub(r'^https?:\/\/.*[\r\n]*', '', clean_text, flags=re.MULTILINE)
    return re.sub(r'(https|http)?:\/\/(\w|\.|\/|\?|\=|\&|\%)*\b', '', text, flags=re.MULTILINE)


def remove_empty_lines(text):
    lines = [s.rstrip() for s in text.split("\n") if s.rstrip()]
    return '\n'.join(lines)


def remove_repeating_char(text):
    # return re.sub(r'(.)\1+', r'\1', text)     # keep only 1 repeat
    return re.sub(r'(.)\1+', r'\1\1', text)  # keep 2 repeat


def keep_only_arabic(text):
    ad = AlphabetDetector()
    clean_lines = list()
    for line in text.splitlines():
        clean_line = list()
        for word in line.split():
            if len(word) > 1:
                if ad.is_arabic(word):
                    if word.isalpha():
                        clean_line.append(word)
        clean_lines.append(' '.join(clean_line))
    return '\n'.join(clean_lines)


def pre_clean(text):
    text = text.replace('\\', ' ')
    text = text.replace('/', ' ')
    text = text.replace('-', ' ')
    text = text.replace('(', ' ')
    text = text.replace(')', ' ')
    text = remove_links(text)
    text = remove_diacritics(text)
    text = remove_punctuation2(text)
    text = remove_empty_lines(text)
    return text

def post_clean(text):
    text = keep_only_arabic(text)
    text = remove_repeating_char(text)
    text = remove_empty_lines(text)
    return text

def IsInt(s):
    try: 
        int(s)
        return True
    except ValueError:
        return False


def num2words(num,join=True):
    '''words = {} convert an integer number into words'''
    units = ['','واحد','اثنان','ثلاثة','اربعة','خمسة','ستة','سبعة','ثمانية','تسعة']
    unit = ['','واحد','اثنان','ثلاث','اربع','خمس','ست','سبع','ثماني','تسع']
    teens = ['','احد عشر','اثنا عشر','ثلاثة عشر','اربعة عشر','خمسة عشر','ستة عشر','سبعة عشر','ثمانية عشر','تسعة عشر']
    tens = ['','عشرة','عشرون','ثلاثون','اربعون','خمسون','ستون','سبعون','ثمانون','تسعون']
    thousands = ['','الاف','ملايين','مليارات']
    thousands1 = ['','الف','مليون','مليار']
    thousands2 = ['','الفان','مليون','مليار']
    words = []
    if num==0: words.append('صفر')
    else:
        numStr = '%d'%num
        numStrLen = len(numStr)
        groups = int((numStrLen+2)/3)
        numStr = numStr.zfill(groups*3)
        for i in range(0,groups*3,3):
            h,t,u = int(numStr[i]),int(numStr[i+1]),int(numStr[i+2])
            g = int(groups-(i/3+1))
            if len(words)>0:
                if h>=1:
                    if h==1:
                        words.append('و'+'مئة')
                    elif h==2:
                        words.append('و'+'مئتان')
                    else:
                        words.append('و'+unit[h])
                        words.append('مئة')
            else:
                if h>=1:
                    if h==1:
                        words.append('مئة')
                    elif h==2:
                        words.append('مئتان')
                    else:
                        words.append(unit[h])
                        words.append('مئة')
            if t>1:
                if ((len(words)>0) and (h==0)) or (h>=1):
                    if u>=1: 
                        words.append('و'+units[u])
                        words.append('و'+tens[t])
                    else: words.append('و'+tens[t])
                else:
                    if u>=1: 
                        words.append(units[u])
                        words.append('و'+tens[t])
                    else: words.append(tens[t])
            elif t==1:
                if ((len(words)>0) and (h==0)) or (h>=1):
                    if u>=1: words.append('و'+teens[u])
                    else: words.append('و'+tens[t])
                else:
                    if u>=1: words.append(teens[u])
                    else: words.append(tens[t])
            else:
                if ((len(words)>0) and (h==0)) or (h>=1):
                    if u>=1: words.append('و'+units[u])
                else:
                    if u>=1: words.append(units[u])

            if ((g>=1) and (h==0) and (t==0) and (u==1)): 
                tword=words.pop()
                if tword=="وواحد":
                    words.append('و'+thousands1[g])
                else:
                    words.append(thousands1[g])
            elif (g>=1) and (h==0) and (t==0) and (u==2): 
                tword=words.pop()
                if tword=="واثنان":
                    words.append('و'+thousands2[g])
                else: 
                    words.append(thousands2[g])
            elif (g>=1) and ((h>=1) or (t>1) or (t==1 and u>=1)): 
                words.append(thousands1[g])
            elif (g>=1) and ((h+t+u)>0): 
                words.append(thousands[g])
    if join: return ' '.join(words)
    return words

def avg_line_len(text):
    lines=0
    lines_len=0
    for line in text.splitlines():
        lines+=1
        lines_len+=len(line.split())
    return lines_len/lines

def space_bewtween_digit_nondigit(line):
    clean_line = list()
    if len(line)>0:
        current=line[0]
    clean_line.append(current)
    prev2=""
    for i in range(1,len(line)):
        prev1=current
        current=line[i]
        if (prev2.isdigit() and prev1=="." and current.isdigit()) or (prev2.isdigit() and prev1=="," and current.isdigit()):
            clean_line.pop()
            clean_line.append(" فاصلة ")
        if (prev1.isdigit() and not current.isdigit()) or (not prev1.isdigit() and current.isdigit()):
            clean_line.append(" ")
        clean_line.append(current)
        prev2=prev1
    return ''.join(clean_line)

def remove_lines_contain_nonarabic_words(text):
    ad = AlphabetDetector()
    clean_lines = list()
    for line in text.splitlines():
        arabic=True
        for word in line.split():
            if not ad.is_arabic(word):
                arabic=False
        if arabic:
            clean_lines.append(line)
    return '\n'.join(clean_lines)

def process(text):
    clean_lines = list()
    lines=text.splitlines()
    index = 0
    while index < len(lines):
        line=lines[index]
        if line=='الجزيرة.نت':    #remove_heading_lines
            index = index + 2
        elif len(line.split())<=10:
            index = index + 0
        else:
            line=space_bewtween_digit_nondigit(line)
            line=num2word(line)
            clean_lines.append(line)
        index = index + 1
    return '\n'.join(clean_lines)

def num2word(line):
    clean_line = list()
    for word in line.split():
        if len(word)>20:    #detect long words
            print(word)
        elif IsInt(word):
            if len(word)<8:
                clean_line.append(num2words(int(word)))
            else:
                print(word)
        else:
            clean_line.append(word)
    return ' '.join(clean_line)

if __name__ == '__main__':
    args = parser.parse_args()
    print('processing {}'.format(args.infile.name))
    intext = args.infile.read()
    output_corpus = args.outfile
    temptxt=pre_clean(intext)
    temptxt2=process(temptxt)
    outtxt=post_clean(temptxt2)
    output_corpus.write(outtxt)
    print('done :)')
