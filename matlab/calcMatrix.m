load res -mat;
ID = res(:,1);
X1 = str2num(char(res{:,2}));
Y1 = str2num(char(res{:,3}));
P = [X1 Y1];
% Create matrix
A = dist(P,P');
M=A;
S=[];mm=0;
NS = 1:length(A);
while mm==0
    mm=round(rand(1)*length(A));
    S = [S,mm];
end

KNS=[];
A(find(A==0))=inf;

ii=1;Skns=[];
while length(S)~=length(A)
    NS = 1:length(A);
    NS(S)=0;
    NSnew = find(NS);
    KNS=[];
    for indexNS=NSnew%1:length(NSnew)
        k=[];
        for indexS=S%1:length(S)
            k = [k, A(indexNS,indexS)]; %A(NSnew(indexNS),S(indexS))
        end
        KNS = [KNS, min(k)];
        %KNSindex = S
    end     
    if ii==1
        [KNS,S1]=max(M(:,S));
        S = unique([S , S1]);
        Skns = [Skns, max(KNS)];
    else
        [~,ind] = max(KNS);
        Skns = [Skns, max(KNS)];
        S = [S, ind];
    end
    ii
    ii=ii+1;
end
%save Skns -mat
load Skns -mat
indices=find(Skns>2000);
Skns(indices);
antennas = S(indices);
xlswrite('antennas.xlsx',[antennas',P(antennas,1),P(antennas,2)])
