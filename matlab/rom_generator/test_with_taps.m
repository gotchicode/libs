clc;
clear all;
close all;

%Parameters
entity_name = 'polyphase_taps';
rom_nb_cells=1024;
cell_size=18;

quant = 2^17-1;
%Read file
taps = csvread('../polyphase/taps.txt');
taps_quant = round(taps*quant);
values = [taps_quant; zeros(rom_nb_cells-length(taps_quant),1)];

##values = round(rand(1,rom_nb_cells)*2^16); %Random
phase=(0:2*pi/rom_nb_cells:2*pi-2*pi/rom_nb_cells);
##values = round(32767*sin(phase));
mem_or_logic=1; %0: logic %1:memory %Works on Altera 

rom_generation( entity_name,rom_nb_cells,cell_size,values,mem_or_logic);

