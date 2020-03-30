s=0;
for i=1:1:4
    p=[num2str(i),'.bmp']
a=imread(p);
b=im2bw(a);

s=s+sum(sum(b));
end
s
