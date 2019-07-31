#!/usr/bin/env bash
source ~/py3env/bin/activate
#./formating.sh basem.arb2.lm1.hyp /home/motaz/asr_dev/wav_recordings/trans/alarabiya_wav_recording_split_silence2.trans


hyp_dir=${1}
ref=${2}

sed -i 's/^و */و/g'  ${ref} # replace new line waw space with new line waw
sed -i 's/ و */ و/g' ${ref} # replace space waw space with space waw

for hyp_file in ${hyp_dir}/*.hyp
do
        sed -i 's/^و */و/g'  ${hyp_file} # replace new line waw space with new line waw
        sed -i 's/ و */ و/g' ${hyp_file} # replace space waw space with space waw
	sed 's/.\{7\}$/)/' ${hyp_file} | sed 's/ )/)/' > ${hyp_file}1
	sed 's/ -)/)/g' ${hyp_file}1 > ${hyp_file}
	rm ${hyp_file}1
	/home/motaz/sphinx_source/sctk-2.4.10/src/sclite/sclite  -r ${ref} -h ${hyp_file} -i rm > ${hyp_file}_1650.results2
        sed '/Alignment/d' ${hyp_file}_1650.results2 > ${hyp_file}_1650.results
        rm ${hyp_file}_1650.results2
done
