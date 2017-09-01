# masker

Compiling:  
cd src/  
make  

Execute masker with the default model and k-mer tables:  
cd src/  
./masker -lp ../test_data/test ../test_data/template.fa  

Executing Primer3 from command line (with masking switched on by setting the flags in ../test_data/primer3_test_input):  
./primer3-core < ../test_data/primer3_test_input  
