function A = plus(B,C) % --*-- Unitary tests --*--

%@info:
%! @deftypefn {Function File} {@var{A} =} plus (@var{B},@var{C})
%! @anchor{@dseries/plus}
%! @sp 1
%! Overloads the plus method for the Dynare time series class (@ref{dseries}).
%! @sp 2
%! @strong{Inputs}
%! @sp 1
%! @table @ @var
%! @item B
%! Dynare time series object instantiated by @ref{dseries}.
%! @item C
%! Dynare time series object instantiated by @ref{dseries}.
%! @end table
%! @sp 1
%! @strong{Outputs}
%! @sp 1
%! @table @ @var
%! @item A
%! Dynare time series object.
%! @end deftypefn
%@eod:

% Copyright (C) 2011-2014 Dynare Team
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

if isnumeric(B) && (isscalar(B) ||  isvector(B))
    if ~isdseries(C)
        error('dseries::plus: Second input argument must be a dseries object!')
    end
    A = C;
    A.data = bsxfun(@plus,C.data,B);
    return;
end

if isnumeric(C) && (isscalar(C) || isvector(C))
    if ~isdseries(B)
        error('dseries::plus: First input argument must be a dseries object!')
    end
    A = B;
    A.data = bsxfun(@plus,B.data,C);
    return
end

if ~isequal(B.vobs,C.vobs) && ~(isequal(B.vobs,1) || isequal(C.vobs,1))
    error(['dseries::plus: Cannot add ' inputname(1) ' and ' inputname(2) ' (wrong number of variables)!'])
else
    if B.vobs>C.vobs
        idB = 1:B.vobs;
        idC = ones(1,B.vobs);
    elseif B.vobs<C.vobs
        idB = ones(1,C.vobs);
        idC = 1:C.vobs;
    else
        idB = 1:B.vobs;
        idC = 1:C.vobs;
    end
end

if ~isequal(B.freq,C.freq)
    error(['dseries::plus: Cannot add ' inputname(1) ' and ' inputname(2) ' (frequencies are different)!'])
end

if ~isequal(B.nobs,C.nobs) || ~isequal(B.init,C.init)
    [B, C] = align(B, C);
end

if isempty(B)
    A = C;
    return
end

if isempty(C)
    A = B;
    return
end

A = dseries();

A.freq = B.freq;
A.init = B.init;
A.nobs = max(B.nobs,C.nobs);
A.vobs = max(B.vobs,C.vobs);
A.name = cell(A.vobs,1);
A.tex = cell(A.vobs,1);
for i=1:A.vobs
    A.name(i) = {['plus(' B.name{idB(i)} ',' C.name{idC(i)} ')']};
    A.tex(i) = {['(' B.tex{idB(i)} '+' C.tex{idC(i)} ')']};
end
A.data = bsxfun(@plus,B.data,C.data);
A.dates = A.init:A.init+(A.nobs-1);

%@test:1
%$ % Define a datasets.
%$ A = rand(10,2); B = randn(10,1);
%$
%$ % Define names
%$ A_name = {'A1';'A2'}; B_name = {'B1'};
%$
%$ t = zeros(5,1);
%$
%$ % Instantiate a time series object.
%$ try
%$    ts1 = dseries(A,[],A_name,[]);
%$    ts2 = dseries(B,[],B_name,[]);
%$    ts3 = ts1+ts2;
%$    t(1) = 1;
%$ catch
%$    t = 0;
%$ end
%$
%$ if length(t)>1
%$    t(2) = dyn_assert(ts3.vobs,2);
%$    t(3) = dyn_assert(ts3.nobs,10);
%$    t(4) = dyn_assert(ts3.data,[A(:,1)+B, A(:,2)+B],1e-15);
%$    t(5) = dyn_assert(ts3.name,{'plus(A1,B1)';'plus(A2,B1)'});
%$ end
%$ T = all(t);
%@eof:1

%@test:2
%$ % Define a datasets.
%$ A = rand(10,2); B = randn(10,1);
%$
%$ % Define names
%$ A_name = {'A1';'A2'}; B_name = {'B1'};
%$
%$ t = zeros(5,1);
%$
%$ % Instantiate a time series object.
%$ try
%$    ts1 = dseries(A,[],A_name,[]);
%$    ts2 = dseries(B,[],B_name,[]);
%$    ts3 = ts1+ts2;
%$    ts4 = ts3+ts1; 
%$    t(1) = 1;
%$ catch
%$    t = 0;
%$ end
%$
%$ if length(t)>1
%$    t(2) = dyn_assert(ts4.vobs,2);
%$    t(3) = dyn_assert(ts4.nobs,10);
%$    t(4) = dyn_assert(ts4.data,[A(:,1)+B, A(:,2)+B]+A,1e-15);
%$    t(5) = dyn_assert(ts4.name,{'plus(plus(A1,B1),A1)';'plus(plus(A2,B1),A2)'});
%$ end
%$ T = all(t);
%@eof:2


