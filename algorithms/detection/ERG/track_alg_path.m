function [ result_x,result_y,result_feature,background] = track_alg_path( inputimg,width,height )
%An O(n) algorithm for tracking irdv small target 
%No more conv, just some tricks.
%target_x means the H position, while target_y means the W position.
%Just use them to find the pixel like img(target_x,target_y).

%edit  prams  below
%slide window size and step length,size should be odd.
windowh=40;
windoww=40;
slide_w=6;
slide_h=6;
feature=0;

stepw=int32((width-windoww-0.5*slide_w)/slide_w);
steph=int32((height-windowh-0.5*slide_h)/slide_h);
target_y=[];
target_x=[];
feature=[];
%start track
background=zeros(height,width);
 
for h=1:1:steph-1
    for w=1:1:stepw-1
        y_start=(w-1)*slide_w;
        x_start=(h-1)*slide_h;
        tmp=inputimg(x_start+1:1:x_start+windowh,y_start+1:1:y_start+windoww);%input the window data
        top=max(max(tmp));
        bottom=min(min(tmp));
        
        [t_x,t_y]=find(tmp==top);
        %trim
        y_start=SizeLimit(y_start+t_y(1)-windowh/2,0,width-windoww);
        x_start=SizeLimit(x_start+t_x(1)-windoww/2,0,height-windowh);
        tmp=inputimg(x_start+1:1:x_start+windoww,y_start+1:1:y_start+windowh);%input the window data
        top=max(max(tmp));
        bottom=min(min(tmp));
                %trim
        y_start=SizeLimit(y_start+t_y(1)-windowh/2,0,width-windoww);
        x_start=SizeLimit(x_start+t_x(1)-windoww/2,0,height-windowh);
        
        

        tmp=inputimg(x_start+1:1:x_start+windoww,y_start+1:1:y_start+windowh);%input the window data

        top=max(max(tmp));
        bottom=min(min(tmp));


        %Gmax
        Gmax=tmp;
        Gmax(3:windowh-2,3:windoww-2)=0;
        Pmax=max(max(Gmax));
        Gmax(3:windowh-2,3:windoww-2)=65535;
        Pmin=min(min(Gmax));
        %
        threshold=Pmax;%+(Pmax-Pmin);
        
        
        [m_y,m_x]=find(tmp>threshold);       
        [num,rub]=size(m_y);
        [numt,rub]=size(t_y);
        
        
%         y_start=min(int32(width-windoww),max(1,int32(y_start+double(sum(m_y)/num)-0.5*windoww)));
%         x_start=min(int32(height-windowh),max(1,int32(x_start+double(sum(m_x)/num)-0.5*windowh)));
%         tmp=inputimg(x_start+1:1:x_start+windoww,y_start+1:1:y_start+windowh);%input the window data
%         m_x=8;
%         m_y=8;
        
       % precise1=(double(sum(m_y)/num)-double(windowh)/2.0).^2+(double(sum(m_x)/num)-double(windoww)/2.0).^2;%if the target is the most bright point, where is it
        precise2=sum(sqrt((double(m_y)-double(sum(m_y)/num)).^2+(double(m_x)-double(sum(m_x)/num)).^2))/(num*sqrt(num));%target distribution
        
        if(num==0||num==1)
        precise=0.3762;
        else
            precise=precise2;
        end

        %count
        count=sum(sum(tmp>threshold));%the target size
        stde=std(double(tmp(:)),0);
        
        %a good target should have a clean background(stde+5,5 is a magic number, only to make it weight less)
        %the target should be in the center of our window(precise+2,magic
        %number again)2
        %and it should be brighter than background((top-avg)^2)
        %The proof number is too small, so multiplies 1000
        %Thus, I designed the proof, which has no relationship with brightness-----and lower is better
        %It works well
        %by ln93
        %proof=1000* (precise+2)*(stde+5)/(top-avg).^2;
        maxn=size(find(tmp>threshold));
        %energe=double(sum(tmp(tmp>threshold))-threshold*maxn(1));
        energe=double(max(max(tmp))-threshold);
        proof=(energe)*((0.3762/(precise))^1);
        
        
        %background(x_start+1:x_start+windowh,y_start+1:y_start+windoww)=proof+background(x_start+1:x_start+windowh,y_start+1:y_start+windoww);
        %background(x_start+12:x_start+18,y_start+12:y_start+18)=proof+background(x_start+12:x_start+18,y_start+12:y_start+18);
        %finally, we need to trim the position for our target.
        %if (count<15&&proof<judgement&&background(x_start+(sum(m_x)/num),y_start+(sum(m_y)/num))==0)%the target shouldn't be too huge
        if (1)
            %if(background(x_start+15,y_start+15)==0)
                target_y=[target_y,y_start+(sum(t_y)/numt)];
                target_x=[target_x,x_start+(sum(t_x)/numt)];
                feature=[feature,proof];
                
                
                %path
                background(x_start+1:x_start+windowh,y_start+1:y_start+windoww)=proof+background(x_start+1:x_start+windowh,y_start+1:y_start+windoww);
            %end
        

        end
      
        
    end
end
        %some target may be tracked twice or even more. that is, there may
        %be some target_xy which are totally the same.
        %so we have to delete them
        result_x=target_x;
        result_y=target_y;
        result_feature=feature;
%         [null,target_num]=size(target_x);
%         for i=1:1:target_num
%             
        
               
    
end

