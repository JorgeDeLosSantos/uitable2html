% Simple test for TABLE2HTML
% No options specified
%
close all;clear;clc;
f = figure();
hTab = uitable(f,'Data',rand(3));
opts.AsString = 0;
x = uitable2html(hTab,'html/Ex01_Random_Data.html',opts);
close(f);