function [ output_args ] = SizeLimit( value,min,max )
%SIZELIMIT 此处显示有关此函数的摘要
%   此处显示详细说明
if(value<min)
    output_args=int32(min);
else if(value>max)
        output_args=int32( max);
    else
       output_args=int32(value);
    end

end

