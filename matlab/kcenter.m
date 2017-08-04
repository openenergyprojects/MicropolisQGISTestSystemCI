function [S, R, XY] = kcenter()
% kcenter
%   [S, R, XY] = kcenter()
% input:
%   P - X, Y Coordinates
%   k - the number of centers to be choosen.
% output:
%   S - indices of antennas
%   R - covering radius
%   C - X,Y possitions of antennas
% example :
% [S R XY] = kcenter()
file='buildingsIDXY.xlsx';
[~,~,res] = xlsread(file);
file='buildingsIDXYRes.csv';

%Inputs
% load res -mat;
% file = 'antennas.csv';

ID = res(:,1);
X1 = str2num(char(res{2:end,2}));
Y1 = str2num(char(res{2:end,3}));
P = [X1 Y1];
S=1;
% limit = 1300; %meters Gia tis polles antennes genika MICRO
limit = 200; % PICO

%initial
n = length(P);
L = zeros(1,n);
L(1) = S;
% initial DD, R
Skns = zeros(n, length(P));
R = zeros(n-1,1);

% Calculate symmetric matrix A
A=dist(P,P');
Skns(1, :) = A(1,:);   
SknsMin = Skns(1, :);

for i=2:n %868
  [R(i-1), newL] = max(SknsMin);
  L(i) = newL;
  Skns(i,:) = A(L(i),:);
  SknsMin = min(SknsMin, Skns(i,:));
end

%results
R(n) = max(SknsMin);
S =L';
XY = P(L,:);
S=S(find(R>limit));

% Write CSV File
if exist(file)
   delete(file) 
end
csvwrite(file,[S,XY(find(R>limit),1),XY(find(R>limit),2)]);
[tlines]=regexp( fileread(file), '\n', 'split');
tlinesNew = cell(1,length(tlines)+1);
tlinesNew{1}='ID, X, Y';
tlinesNew(2:end)=tlines;
f = fopen(file,'w');
for i=1:length(tlinesNew)
    fprintf(f,tlinesNew{i});
    fprintf(f,'\n');
end
fclose all;

