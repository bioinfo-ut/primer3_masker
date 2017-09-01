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

Executing Primer3 from command line (with masking switched on by setting the flags in ../test_data/primer3_test_input):  
./primer3_core < ../test_data/primer3_test_input  
