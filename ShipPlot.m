function [h1,h2]=ShipPlot

x=[0     50     50      0   0   0       50     50  50   50     50  50  0   0   0   -20     0    0   -20      0   0       15       35      35      15      15      15      35      35      35      35      35      35      15      15      15      15      20      30      30      20      20                  30                  30                 20     20      20      30      30    20    30  30        20     20      30    30            ];
y=[0     0      5       5   0   -2.5    -2.5   0  -2.5  7.5    5   7.5 7.5 5   7.5  2.5    -2.5 0   2.5      5   7.5     7.5      7.5     -2.5    -2.5    7.5     7.5     7.5     7.5     7.5     -2.5    -2.5    -2.5    -2.5    -2.5    -2.5    7.5     7.5     7.5     -2.5    -2.5    7.5                  7.5              -2.5                 -2.5   0       5       5       0      0    0   -2.5      5      7.5     5     7.5  ];
z=[0     0      0       0   0   5       5      0   5    5      0   5   5   0   5    5      5    0   5        0   5       5        5       5       5       5       10      10      5       10      10      5       10      10      5       10      10      10      10      10      10      10                  10                  10                  10    15      15      15      15     15   15   10       15     10      15    10   ];

% The length is 53 i incremented each vec with 1 to get 9x6 matrices
%  x(end+1)=x(end);
%  y(end+1)=y(end);
%  z(end+1)=z(end);
%  figure(1);
 X=reshape(x,4,14);
 Y=reshape(y,4,14);
 Z=reshape(z,4,14);
 h1=surf(X,Y,Z);
 shading interp
 hold on
 h2=plot3(x,y,z,'k','LineWidth',1);
 xlim([-20 60]);ylim([-20 20]);zlim([-10 20])
% figure(1);
 