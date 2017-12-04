# primer3_masker

This GitHub repository stores source files of the **standalone version** of primer3_masker.
Primer3_masker is a general k-mer based sequence masking software that can be used for different purposes, not just for primer-design related masking.
It is integrated with Primer3 but it has also many additional options that can be used for flexible masking of DNA sequences.

Users interested in primer design software Primer3 and/or Primer3 web interface should look at https://github.com/primer3-org/primer3, which is the main location for Primer3 and may contain newer updates.

Installing:  
``
git clone https://github.com/bioinfo-ut/primer3_masker  
``

Compiling:  
```
cd primer3_masker  
cd src/  
make primer3_masker
```

Executing masker with the default model and k-mer tables:  
``
./primer3_masker -lh ../test_data/ -lp test ../test_data/template.fasta
``

Executing masker with absolute k-mer cutoff. Requires definition of single list name instead of list name prefix:  
``
./primer3_masker -a 10 -l ../test_data/test_16.list ../test_data/template.fasta
``

K-mer lists for standalone primer3_masker are available at http://primer3.ut.ee/lists.htm.


Options:
```
Usage: ./primer3_masker [OPTIONS] <INPUTFILE>
Options:
    -h, --help                   - print this usage screen and exit

    -p, --probability_cutoff     - masking cutoff based on probability of PCR failure [0, 1] (default: 0.1)
    -lh, --kmer_lists_path       - path to the kmer list files (default: ../kmer_lists/)
    -lp, --list_prefix           - define prefix of the k-mer lists to use (default: homo_sapiens)

    -a, --absolute_value_cutoff  - masking cutoff based on k-mer count; requires a single list name, defined with -l
    -l, --list                   - define a single k-mer list; for using with absolute cutoff option -a

    -m5, --mask_5p               - nucleotides to mask in 5' direction (default: 1)
    -m3, --mask_3p               - nucleotides to mask in 3' direction (default: 0)
    -c, --masking_char           - character used for masking (default: N)
    -s, --soft_mask              - use soft masking (default: false)
    -d, --masking_direction      - a strand to mask (fwd, rev, both) (default: both)
 ```
