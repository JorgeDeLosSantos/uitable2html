% Simple test for TABLE2HTML
% No options specified
%
f = figure();
hTab = uitable(f,'Data',rand(3));
uitable2html(hTab,'html/Ex01_Random_Data.html');
close(f);