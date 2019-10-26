%Resetting MATLAB environment
instrreset
clear
clc
close all
  
%Creating UDP object
  UDPComIn=udp('192.168.43.1','LocalPort',12345); %192.168.43.170
  set(UDPComIn,'DatagramTerminateMode','off')
  

  
%Reading sensor data continuously
  longestLag=0;

%
time=2;

Y_Hat1=zeros(1,1e5);

% primery value of kalman
x=[0.1,5,0.1,-2,1,1,1,0,0,0]';
delta=0.00001;
tw=0.001;
qq=0.1;
rw=0.01;
R= blkdiag(rw ,rw ,rw ,rw ,rw ,rw ,rw);
Q= blkdiag(qq ,qq ,qq ,qq ,qq ,qq ,qq ,qq ,qq ,qq);
M=eye(10)*100;
g=9.83;


while 1

tic
fopen(UDPComIn);
csvdata=fscanf(UDPComIn);
scandata=textscan(csvdata,'%s %f %f %f %f %f','Delimiter',',');
data=[scandata{4},scandata{5},scandata{6}];

% kalibre
data(1)=data(1);
data(2)=data(2);
data(3)=data(3);

% data(1)=data(1);
% data(2)=data(2);
% data(3)=0;
DATA(time,:)=data;
save('DATA','DATA')



%% Plot
  figure(1)
    [h1,h2]=ShipPlot;
    rotate(h1,[1 0 0],data(1,3));
    rotate(h1,[0 1 0],data(1,2));
 %   rotate(h1,[0 0 1],data(1,3));
    
    rotate(h2,[1 0 0],data(1,3));
    rotate(h2,[0 1 0],data(1,2));
%    rotate(h2,[0 0 1],data(1,3));
    hold off;
    
   
%%

fclose(UDPComIn);
t=toc;
longestLag=max(t,longestLag);


%%
DATAA2=[0, 0, 0, DATA(time,1), DATA(time,2), DATA(time,3),0];

    
     A=[          1,(delta*x(5))/2, (delta*x(6))/2, (delta*x(7))/2, (delta*x(2))/2, (delta*x(3))/2, (delta*x(4))/2, 0, 0, 0;
 (delta*x(5))/2,            1, (delta*x(7))/2, (delta*x(6))/2, (delta*x(1))/2, (delta*x(4))/2, (delta*x(3))/2, 0, 0, 0;
 (delta*x(6))/2, (delta*x(7))/2,            1, (delta*x(5))/2, (delta*x(4))/2, (delta*x(1))/2, (delta*x(2))/2, 0, 0, 0;
 (delta*x(7))/2, (delta*x(6))/2, (delta*x(5))/2,            1, (delta*x(3))/2, (delta*x(2))/2, (delta*x(1))/2, 0, 0, 0;
              0,            0,            0,            0, delta/tw + 1,            0,            0, 0, 0, 0;
              0,            0,            0,            0,            0, delta/tw + 1,            0, 0, 0, 0;
              0,            0,            0,            0,            0,            0, delta/tw + 1, 0, 0, 0;
              0,            0,            0,            0,            0,            0,            0, 1, 0, 0;
              0,            0,            0,            0,            0,            0,            0, 0, 1, 0;
              0,            0,            0,            0,            0,            0,            0, 0, 0, 1];
          
          x=A*x;
          M=A*M*A'+Q;
          h=[(x(1)*x(3)-x(2)*x(4))*2*g; (-(x(1)*x(2)+x(3)*x(4))*2*g); (-x(1)^2+x(2)^2+x(3)^2-x(4)^2)*g; x(5)+x(8); x(6)+x(9); x(7)+x(10);2*(x(2)*x(3)+x(1)*x(4))/(x(1)^2+x(2)^2-x(3)^2-x(4)^2)];
          H=[  2*g*x(3), -2*g*x(4),2*g*x(1), -2*g*x(2), 0, 0, 0, 0, 0, 0
              -2*g*x(2),   -2*g*x(1), -2*g*x(4), -2*g*x(3), 0, 0, 0, 0, 0, 0
              -2*g*x(1),   2*g*x(2),  2*g*x(3), -2*g*x(4), 0, 0, 0, 0, 0, 0
              0,             0,           0,        0, 1, 0, 0, 1, 0, 0
              0,             0,       0,        0, 0, 1, 0, 0, 1, 0
              0,             0,      0,        0, 0, 0, 1, 0, 0, 1
              (2*x(4))/(x(1)^2 + x(2)^2 - x(3)^2 - x(4)^2) - (2*x(1)*(2*x(1)*x(4) + 2*x(2)*x(3)))/(x(1)^2 + x(2)^2 - x(3)^2 - x(4)^2)^2, (2*x(3))/(x(1)^2 + x(2)^2 - x(3)^2 - x(4)^2) - (2*x(2)*(2*x(1)*x(4) + 2*x(2)*x(3)))/(x(1)^2 + x(2)^2 - x(3)^2 - x(4)^2)^2, (2*x(2))/(x(1)^2 + x(2)^2 - x(3)^2 - x(4)^2) + (2*x(3)*(2*x(1)*x(4) + 2*x(2)*x(3)))/(x(1)^2 + x(2)^2 - x(3)^2 - x(4)^2)^2, (2*x(1))/(x(1)^2 + x(2)^2 - x(3)^2 - x(4)^2) + (2*x(4)*(2*x(1)*x(4) + 2*x(2)*x(3)))/(x(1)^2 + x(2)^2 - x(3)^2 - x(4)^2)^2, 0, 0, 0, 0, 0, 0];
          
          Y= DATAA2'-h;
          S= H*M*H'+R;
          K=M*H'/S;
          x=x+K*Y;
          M=M-K*S*K';
          tanroll=2*(x(3)*x(4)+x(1)*x(2))/(x(1)^2-x(2)^2-x(3)^2+x(4)^2);
          roll=atan(tanroll);

    Y_Hat1(time)=h(6);
    Y_Hat2(time)=h(5);


%%

%% Plot
figure(4)
    [h1,h2]=ShipPlot;
    deferenc1(time) = DATA(time,3)-Y_Hat1(time);
    deferenc2(time) = DATA(time,2)-Y_Hat2(time);    
    if abs(deferenc1(time))<10
        deferenc1(time)= 0;
    end
    if abs(deferenc2(time))<10
        deferenc2(time)= 0;
    end
    rotate(h1,[1 0 0],deferenc1(time));
    rotate(h1,[0 1 0],deferenc2(time));

    rotate(h2,[1 0 0],deferenc1(time));
    rotate(h2,[0 1 0],deferenc2(time));

hold off;

 %%   
pause(0.00001)
time=time+1;


end


% 