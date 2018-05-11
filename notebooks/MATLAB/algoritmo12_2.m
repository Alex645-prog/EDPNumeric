%Programa que resuelve la siguiente ecuacion 
% Ut(x,t)- Uxx(x,t)=0  ,      0<x<1     0<=t
%
% Con las condiciones de fronteras
% U(0,t)=u(1,t)=0 ,     0<t 
%
%Con las condiciones iniciales
% U(x,0)= sin(pi*x) ,  0<=x<=1
%
% Comparar con la solucion real para t= 0.5
% U(x,t)= exp(-t*pi^2)*sin(pi*x)
%Obtenemos la Aproximacion para la ec. del calor

clear;
clc;
L = 1;
T = 0.5; %tiempo max
m = 10;
n = 50;
f = inline('sin(pi*x)','x');
 
%solucion real
g = inline('exp(-pi^2*t)*sin(pi*x)','t','x');
 
h = L/m;
k = T/n;
c = 1;
r = (c)^2*(k/h^2);
fprintf('valor de r = %4.4f \n',r);
%valores iniciales
for i = 1:m-1
    w(i) = f(i*h);
end

l(1) = 1 + 2*r;
u(1) = -r/l(1);

for i = 2:m-2
    l(i) = 1 + 2*r + r*u(i-1);
    u(i) = -r/l(i);
end
 
W = w';   % W almacena la columna w0
l(m-1) = 1 + 2*r + r*u(m-2);
for j = 1:n
    t = j*k;
    z(1) = w(1)/l(1);
    for i = 2:m-1
        z(i) = (w(i) + r*z(i-1))/l(i);
    end
    w(m-1) = z(m-1);
    for i = m-2:-1:1
        w(i) = z(i) - u(i)*w(i+1);
    end
    
    W = [W,w'];  %voy almacenando las columnas en W
    
end
W(:,n) = []; 
t

%imprimimos
disp('----------------------------------------------------');
disp('x(i)        w(i,50)     u(0.5,xi)   |w(i,50) - u(0.5,xi)|');
disp('----------------------------------------------------');
for i = 1:m-1
    y = g(t,i*h);
    fprintf('%2.1f      %4.8f     %4.8f      %1.3e \n',(i)*h,w(i),y,abs(w(i)-y));
end
 
%grafica
xnodos = linspace(0,L,m);  
xnodos(m) = [];
tnodos = linspace(0,T,n);
size(W)
mesh(tnodos,xnodos,W)
xlabel('t nodos')
ylabel('x nodos')
zlabel('u(t,x)')

