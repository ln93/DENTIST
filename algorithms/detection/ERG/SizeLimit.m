function [ output_args ] = SizeLimit( value,min,max )
%SIZELIMIT �˴���ʾ�йش˺�����ժҪ
%   �˴���ʾ��ϸ˵��
if(value<min)
    output_args=int32(min);
else if(value>max)
        output_args=int32( max);
    else
       output_args=int32(value);
    end

end

