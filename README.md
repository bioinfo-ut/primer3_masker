# masker

Compiling:  
cd src/  
make  

Executing masker with the default model and k-mer tables:  
cd src/  
./primer3_masker -lp ../test_data/test ../test_data/template.fasta  

Executing Primer3 from command line (with masking switched on by setting the flags in ../test_data/primer3_test_input):  
./primer3_core < ../test_data/primer3_test_input  
