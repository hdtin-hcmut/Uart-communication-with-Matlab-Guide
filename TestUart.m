delete(instrfind({'Port'},{'COM5'}));
s=serial('COM5','BaudRate',9600,'DataBits',8);
fopen(s);
count = 0;
while (count<400) 
count = count+1;
data = fscanf(s,'%f')
end