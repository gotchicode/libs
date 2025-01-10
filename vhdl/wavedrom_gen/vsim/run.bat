call C:\Tools\Xilinx\Vivado\2024.1\.settings64-Vivado.bat
rmdir /S /Q sim
mkdir sim
copy /Y *.tcl .\sim
cd sim
vivado -mode batch -source run.tcl
cd ..