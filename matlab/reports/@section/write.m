function o = write(o, fid, pg, sec)
%function o = write(o, fid, pg, sec)
% Write Section object
%
% INPUTS
%   o         [section] section object
%   fid       [integer] file id
%   pg        [integer] this page number
%   sec       [integer] this section number
%
% OUTPUTS
%   o         [section] section object
%
% SPECIAL REQUIREMENTS
%   none

% Copyright (C) 2013-2014 Dynare Team
%
% This file is part of Dynare.
%
% Dynare is free software: you can redistribute it and/or modify
% it under the terms of the GNU General Public License as published by
% the Free Software Foundation, either version 3 of the License, or
% (at your option) any later version.
%
% Dynare is distributed in the hope that it will be useful,
% but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
% GNU General Public License for more details.
%
% You should have received a copy of the GNU General Public License
% along with Dynare.  If not, see <http://www.gnu.org/licenses/>.

assert(fid ~= -1);
fprintf(fid, '%% Section Object\n');
if ~isempty(o.height)
    fprintf(fid, '\\setlength\\sectionheight{%s}%%\n', o.height);
end
fprintf(fid, '\\maxsizebox{\\textwidth}{');
if isempty(o.height)
    fprintf(fid, '!');
else
    fprintf(fid, '\\sectionheight');
end
fprintf(fid, '}{%%\n');
fprintf(fid, '\\begin{tabular}[t]{');
for i=1:o.cols
    fprintf(fid, 'c');
end
fprintf(fid, '}\n');
ne = numElements(o);
nlcounter = 0;
row = 1;
col = 1;
for i=1:ne
    if isa(o.elements{i}, 'vspace')
        assert(col == o.cols, ['@section.write: must place ' ...
                            'vspace command after a linebreak in the table ' ...
                            'or series of charts']);
        o.elements{i}.write(fid);
        fprintf(fid, '\\\\\n');
    else
        o.elements{i}.write(fid, pg, sec, row, col);
        if col ~= o.cols
            fprintf(fid, ' & ');
            col = col + 1;
        else
            fprintf(fid, '\\\\\n');
            row = row + 1;
            col = 1;
        end
    end
end
fprintf(fid, '\\end{tabular}}\n');
fprintf(fid, '%% End Section Object\n\n');
end