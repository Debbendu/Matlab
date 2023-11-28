clc;
clear;
%ssp 126 %access-cm2
Tmax=importdata('TMaxData.txt');
Tmin=importdata('TMinData.txt');
rain=importdata('PrecipData.txt');
%rain
precip=zeros(31413,191);
j=1;
for i=4:191;
    
 if (rain(1,i)>=88 & rain(1,i)<=89.82) & (rain(2,i)>=23.8&rain(2,i)<=25.27)
    precip(:,i)=rain(:,i);
 end
end
precip_1(:,1:3)=rain(:,1:3);
for i=4:191
    if precip(1,i)>0
        precip_1=[precip_1 precip(:,i)];
    end
end
    xlswrite('Precipitation.xls',precip_1)


      %Tmax
      B=zeros(31413,191);
j=1;
for i=4:191;
    
 if (Tmax(1,i)>=88 & Tmax(1,i)<=89.82) & (Tmax(2,i)>=23.8 & Tmax(2,i)<=25.27)
    B(:,i)=Tmax(:,i);
  
 end

end
tmax_1(:,1:3)=Tmax(:,1:3);
for i=4:191
    if B(1,i)>0
        tmax_1=[tmax_1 B(:,i)];
    end
end
 xlswrite('Tmax.xls',tmax_1)
%Tmin
A=zeros(31413,191);
j=1;
for i=4:191
    
 if (Tmin(1,i)>=88 & Tmin(1,i)<=89.82) & (Tmin(2,i)>=23.8&Tmin(2,i)<=25.27)
    A(:,i)=Tmin(:,i);
  
 
 end

end
tmin_1(:,1:3)=Tmin(:,1:3);
for i=4:191
    if A(1,i)>0
        tmin_1=[tmin_1 A(:,i)];
    end
end
 xlswrite('Tmin.xls',tmin_1)