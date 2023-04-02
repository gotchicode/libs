clc;
clear all;
close all;

%disp(first_day_of_month(2023, 4)); % affichera "7" pour un dimanche

%Select the month
selected_month=4;
selected_year=2023;

%Work out the first day of the month
%Sunday is 7 ...
first_day_init=first_day_of_month(selected_year, selected_month);

%%Create the filename
filename = [num2str(selected_year) '_' num2str(selected_month) '.txt'];

%% Define rows
%% date, day, working day or not, number of hours

%Open file
fp = fopen(filename,"w");

%Initialize the first line
fprintf(fp,"date; day; working day; worked; comments;\n");

%nb_days_in_month
nb_days_in_month = days_in_month(selected_year, selected_month);

%Loop
for k=1:nb_days_in_month
  tmp = [num2str(selected_year) '/' num2str(selected_month) '/' num2str(k) ';'];
  fprintf(fp,"%s",tmp);
  tmp = getDayOfWeek(selected_month, k, selected_year);
  fprintf(fp,"%s;",tmp);
  if ( strcmp(tmp,"Saturday") || strcmp(tmp,"Sunday"))
    tmp = '0';
  else
    tmp = '1';
  endif
  fprintf(fp,"%s;",tmp);
  fprintf(fp,"1;",tmp);
  fprintf(fp,"  ;",tmp);
  fprintf(fp,"\n");
end

fclose(fp);

fprintf("=SOMME(C1:C32)\n");
fprintf("=SOMME(C1:C32)*8\n");
fprintf("=SOMME(C1:C32)*0.8\n");
fprintf("=SOMME(C1:C32)*8*0.8\n");
