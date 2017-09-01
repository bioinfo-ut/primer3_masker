# primer3_masker

This GitHub repository stores source files of the standalone version of primer3_masker.
Primer3_masker is a general k-mer based sequence masking software that can be used for different purposes, not just for primer-design related masking.
It is integrated with Primer3 but it has also many additional options that can be used for flexible masking of DNA sequences. 

Users interested in primer design software Primer3 and/or Primer3 web interface should look at https://sourceforge.net/projects/primer3/, which is the main location for Primer3 and may contain newer updates.


Compiling:  
cd src/  
make  


Executing masker with the default model and k-mer tables:  
cd src/  
./primer3_masker -lp ../test_data/test ../test_data/template.fasta  

Options:
Usage: ./primer3_masker [OPTIONS] <INPUTFILE>
Options:
    -h, --help                   - print this usage screen and exit
    -l, --list                   - define a k-mer list as model variable (-l <LISTNAME> [coefficient mismatches sq]
    -lf, --lists_file            - define a model with a file
    -lp, --list_prefix           - prefix of the k-mer lists to use with default model
    -p, --probability_cutoff     - masking cutoff [0, 1] (default: 0.1)
    -a, --absolute_value_cutoff  - k-mer count cutoff
    -m5, --mask_5p               - nucleotides to mask in 5' direction
    -m3, --mask_3p               - nucleotides to mask in 3' direction
    -c, --masking_char           - character used for masking
    -s, --soft_mask              - use soft masking
    -d, --masking_direction      - a strand to mask (fwd, rev, both) (default: both)