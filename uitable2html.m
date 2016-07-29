function tabstr = uitable2html(hTab,filename,opts)
% TABLE2HTML(hTab,filename,opts)
%
%   hTab       - Handle of uitable to export
%   filename   - Name of output file (*.html)
%   opts       - Structure with aditional options (See Options)
%
% Export an uitable as HTML table.
%
% Example:
%
%       f = figure();
%       hTab = uitable(f,'Data',rand(10));
%       table2html(hTab,'MyExample.html');
%
% Options:
%
%      PageTitle   -  Title of the page
%      TableTitle  -  Title of the table
%      BgColor     -  Table background color
%      FontName    -  Font
%      BorderWidth -  Border width
%      AsString    -  Return as string (no write to file)
%
% Example with options:
%
%       f = figure();
%       opts.PageTitle = 'Example';
%       opts.TableTitle = 'My table';
%       opts.BgColor = '#00FF00';
%       opts.FontName = 'Arial';
%       opts.BorderWidth = '3';
%       hTab = uitable(f,'Data',rand(10));
%       table2html(hTab,'MyExample.html',opts);
%
%
%    -------------------------------
%       Ver. 1.0.0  ||  20/07/2016
%           Jorge De Los Santos
%        delossantosmfq@gmail.com
%     http://matlab-typ.blogspot.mx
%              MIT License
%    -------------------------------

if nargin < 1
    % If not there are input arguments, proceed
    % to search "uitable" objects.
    hTab = findobj('type','uitable');
    if ~isempty(hTab)
        filename = 'html/untitled.html';
    else
        error('uitable unavailable');
    end
end

if ~strcmp(get(hTab,'type'),'uitable')
    % Verify that handle is an uitable
    error('Handle must be an uitable');
end

% ========================== OPTIONS ===================================
fields_opts = {'PageTitle',   'Untitled',;
    'TableTitle',  '<b>Table 01</b>';
    'BgColor',     '#F0F0F0';
    'FontName',    'DejaVu Sans Mono';
    'BorderWidth', '2';
    'FontColor',   '#0000F0';
    'AsString', false};
if nargin == 3 && isstruct(opts)
    for k = 1:size(fields_opts,1) %#ok
        if ~isfield(opts,fields_opts{k,1})
            opts = setfield(opts,fields_opts{k,1},fields_opts{k,2}); %#ok
        end
    end
else
    opts = cell2struct(fields_opts(:,2),fields_opts(:,1),1);
end

% ======================= TABLE PROPERTIES ============================

X = get(hTab,'Data');
colnames = get(hTab,'ColumnName');
[nrows, ncols] = size(X);

% ========================= TEMPLATES ================================

COL_TEMP = '<TD>_col_</TD>';
ROW_TEMP = '<TR>_row_</TR>';
HEADER_TEMP = '<TH bgcolor=#DCDCFF>_header_</TH>';

TABLE_TEMP = ['<table border=_borderwidth_ bordercolor=#000000 cellspacing=5 cellpadding=5 bgcolor=_bgcolor_>',...
    '<caption>_tabletitle_</caption> _table_content_ </table>'];

HTML_TEMP = ['<html><head><title>_pagetitle_</title></head><body><font face="_fontname_">',...
    '_table_ </font> _footnote_ </body></html>'];

FOOT_TEMP = ['<br><br><br><font face="Arial Narrow" color=#C0C0C0 size=2>',...
    'Published by: <cite>uitable2html</cite></font>'];

% ========================== HEADERS =================================
if strcmp(colnames,'numbered')
    colnames = repmat('untitled|',1,ncols);
    remain = colnames;
    colnames = {};
    while 1
        [str,remain] = strtok(remain,'|'); %#ok
        if isempty(str),break,end;
        colnames = [colnames str]; %#ok
    end
end
rstr = WriteHeaders(colnames);
% Write table
WriteTable(rstr);

% Check output
if (nargout==1) && ~opts.AsString
    tabstr = ''; % Return a empty string
end

% Open file
if ~opts.AsString
    web(filename,'-browser');
end

% ====================================================================
    function rstr = WriteHeaders(headers)
        rstr = '';
        for k = 1:ncols
            rstr=[rstr,strrep(HEADER_TEMP,'_header_',headers{k})];
        end
        rstr = [rstr,char(13)];
    end

    function WriteTable(rstr)
        [path_,~,~] = fileparts(filename);
        if ~isempty(path_)
            if ~isdir(path_)
                mkdir(path_);
            end
        end
        
        for i=1:nrows
            cstr='';
            for j=1:ncols
                if isa(X,'cell')
                    cstr = [cstr,strrep(COL_TEMP,'_col_',num2str(X{i,j})),' '];
                else
                    cstr = [cstr,strrep(COL_TEMP,'_col_',num2str(X(i,j))),' '];
                end
            end
            rstr = [rstr,strrep(ROW_TEMP,'_row_',cstr),char(13)];
        end
        
        TABLE_STR = regexprep(TABLE_TEMP,{'_bgcolor_','_table_content_'...
            '_borderwidth_','_tabletitle_','_fontcolor_'},...
            {opts.BgColor,rstr,opts.BorderWidth,...
            opts.TableTitle,opts.FontColor});
        
        if opts.AsString
            tabstr = TABLE_STR;
            return;
        end
        
        WEB_PAGE = regexprep(HTML_TEMP,{'_footnote_','_fontname_',...
            '_table_','_pagetitle_'},...
            {FOOT_TEMP,opts.FontName,...
            TABLE_STR,opts.PageTitle});
        
        fid=fopen(filename,'w');
        fprintf(fid,'%s',WEB_PAGE);
        fclose(fid);
    end

end