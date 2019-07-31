lm1=${1}
lm2=${2}
lm_dir=$(dirname "${lm1}")
filename=$(basename "${lm1}")
corpus1_name="${filename%%.*}"
filename=$(basename "${lm2}")
corpus2_name="${filename%%.*}"
lm_out=${corpus1_name}_${corpus2_name}
mkdir -p ${lm_dir}/mix_lm
mkdir -p ${lm_dir}/mix_dmp
for (( lmda=1; lmda<=9; lmda+=1))
do
   if [ ! -f ${lm_dir}/mix_lm/${lm_out}_lmd0${lmda}.lm ]; then
        /home/motaz/srilm/bin/i686-m64/ngram \
            -lm ${lm1} \
            -mix-lm ${lm2} \
            -lambda 0.${lmda} \
            -write-lm ${lm_dir}/mix_lm/${lm_out}_lmd0${lmda}.lm
    fi
    if [ ! -f ${lm_dir}/mix_dmp/${lm_out}_lmd0${lmda}.lm.DMP ]; then
        sphinx_lm_convert \
            -i ${lm_dir}/mix_lm/${lm_out}_lmd0${lmda}.lm \
            -o ${lm_dir}/mix_dmp/${lm_out}_lmd0${lmda}.lm.DMP
    fi


    if [ ! -f ${lm_dir}/mix_lm/${lm_out}_lmd0${lmda}_p9.lm ]; then
        /home/motaz/srilm/bin/i686-m64/ngram \
            -lm ${lm_dir}/mix_lm/${lm_out}_lmd0${lmda}.lm \
            -prune 1e-9 \
            -write-lm ${lm_dir}/mix_lm/${lm_out}_lmd0${lmda}_p9.lm
    fi
    if [ ! -f ${lm_dir}/mix_dmp/${lm_out}_lmd0${lmda}_p9.lm.DMP ]; then
        sphinx_lm_convert \
             -i ${lm_dir}/mix_lm/${lm_out}_lmd0${lmda}_p9.lm \
             -o ${lm_dir}/mix_dmp/${lm_out}_lmd0${lmda}_p9.lm.DMP
    fi

done