%@test:3
%$ % Define a datasets.
%$ A = rand(10,2); B = randn(5,1);
%$
%$ % Define names
%$ A_name = {'A1';'A2'}; B_name = {'B1'};
%$
%$ t = zeros(5,1);
%$
%$ % Instantiate a time series object.
%$ try
%$    ts1 = dseries(A,[],A_name,[]);
%$    ts2 = dseries(B,[],B_name,[]);
%$    ts3 = ts1+ts2;
%$    t(1) = 1;
%$ catch
%$    t = 0;
%$ end
%$
%$ if length(t)>1
%$    t(2) = dyn_assert(ts3.vobs,2);
%$    t(3) = dyn_assert(ts3.nobs,10);
%$    t(4) = dyn_assert(ts3.data,[A(1:5,1)+B(1:5), A(1:5,2)+B(1:5) ; NaN(5,2)],1e-15);
%$    t(5) = dyn_assert(ts3.name,{'plus(A1,B1)';'plus(A2,B1)'});
%$ end
%$ T = all(t);
%@eof:3

%@test:4
%$ t = zeros(7,1);
%$
%$ try
%$     ts = dseries(transpose(1:5),'1950q1',{'Output'}, {'Y_t'});
%$     us = dseries(transpose(1:5),'1949q4',{'Consumption'}, {'C_t'});
%$     vs = ts+us;
%$     t(1) = 1;
%$ catch
%$     t = 0;
%$ end
%$
%$ if length(t)>1
%$     t(2) = dyn_assert(ts.freq,4);
%$     t(3) = dyn_assert(us.freq,4);
%$     t(4) = dyn_assert(ts.init.time,[1950, 1]);
%$     t(5) = dyn_assert(us.init.time,[1949, 4]);
%$     t(6) = dyn_assert(vs.init.time,[1949, 4]);
%$     t(7) = dyn_assert(vs.nobs,6);
%$ end
%$
%$ T = all(t);
%@eof:4

%@test:5
%$ t = zeros(7,1);
%$
%$ try
%$     ts = dseries(transpose(1:5),'1950q1',{'Output'}, {'Y_t'});
%$     us = dseries(transpose(1:7),'1950q1',{'Consumption'}, {'C_t'});
%$     vs = ts+us;
%$     t(1) = 1;
%$ catch
%$     t = 0;
%$ end
%$
%$ if length(t)>1
%$     t(2) = dyn_assert(ts.freq,4);
%$     t(3) = dyn_assert(us.freq,4);
%$     t(4) = dyn_assert(ts.init.time,[1950, 1]);
%$     t(5) = dyn_assert(us.init.time,[1950, 1]);
%$     t(6) = dyn_assert(vs.init.time,[1950, 1]);
%$     t(7) = dyn_assert(vs.nobs,7);
%$ end
%$
%$ T = all(t);
%@eof:5

%@test:6
%$ t = zeros(8,1);
%$
%$ try
%$     ts = dseries(transpose(1:5),'1950q1',{'Output'}, {'Y_t'});
%$     us = dseries(transpose(1:7),'1950q1',{'Consumption'}, {'C_t'});
%$     vs = ts+us('1950q1').data;
%$     t(1) = 1;
%$ catch
%$     t = 0;
%$ end
%$
%$ if length(t)>1
%$     t(2) = dyn_assert(ts.freq,4);
%$     t(3) = dyn_assert(us.freq,4);
%$     t(4) = dyn_assert(ts.init.time,[1950, 1]);
%$     t(5) = dyn_assert(us.init.time,[1950, 1]);
%$     t(6) = dyn_assert(vs.init.time,[1950, 1]);
%$     t(7) = dyn_assert(vs.nobs,5);
%$     t(8) = dyn_assert(vs.data,ts.data+1);
%$ end
%$
%$ T = all(t);
%@eof:6

%@test:7
%$ t = zeros(8,1);
%$
%$ try
%$     ts = dseries([transpose(1:5), transpose(1:5)],'1950q1');
%$     us = dseries([transpose(1:7),2*transpose(1:7)],'1950q1');
%$     vs = ts+us('1950q1').data;
%$     t(1) = 1;
%$ catch
%$     t = 0;
%$ end
%$
%$ if length(t)>1
%$     t(2) = dyn_assert(ts.freq,4);
%$     t(3) = dyn_assert(us.freq,4);
%$     t(4) = dyn_assert(ts.init.time,[1950, 1]);
%$     t(5) = dyn_assert(us.init.time,[1950, 1]);
%$     t(6) = dyn_assert(vs.init.time,[1950, 1]);
%$     t(7) = dyn_assert(vs.nobs,5);
%$     t(8) = dyn_assert(vs.data,bsxfun(@plus,ts.data,[1, 2]));
%$ end
%$
%$ T = all(t);
%@eof:7