clc;
clear all;
close all;

%Parameters
entity_name = 'test';
rom_nb_cells=4096;
cell_size=16;
##values = round(rand(1,rom_nb_cells)*2^16); %Random
phase=(0:2*pi/rom_nb_cells:2*pi-2*pi/rom_nb_cells);
values = round(32767*sin(phase));
mem_or_logic=1; %0: logic %1:memory %Works on Altera 

rom_generation( entity_name,rom_nb_cells,cell_size,values,mem_or_logic);

