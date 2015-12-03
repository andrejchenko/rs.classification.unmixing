function score=MDPPI(x,dim,numit,weighted)
% MDPPI Multi-dimensional PPI
%
% Input:   x:        [d,N] input data set containing N points of dimension d
%          dim:      positive integer, dimensionality of the projections
%          numit:    positive integer, number of iterations
%          weighted: logical. Indicates if the results are weighted or not
%                    with their respective solid angles. Default true.
%
% Output:  score: [1,N] score vector
%
%
% Author:    Rob Heylen
% Date:      31 July 2012
% Institute: Visionlab, University of Antwerp
% Contact:   rob.heylen@uantwerpen.be
%
% Copyright (2012) Visionlab, University of Antwerp


MAXDIM=8;

if (dim > MAXDIM)
    error('The dimensionality is larger than the maximum allowed. This could take a very long time. If you really want to do this, disable this error in the code by increasing MAXDIM');
end

if nargin==3
    weighted=1;
end

if (weighted && (dim>3))
    error('Weighted MDPPI for dim>3 has not yet been implemented');
end

[d,N]=size(x);
score=zeros(1,N);

% One dimensional case: The PPI algorithm. Weighting only normalizes score.
if (dim==1)
    for i=1:numit
        y=randn(1,d)*x;
        [~,idx]=min(y);
        score(idx)=score(idx)+1;
        [~,idx]=max(y);
        score(idx)=score(idx)+1;
    end
end

% Two dimensional case: regular angles
if (dim==2)
    for i=1:numit
        v=orth(randn(d,2));
        y=v'*x;
        K=convhull(y(1,:),y(2,:));
        if ~weighted
            K=unique(K);
            score(K)=score(K)+1;
        else
            q=length(K);
            for j=1:q-1
                if j==1
                    c1=K(q-1);
                    c2=K(1);
                    c3=K(2);
                else
                    c1=K(j-1);
                    c2=K(j);
                    c3=K(j+1);
                end
                v1=(y(:,c3)-y(:,c2))/norm(y(:,c3)-y(:,c2));
                v2=(y(:,c1)-y(:,c2))/norm(y(:,c1)-y(:,c2));
                ang=real(pi-acos(v1'*v2));
                score(c2)=score(c2)+ang;
            end
        end
    end
end

% Three dimensional case: Solid angles
% Higher dimensional case: Only unweighted
if (dim>2)
    for i=1:numit
        % Randomly project the data onto a subspace, and determine the convex hull
        
        v=orth(randn(d,dim));    % Determine a random orthonormal set of dimensionality dim
        y=v'*x;                  % Project the data onto this subspace
        K=convhulln(y');         % Determine the convex hull of the projection
        Ki=unique(K);            % Ki is the index list of the vertices of the convex hull
        
        if (~weighted)
            score(Ki)=score(Ki)+1;
        else
            % For every face of the convex hull, determine the normal vector
            % pointing outwards with respect to the hull.
            
            center=mean(y,2);        % This point is guaranteed to lie inside the convex hull
            q=size(K,1);             % q counts the number of faces of the convex hull
            r=zeros(dim,q);          % r will contain the normal vectors to each face
            for j=1:q                % For every face, calculate the normal vector
                w=y(:,K(j,:));       %  w contains the points that determine the face
                a=zeros(dim,1);      % Calculate the orthogonal vector to this face:
                E=w(:,2:dim)-w(:,1)*ones(1,dim-1); % We displace everything with w(:,1)
                a(2:dim)=E\(center-w(:,1));        % Calculate the pseudo-inverse => barycentric coordinates of projection
                a(1,:)=1-sum(a(2:dim));            % Use sum-to-one constraint to complete barycentric coordinates
                r(:,j)=w*a-center;                 % Orthogonal vector equals projection minus original
            end
            r=normc(r);              % Normalization
            
            % Calculate the solid angles for each polar cone
            
            qi=length(Ki);           % qi is the number of vertices of the convex hull
            for j=1:qi               % For every vertex in the convex hull
                idx=Ki(j);                       % idx is the index of the j'th convex hull vertex
                
                % Rather involved method of making sure the polar cone
                % vectors are sorted...
                list=find(sum(K==idx,2));           % list contains the indices of the hull faces containing this vertex
                Li=length(list);                    % Li counts the number of faces
                L=K(list,:)';                       % L specifies all triangles containing this vertex
                L=(reshape(L(find(L~=idx)),2,Li))'; % L is pruned so that it no longer contains idx
                I=zeros(1,Li);
                Ls=zeros(1,Li);
                Ls(1:2)=L(1,:);                     % Turn L, containing indices of couples, into a sequential list Ls
                I(1)=1;
                L(1,:)=0;
                for i=3:Li
                    idx2=find(sum(L==Ls(i-1),2));
                    I(i-1)=idx2;
                    Ls(i)=L(idx2,(L(idx2,:)~=Ls(i-1)));
                    L(idx2,:)=0;
                end
                I(Li)=find(sum(L==Ls(1),2));
                rt=r(:,list(I));
                
                omega=solid_angle(rt);         % Determine the solid angle
                score(idx)=score(idx)+omega;   % Increase the corresponding PPI score with this angle
            end
        end
    end
end

if (weighted)
    if dim==1
        score=score/(2*numit);
    else
        score=score/(numit*2*(pi^(dim/2))/gamma(dim/2));
    end
end

end


function omega=solid_angle(x)
% SOLID_ANGLE returns the solid angle of the polyhedral cone determined by
% the oriented and normalized vertices in x.
% x is a [3,p] matrix containing p vectors.

[~,p]=size(x);
%x=normc(x);
a=zeros(1,p);
b=zeros(1,p);
c=zeros(1,p);
d=zeros(1,p);
for i=1:p
    if i==1 im=p; else im=i-1; end
    if i==p ip=1; else ip=i+1; end
    xm=x(:,im);
    xp=x(:,ip);
    xi=x(:,i);
    a(i)=xm'*xp;
    b(i)=xm'*xi;
    c(i)=xi'*xp;
    xc=[xi(2)*xp(3) - xi(3)*xp(2); xi(3)*xp(1) - xi(1)*xp(3); xi(1)*xp(2) - xi(2)*xp(1)];
    d(i)=xm'*xc;
end

d=(atan2(d,(b.*c - a)));
omega=2*pi-sum(d);
omega=omega.*(omega<=2*pi) + (4*pi-omega).*(omega>2*pi);

end