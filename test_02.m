% Test 02 for TABLE2HTML
% 
f = figure();
DM = {
    'Querétaro' ,25,20,29,25,20,21,22;
    'Puebla'    ,20,22,24,21,22,23,21;
    'Jalisco'   ,25,28,27,26,23,24,22;
    'Guanajuato',22,20,24,25,21,21,24
    };
opts.PageTitle = 'Temperatures';
opts.TableTitle = 'Table 02. Temperatures (°C)';
opts.BgColor = '#DDEEDD';
opts.FontName = 'Arial';
opts.BorderWidth = '3';
hTab = uitable(f,'Data',DM);
set(hTab,'ColumnName',{'State','S','M','T','W','T','F','S'});
uitable2html(hTab,'html/Ex02_Temperatures.html',opts);
close(f);