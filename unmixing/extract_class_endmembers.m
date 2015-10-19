function [E,I]=extract_class_endmembers(L)
% extract_class_endmembers
% Rob Heylen
% L is a cell array with p cells. Each cell contains a matrix with spectra
% listed columnwise. The algorithm will find the maximal simplex, with the
% constraint that one endmember has to be selected from each cell. The E
% matrix will contain the final endmembers, and I will contain the indices
% of these endmembers into the library elements: E(:,i) = L{i}(:,I(i))

numit=3;

p=numel(L);
for i=1:p
    N(i)=size(L{i},2);
    I(i)=randperm(N(i),1);
end
for i=1:p
    E(:,i)=L{i}(:,I(i));
end

for it=1:numit
    for lib=1:p
        [x,~]=plane_project2(L{lib},E(:,setdiff(1:p,lib)));
        dist=sum((x-L{lib}).^2);
        [~,I(lib)]=max(dist);
        E(:,lib)=L{lib}(:,I(lib));
    end
end
end


function [y,a]=plane_project2(x,E)
    [~,M]=size(x);
    p=size(E,2);
    a=zeros(p,M);
    ct=E(:,1);
    Ep=E(:,2:p)-ct*ones(1,p-1);
    a(2:p,:)=Ep\(x-ct*ones(1,M));
    a(1,:)=ones(1,M)-sum(a(2:p,:),1);
    y=E*a;
end