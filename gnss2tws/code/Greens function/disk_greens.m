function up=disk_greens(thet,lmax,love_h,alph_disk)
%
% Description: Calculating vertical displacement at the point with a
% angular distance (thet) from a disk load (radius: alph_disk, EWH: 1 m)
%
% Input:
%   thet            Angular distance (thet) from the center of a disk loads
%   lmax            Maximum degree to calcuate LGFs
%   love_h          LLNs h
%   alph_disk       Radius of the disk
% Output:
%   up              Vertical displacement
%
% Author: Zhongshan Jiang
% Date: 28/10/2021 
% Institution: Southwest Jiaotong University 
% E-mail: jzshhh@my.swjtu.edu.cn

global gq;
Pot=Potential(lmax,alph_disk);
Pl=Legendre(lmax,thet);
up=0;

for i=1:lmax+1
    up=up+love_h(i)*Pot(i)*Pl(i)/gq;
end
end

function Pot1=Potential(n,alph)
% Gravity disturbance potential
global Aq  Gq;
Pl=Legendre(n,alph);
mass=disk_mass(alph);
Pot=NaN(1,n+1);
Pot(1)=mass*Gq/Aq;
for i=2:n+1
    Pot(i)=mass*Gq*(Pl(i-1)-Pl(i+1))/(Aq*(1-cosd(alph))*(2*(i-1)+1));
end
Pot1=Pot';
end

function mass=disk_mass(alph)
% Calculate the mass of a disk with radius 
global Aq pw;
mass=1*pw*2*pi*(1-cosd(alph))*Aq^2;
end

function P1=Legendre(n,deg)
% Calculating legendre polynomial
P=NaN(1,n+2);
x=cosd(deg);
P(1)=1;
P(2)=x;
for i=3:n+2
    P(i)=((2*i-3)*x*P(i-1)-(i-2)*P(i-2))/(i-1);
end
P1=P';
end
