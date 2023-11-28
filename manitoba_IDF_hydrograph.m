clc
clear
p=dir('*.xlsx');
for i=1:length(p);
a=xlsread(p(i).name,'RAINFALL','D2:AA12784');
a(isnan(a))=0;
[e b]=size(a);
% because 1 hr to 3 hr data to be aggregated 
three_hr=zeros(e,b-3+1);
six_hr=zeros(e,b-6+1);
twelve_hr=zeros(e,b-15+1);

for i=1:e;
for j=1:(b-3+1);
    three_hr(i,j)=sum(a(i,j:(j+3-1)));
  
end
    for k=1:(b-6+1);
    six_hr(i,k)=sum(a(i,k:(k+6-1)));
   
    end
    for l=1:(b-12+1);
    twelve_hr(i,l)=sum(a(i,l:(l+12-1)));
   
    end
end
one_day=sum(a,2);
one_hr=(max((a)'))';
three_hr=(max((three_hr)'))';
six_hr=(max((six_hr)'))';
twelve_hr=(max((twelve_hr)'))';
% w=xlsread('BG_precip_hourly.xlsx','RAINFALL','A2:C12784');
% one_hr=[w one_hr]% aggregated 1_hr
% three_hr=[w three_hr];% aggregated 3_hr
% six_hr=[w six_hr];% aggregated 6_hr
% twelve_hr=[w twelve_hr];% aggregated 12_hr
% one_day=[w one_day];% aggregated 1_day
% disp(three_hr);
% disp(six_hr);
% disp(twelve_hr);
% disp(one_day);
year=(1969:2003)';
one_hr_data_reshaped = (max(reshape(one_hr(1:365*35),365,2003-1969+1)))';
three_hr_data_reshaped = (max(reshape(three_hr(1:365*35),365,2003-1969+1)))';
six_hr_data_reshaped = (max(reshape(six_hr(1:365*35),365,2003-1969+1)))';
twelve_hr_data_reshaped = (max(reshape(twelve_hr(1:365*35),365,2003-1969+1)))';
one_day_data_reshaped = (max(reshape(one_day(1:365*35),365,2003-1969+1)))';
%
L=floor(length(one_day)/365);
seven_day_data_reshaped=(sum(reshape(one_day(1:L*365),365,L)))';
%
FINAL=[year one_hr_data_reshaped three_hr_data_reshaped six_hr_data_reshaped twelve_hr_data_reshaped one_day_data_reshaped seven_day_data_reshaped];
disp(FINAL);
rank=(1:35)'
for i=1:35
return_period(i,1)=(35+1)/i;
end
for i=1:35
   c2(i)=FINAL(i,2)/1;
   c3(i)=FINAL(i,3)/3;
c4(i)=FINAL(i,4)/6;
c5(i)=FINAL(i,5)/12;
c6(i)=FINAL(i,6)/24;
c7(i)=FINAL(i,7)/(24*7);
end
rain_intenisty=[FINAL(:,1) c2' c3' c4' c5' c6' c7'];
me_an=[c2' c3' c4' c5' c6' c7'];
m=mean(me_an)
stnd_dev=[c2' c3' c4' c5' c6' c7'];
s=std(stnd_dev)
T=[2 5 10 25  50 100];
for i=1:6
kt(i) =-(6^.5/pi)*[0.5772+log(log(T(i)/(T(i)-1)))];
end
one=m(1)+kt*s(1);
three=m(2)+kt*s(2);
six=m(3)+kt*s(3);
twelve=m(4)+kt*s(4);
one_day=m(5)+kt*s(5);
seven_day=m(6)+kt*s(6);
wait=[one;three;six;twelve;one_day;seven_day];
dur=[1 3 6 12 24 24*7]';
IDF_table=[dur wait];
subplot(1,2,1);
aa=plot(dur,IDF_table(:,2),'-+g');
hold on
a=plot(dur,IDF_table(:,3),'-*b')
b=plot(dur,IDF_table(:,4),'-vr');
c=plot(dur,IDF_table(:,5),'-sc');
d=plot(dur,IDF_table(:,6),'-xm')
e=plot(dur,IDF_table(:,7),'-ok');
f=title('Intensity-Duration-Frequency (IDF) curve','fontweight','bold','fontsize',20);
xlabel('Duration (hour)','fontsize',15);
ylabel('Rainfall Intensity (mm/hr)','fontsize',15);
legend([aa a b c d e],'T=2 years','T=5 years','T=10 years','T=25 years','T=50 years','T=100 years');


A=500*10000 %500 ha to m^2
%taking value of 1 hr_2 yr return period intensity 
hyetograph = (A/1000)*IDF_table(1,2)*[0,1,1,1,1,1,0]; % m^3/hr
time_interval = 1; % hour
time_to_peak = 3; % hours
    
    time_to_peak_steps = round(time_to_peak / time_interval);

    % Calculate the area under the hyetograph using the trapezoidal rule
    area_under_hyetograph = sum((hyetograph(1:end-1) + hyetograph(2:end)) / 2 * time_interval)

    % Initialize the synthetic unit hydrograph with zeros
    unit_hydrograph = zeros(1, time_to_peak_steps + 1);
 
    % Calculate the ordinates of the unit hydrograph
    for i = 1:time_to_peak_steps
        unit_hydrograph(i) = (hyetograph(i) + hyetograph(i + 1)) * time_interval / 2;
    end

    % Normalize the unit hydrograph to have a peak value of 1
    unit_hydrograph = unit_hydrograph / max(unit_hydrograph);

    % Extend the unit hydrograph to match the length of the hyetograph
    unit_hydrograph = [unit_hydrograph, zeros(1, length(hyetograph) - length(unit_hydrograph))];
    % Convolve the hyetograph with the unit hydrograph to generate the synthetic hydrograph
    hydrograph = conv(hyetograph, unit_hydrograph,'full');
    time = (0:length(hydrograph) - 1) * time_interval;
runoff=sum(hydrograph)*time_interval;
subplot(1,2,2)
plot(time, hydrograph, 'b-', 'LineWidth', 1.5);
xlabel('Time (hours)');
ylabel('Discharge (m^3/hr)');
title('Synthetic Hydrograph using Snyder Method');
grid on;
fprintf('Total runoff: %.2f m^3\n',runoff);
figure;
end 
