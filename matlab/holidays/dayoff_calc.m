clc;
clear all;
close all;

%Init the first day of the year
##year_const=2022;
##day_const=6; %Saturday
##is_bisextil_const=0;

year_const=2023;
day_const=7;
is_bisextil_const=0;

%Empty table of days
days_exist_table=zeros(31,12);
days_table=zeros(31,12);

%Fill months
days_exist_table(1:31,1)=zeros(1,31)+1; %01
days_exist_table(1:28,2)=zeros(1,28)+1; %02
days_exist_table(1:31,3)=zeros(1,31)+1; %03
days_exist_table(1:30,4)=zeros(1,30)+1; %04
days_exist_table(1:31,5)=zeros(1,31)+1; %05
days_exist_table(1:30,6)=zeros(1,30)+1; %06
days_exist_table(1:31,7)=zeros(1,31)+1; %07
days_exist_table(1:31,8)=zeros(1,31)+1; %08
days_exist_table(1:30,9)=zeros(1,30)+1; %09
days_exist_table(1:31,10)=zeros(1,31)+1; %10
days_exist_table(1:30,11)=zeros(1,30)+1; %11
days_exist_table(1:31,12)=zeros(1,31)+1; %12

%Fill months with days
tmp = day_const;
for m=1:12
  for d=1:31
    if days_exist_table(d,m)==1
      days_table(d,m)=tmp;
      if tmp==7 
        tmp =1;
      else
        tmp = tmp +1;
      end
    end
  end
end

%Calculate number of working days
tmp = 0;
for m=1:12
  for d=1:31
    if days_table(d,m)~=6 && days_table(d,m)~=7 && days_table(d,m)~=0
      tmp = tmp +1
    end
  end
end
printf("There are %d working days in the year\n",tmp);
full_working_days=tmp;

%Calculate days off
%1/1; 6/1; easter monday; boze cialo; 1/5; 3/5; 15/8; 1/10; 11/10; 25/12 25/12
tmp =2;
if days_table(1,1)~=6 && days_table(1,1)~=7
  tmp = tmp +1;
  printf("1/1 is a week day off\n");
end
if days_table(6,1)~=6 && days_table(6,1)~=7
  tmp = tmp +1
  printf("6/1 is a week day off\n");
end
if days_table(1,5)~=6 && days_table(1,5)~=7
  tmp = tmp +1;
  printf("1/5 is a week day off\n");
end
if days_table(3,5)~=6 && days_table(3,5)~=7
  tmp = tmp +1;
  printf("3/5 is a week day off\n");
end
if days_table(15,8)~=6 && days_table(15,8)~=7
  tmp = tmp +1;
  printf("15/8 is a week day off\n");
end
if days_table(1,10)~=6 && days_table(1,10)~=7
  tmp = tmp +1;
  printf("1/10 is a week day off\n");
end
if days_table(11,10)~=6 && days_table(11,10)~=7
  tmp = tmp +1;
  printf("11/10 is a week day off\n");
end
if days_table(25,12)~=6 && days_table(25,12)~=7
  tmp = tmp +1;
  printf("25/12 is a week day off\n");
end
if days_table(26,12)~=6 && days_table(26,12)~=7
  tmp = tmp +1;
  printf("26/12 is a week day off\n");
end
day_offs=tmp;

printf("total_days_off_in_week=%d\n",day_offs);

total_working_days=full_working_days-day_offs;
printf("total_working_days=%d\n",total_working_days);

total_working_days_minus_holidays = total_working_days-25;
printf("total_working_days_minus_holidays=%d\n",total_working_days_minus_holidays);