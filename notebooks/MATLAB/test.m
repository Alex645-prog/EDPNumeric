% POISSON EQUATION FINITE-DIFFERENCE ALGORITHM 12.1 
% 
% To approximate the solution to the Poisson equation 
%            DEL(u) = F(x,y), a <= x <= b, c <= y <= d, 
% SUBJECT TO BOUNDARY CONDITIONS: 
%                 u(x,y) = G(x,y), 
%     if x = a or x = b for c <= y <= d, 
%     if y = c or y = d for a <= x <= b 
% 
% INPUT:   endpoints a, b, c, d; integers m, n; tolerance TOL; 
%          maximum number of iterations M 
% 
% OUTPUT:  approximations W(I,J) to u(X(I),Y(J)) for each 
%          I = 1,..., n-1 and J=1,..., m-1 or a message that the 
%          maximum number of iterations was exceeded. 
clc; 
  
F = inline('x*exp(y)','x','y'); 
G = inline('x*exp(y)','x','y'); 

A = 0; 
B = 2; 

C = 0; 
D = 1; 

N = 6; 
M = 5; 

TOL = 1e-10; 
 
NN = 100;
 
OUP = 1; 

M1 = M-1; 
M2 = M-2; 
N1 = N-1; 
N2 = N-2; 
% STEP 1 
H = (B-A)/N; 
K = (D-C)/M; 
% STEPS 2 and 3 construct mesh points 
% STEP 2 
X = zeros(1,N+1); 
Y = zeros(1,M+1); 
W = zeros(N+1,M+1); 
for I = 0 : N 
X(I+1) = A+I*H; 
end 
% STEP 3 
for J = 0 : M 
Y(J+1) = C+J*K; 
end 
% STEP 4 
for I = 1 : N1 
W(I+1,1) = G(X(I+1),Y(1)); 
W(I+1,M+1) = G(X(I+1),Y(M+1)); 
end 
for J = 0 : M 
W(1,J+1) = G(X(1),Y(J+1)); 
W(N+1,J+1) = G(X(N+1),Y(J+1)); 
end 
for I = 1 : N1 
for J = 1 : M1 
W(I+1,J+1) = 0; 
end 
end 
WW = W
% STEP 5 
% use V for lambda, VV for mu 
V = H*H/(K*K); 
VV = 2*(1+V); 
L = 1; 
% Z is a new value of W(I,J) to be used in computing the norm 
% of the error E used in place of NORM 
% STEP 6 
OK = 0;
while L <= NN && OK == 0 
% STEPS 7 through 20 perform Gauss-Seidel iterations 
% STEP 7 
Z = (-H*H*F(X(2),Y(M1+1))+G(A,Y(M1+1))+V*G(X(2),D)+V*W(2,M2+1)+W(3,M1+1))/VV; 
E = abs( W(2,M1+1)-Z); 
W(2,M1+1) = Z; 
% STEP 8 
for I = 2 : N2 
    Z = (-H*H*F(X(I+1),Y(M1+1))+V*G(X(I+1),D)+W(I,M1+1)+W(I+2,M1+1)+V*W(I+1,M2+1))/VV; 
    if abs(W(I+1,M1+1)-Z) > E 
    E = abs( W(I+1,M1+1) - Z ); 
    end 
    W(I+1,M1+1) = Z; 
end 
% STEP 9 
Z = (-H*H*F(X(N1+1),Y(M1+1))+G(B,Y(M1+1))+V*G(X(N1+1),D)+W(N2+1,M1+1)+V*W(N1+1,M2+1))/VV; 
if abs( W(N1+1,M1+1)-Z) > E 
    E = abs( W(N1+1,M1+1)-Z); 
end 
W(N1+1,M1+1) = Z; 
% STEP 10 
for LL = 2 : M2 
    J = M2-LL+2; 
    % STEP 11 
    Z = (-H*H*F(X(2),Y(J+1))+G(A,Y(J+1))+V*W(2,J+2)+V*W(2,J)+W(3,J+1))/VV; 
    if abs(W(2,J+1)-Z) > E 
        E = abs(W(2,J+1)-Z); 
    end 
    W(2,J+1) = Z; 
    % STEP 12 
    for I = 2 : N2 
        Z = (-H*H*F(X(I+1),Y(J+1))+W(I,J+1)+V*W(I+1,J+2)+V*W(I+1,J)+W(I+2,J+1))/VV; 
        if abs(W(I+1,J+1)-Z) > E 
        E = abs(W(I+1,J+1)-Z); 
        end 
        W(I+1,J+1) = Z; 
    end 
    % STEP 13 
    Z = (-H*H*F(X(N1+1),Y(J+1))+G(B,Y(J+1))+W(N2+1,J+1)+V*W(N1+1,J+2)+V*W(N1+1,J))/VV; 
    if abs(W(N1+1,J+1)-Z) > E 
        E = abs(W(N1+1,J+1)-Z); 
    end 
    W(N1+1,J+1) = Z; 
end 
% STEP 14 
Z = (-H*H*F(X(2),Y(2))+V*G(X(2),C)+G(A,Y(2))+V*W(2,3)+W(3,2))/VV; 
if abs(W(2,2)-Z) > E 
E = abs(W(2,2)-Z); 
end 
W(2,2) = Z; 
% STEP 15 
for I = 2 : N2 
Z = (-H*H*F(X(I+1),Y(2))+V*G(X(I+1),C)+W(I+2,2)+W(I,2)+V*W(I+1,3))/VV; 
if abs(W(I+1,2)-Z) > E 
E = abs(W(I+1,2)-Z); 
end 
W(I+1,2) = Z; 
end 
% STEP 16 
Z = (-H*H*F(X(N1+1),Y(2))+V*G(X(N1+1),C)+G(B,Y(2))+W(N2+1,2)+V*W(N1+1,3))/VV; 
if abs(W(N1+1,2)-Z) > E 
E = abs(W(N1+1,2)-Z); 
end 
W(N1+1,2) = Z; 
% STEP 17 
if E <= TOL 
% STEP 18 
fprintf(OUP, 'POISSON EQUATION FINITE-DIFFERENCE METHOD\n\n'); 
fprintf(OUP,                                             '  I  J    X(I)        Y(J)         W(I,J)\n\n'); 
for I = 1 : N1  
for J = 1 : M1  
fprintf(OUP, '%3d %2d %11.8f %11.8f %13.8f\n',I,J,X(I+1),Y(J+1),W(I+1,J+1)); 
end 
end 
fprintf(OUP, 'Convergence occurred on iteration number: %d\n', L);  
% STEP 19 
OK = 1; 
else 
% STEP 20 
L = L+1; 
end 
W
end 
% STEP 21 
if L > NN  
fprintf(1,'Method fails after iteration number %d\n', NN) 
end 
if OUP ~= 1  
fclose(OUP); 
fprintf(1,'Output file %s created successfully \n',NAME); 
end 