# masker

Kompileerimine:  
cd src/  
make  

Maskeerimisprogrammi käivitamine vaikemudeli ja etteantud k-meeride tabelitega:  
cd src/  
./masker -lp ../test_andmed/test ../test_andmed/jarjestus.fa  

Primer3-e käivitamine (maskeerimine on sisse lülitatud, vt ../test_andmed/primer3_test_input):  
./primer3-core < ../test_andmed/primer3_test_input  
