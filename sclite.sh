hyp_dir=${1}
ref=${2}

for hyp_file in ${hyp_dir}/*.hyp
do
	/home/motaz/sphinx_source/sctk-2.4.10/src/sclite/sclite  -r ${ref} -h ${hyp_file} -i rm > ${hyp_file}.results2
        sed '/Alignment/d' ${hyp_file}.results2 > ${hyp_file}.results
        rm ${hyp_file}.results2
done
