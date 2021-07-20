clc;
clear all;
close all;


val=rand(1,256);

fig=1;
figure(fig);
plot(val);
print (fig, "test.pdf", "-dpdflatexstandalone");