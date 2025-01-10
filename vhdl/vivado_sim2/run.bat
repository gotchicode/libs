call C:\Tools\Xilinx\Vivado\2024.1\.settings64-Vivado.bat
rmdir /S /Q tmp
mkdir tmp
copy /Y *.tcl .\tmp
cd tmp
vivado -mode batch -source run.tcl
cd ..