lm_dir=${1}
out_dir=${2}

    wav_dir="/home/motaz/asr_dev/wav_recordings/part4/part4/jsc_20180731.wav"
    clt_file="/home/motaz/asr_dev/wav_recordings/part4/part4/jsc_20180731.fileids"
    dic_file="/home/motaz/asr_dev/arabic-spell-check/split-waw-corpus/split-waw-except_jsc7.dic"
    hmm_dir="/home/motaz/asr_dev/models/versions/v1/corected_1500"

    mkdir -p ${out_dir}

    for lm_file in ${lm_dir}/*.DMP
    do
	    lm_name=$(basename $lm_file)
	    echo $lm_name
	    dic_name=$(basename $dic_file)
	    am_name=$(basename $hmm_dir)
	    hyp_file="${out_dir}/${lm_name}.hyp"
	    if [ ! -f ${hyp_file} ]; then
		    /home/motaz/sphinx_source/pocketsphinx/src/programs/pocketsphinx_batch \
		 -adcin yes \
		 -cepdir ${wav_dir} \
		 -cepext .wav \
		 -ctl ${clt_file} \
		 -lm ${lm_file} \
		 -dict ${dic_file} \
		 -hmm ${hmm_dir} \
		 -hyp ${hyp_file} 
	    fi	
    done
