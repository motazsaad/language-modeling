#!/usr/bin/env bash

echo "prepare ${1}"

echo "split sentences"
sed -i -e "s/\./\\n/g" ${1}

echo "remove punctuation"
sed -i -e "s/[[:punct:]]\+/ /g" ${1}

echo "remove arabic punctuation"
sed -i -e 's/؟/ /g' -e 's/،/ /g' -e 's/؛/ /g' ${1}

echo "remove Arabic diacritics"
sed -i -e 's/َ//g' -e 's/ُ//g' -e 's/ِ//g' -e 's/ّ//g' -e 's/ً//g' -e 's/ٌ//g' -e 's/ٍ//g' -e 's/ْ//g' -e 's/ـ//g' ${1}


echo "remove non-arabic words "
sed -i 's/[^ء-ي]/ /g' ${1}
echo "السلام ожидалось  عليكم   ожидалось  كيف حالكم  " | sed 's/[^ء-ي]/ /g'


echo "remove duplicate words"
sed -i 's/\b\([ء-ي]\+\)[ ,\n]\1/\1/g' ${1}
# echo "مرحبا مرحبا كيف كيف الحال الحال" | sed -r 's/(.* )\1/\1/g' # it does not work if the repeated word is in the end of the line 
# echo "مرحبا مرحبا كيف كيف الحال الحال" | sed 's/\b\([ء-ي]\+\)[ ,\n]\1/\1/g' # this works perfectly 


echo "remove duplicate charachters"
sed -i 's/\(.\)\1\+/\1\1/g' ${1}
# echo "مشكوووووووووررررررر" | sed 's/\(.\)\1\+/\1\1/g'

echo "remove words that have only one letter"
sed -i -re 's/\<(.)\>//g' ${1}
# sed -re 's/\<(.)\>//g' <<< "السلام عليكم كيف الحال ش شو عم تعملو ي"


echo "remove empty lines"
sed -i '/^\s*$/d' ${1}


echo "replace whitespaces with one space"
sed -i 's/  */ /g' ${1}

echo "remove all leading and trailing whitespace from end of each line"
sed -i 's/^[ \t]*//;s/[ \t]*$//' ${1}

echo "remove empty lines again"
sed -i '/^\s*$/d' ${1}

echo "done! :)"

# sed -e 's/| euronews, العالم//g' -e 's/| euronews, هاي تيك//g' -e 's/| euronews, المجلة//g' -e 's/| euronews, أوروبا//g' -e 's/| euronews, العالم//g' -e 's/| euronews, شركات//g' -e 's/| euronews, سينما//g' -e 's/| euronews, علوم//g' -e 's/| euronews, اقتصاد//g' 

#echo "remove all digits and latin letters from a text file"
#sed -i -e 's/[0-9]*//g' -e 's/[A-Z]*//g' -e 's/[a-z]*//g' ${1} # not needed because: sed -i 's/[^ء-ي]/ /g' 





