call C:\Tools\Xilinx\Vivado\2018.2\.settings64-Vivado.bat
rmdir /S /Q tmp
mkdir tmp
copy /Y *.tcl .\tmp
cd tmp
vivado -mode batch -source run.tcl
cd ..