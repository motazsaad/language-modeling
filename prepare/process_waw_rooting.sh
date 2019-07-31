for cln_file in /home/motaz/LM/lm_201904/news/*.cln
do
    echo $cln_file
    python3 process_waw_rooting.py -i ${cln_file} -o ${cln_file}.arb
done

