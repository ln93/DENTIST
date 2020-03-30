function [ B ] = MDTDLMS( img )
%MDTDLMS 14bit
%   
p=5;%outer
q=3;%inner
[h,w]=size(img);
img=double(img);



%background estimate

%templates
m1=zeros(2*p+1,2*p+1);
m1(1:p,:) = 1;
m1(p-q+1:p+q+1,p-q+1:p+q+1)=0;

m2=zeros(2*p+1,2*p+1);
m2(:,1:p) = 1;
m2(p-q+1:p+q+1,p-q+1:p+q+1)=0;

m3=zeros(2*p+1,2*p+1);
m3(:,p+2:2*p+1) = 1;
m3(p-q+1:p+q+1,p-q+1:p+q+1)=0;

m4=zeros(2*p+1,2*p+1);
m4(p+2:2*p+1,:) = 1;
m4(p-q+1:p+q+1,p-q+1:p+q+1)=0;

m5=zeros(2*p+1,2*p+1);
for i=1:1:2*p+1
   for j=1:1:2*p+1-i 
    m5(i,j)=1;
   end
end
m5(p-q+1:p+q+1,p-q+1:p+q+1)=0;

m6=zeros(2*p+1,2*p+1);
for i=2:1:2*p+1
   for j=2*p+3-i:1:2*p+1 
    m6(i,j)=1;
   end
end
m6(p-q+1:p+q+1,p-q+1:p+q+1)=0;

m7=zeros(2*p+1,2*p+1);
for i=2:1:2*p+1
   for j=1:1:i-1 
    m7(i,j)=1;
   end
end
m7(p-q+1:p+q+1,p-q+1:p+q+1)=0;

m8=zeros(2*p+1,2*p+1);
for i=1:1:2*p+1
   for j=i+1:1:2*p+1 
    m8(i,j)=1;
   end
end
m8(p-q+1:p+q+1,p-q+1:p+q+1)=0;

%right m2 m5 m7
%left m3 m6 m8
%down m1
%up m4

%background estimate TDLMS
miu=10^-7;

miu=miu*miu;

result=zeros(8,h,w);

%right m2 m5 m7
for hh=1+p:1:h-p
    W=zeros(2*p+1,2*p+1);
    W2=W;
    W5=W;
    W7=W;
    for j=1+p:1:w-p
        result(2,hh,j)=sum(sum(W2.*m2.*img(hh-p:hh+p,j-p:j+p)))-img(hh,j);
        result(5,hh,j)=sum(sum(W5.*m5.*img(hh-p:hh+p,j-p:j+p)))-img(hh,j);
        result(7,hh,j)=sum(sum(W7.*m7.*img(hh-p:hh+p,j-p:j+p)))-img(hh,j);
        e2=img(hh,j)-result(2,hh,j);
        e5=img(hh,j)-result(5,hh,j);
        e7=img(hh,j)-result(7,hh,j);
        W2=W2+miu*e2*img(hh-p:hh+p,j-p:j+p);
        W5=W5+miu*e5*img(hh-p:hh+p,j-p:j+p);
        W7=W7+miu*e7*img(hh-p:hh+p,j-p:j+p);
    end
end
%left m3 m6 m8
for hh=1+p:1:h-p
    W=zeros(2*p+1,2*p+1);
    W3=W;
    W6=W;
    W8=W;
    for j=w-p:-1:1+p
        result(3,hh,j)=sum(sum(W3.*m3.*img(hh-p:hh+p,j-p:j+p)))-img(hh,j);
        result(6,hh,j)=sum(sum(W6.*m6.*img(hh-p:hh+p,j-p:j+p)))-img(hh,j);
        result(8,hh,j)=sum(sum(W8.*m8.*img(hh-p:hh+p,j-p:j+p)))-img(hh,j);
        e3=img(hh,j)-result(3,hh,j);
        e6=img(hh,j)-result(6,hh,j);
        e8=img(hh,j)-result(8,hh,j);
        W3=W3+miu*e3*img(hh-p:hh+p,j-p:j+p);
        W6=W6+miu*e6*img(hh-p:hh+p,j-p:j+p);
        W8=W8+miu*e8*img(hh-p:hh+p,j-p:j+p);
    end
end
%down m1
for j=1+p:1:w-p
    W1=zeros(2*p+1,2*p+1);
    for hh=1+p:1:h-p
        result(1,hh,j)=sum(sum(W1.*m1.*img(hh-p:hh+p,j-p:j+p)))-img(hh,j);
        e1=img(hh,w)-result(1,hh,j);
        W1=W1+miu*e1*img(hh-p:hh+p,j-p:j+p);
    end
end
%up m4
for j=1+p:1:w-p
    W4=zeros(2*p+1,2*p+1);
    for hh=h-p:-1:1+p
        result(4,hh,j)=sum(sum(W4.*m4.*img(hh-p:hh+p,j-p:j+p)))-img(hh,j);
        e4=img(hh,w)-result(1,hh,j);
        W4=W4+miu*e4*img(hh-p:hh+p,j-p:j+p);
    end
end
%generate min result
swap=zeros(1,8);
B=zeros(h,w);
for y=1:1:w
    for x=1:1:h
        for index=1:1:8
            swap(index)=(double(result(index,x,y))-img(x,y))^2;
        end

        k=find(swap==min(swap));
        B(x,y)=result(k(1),x,y);
    end
end

            

end