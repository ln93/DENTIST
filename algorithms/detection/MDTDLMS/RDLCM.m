function [ rdlcm ] = RDLCM( img,tdlms )

%cut edge
[h w]=size(img);
input=double(img(6:h-6,6:w-6));
bg=double(tdlms(6:h-6,6:w-6));
[h w]=size(input);
%rflcm
rflcm=zeros(h-2,w-2);
for hh=2:1:h-1
    for ww=2:1:w-1
        rflcm(hh-1,ww-1)=sum(sum(input(hh-1:hh+1,ww-1:ww+1)))/(9*max(bg(hh,ww),5));
    end
end
%dflcm
dflcm=max(0.0,input-bg);
rdlcm=rflcm.*dflcm(2:h-1,2:w-1);

end

