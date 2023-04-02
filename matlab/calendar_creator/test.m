clc;
clear all;
close all;

%disp(first_day_of_month(2023, 4)); % affichera "7" pour un dimanche

%Select the month
selected_month=4;
selected_year=2023;

%Work out the first day of the month
first_day_init=first_day_of_month(selected_year, selected_month);

%%Create the filename
filename = [num2str(selected_year) '_' num2str(selected_month)];

%% Define rows
%% date, day, working day or not, number of hours

fp = fopen(filename,"w");
fprintf(fp,"date; day; working day; nb hours;\n");
fclose(fp);
