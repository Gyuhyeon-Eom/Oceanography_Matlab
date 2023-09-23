gridN_lat = 21;
gridN_lon = 21;

u = ones(gridN_lat, gridN_lon) .* (2*1e7);

u(1,:) = 0; u(:,1) = 0; u(end,:) = 0; u(:,end) = 0; u(end,end) = 0;
u_beta = u;

X0 = 1000*1000; %km^2
x = 0:(X0/(gridN_lon-1)):X0;

Y0 = 1000*1000;%km^2
y = 0:(Y0/(gridN_lat-1)):Y0;

lat = 0 : 45/(gridN_lat-1) : 45; 
beta =  2*(10^-11);

rho = 1000; %kg/m^3
gam = 1e-6; %Hz

tow0 = 0.1; %N/m^2

n = 1;
while n~= 251

    figure(1)
    set(gcf,'position',[100 200 1000 400],'color','w')
    subplot(1,2,1)
    contourf(u,'LineStyle','none')
    

    colorbar
    title('f = f_0',['n = ', num2str(n)])
    
    
    subplot(1,2,2)
    contourf(u_beta,'LineStyle','none');
 
    colorbar
    title('f = f_0 + \beta y',['n = ', num2str(n)])
   
%%%%%% Solve the equation using finite difference %%%%%%%%
    dx = diff(x,1);
    dx1 = dx(1);
    for i = 2:20
        for j = 2:20
            u(i,j) = ((pi*tow0/(gam*rho*Y0)*sin(pi*x(i)/Y0)*((dx1^2)/4))...
                +(u(i,j+1)+u(i,j-1)+u(i+1,j)+u(i-1,j))/4);            
        end
    end
    
    for i = 2:20
        for j = 2:20
            u_beta(i,j) = ((pi*tow0/(gam*rho*Y0)*sin(pi*x(i)/Y0)*((dx1^2)/4))...
                +(u_beta(i,j+1)+u_beta(i,j-1)+u_beta(i+1,j)+u_beta(i-1,j))/4)+...
                ( (beta*dx1*(u_beta(i,j+1)-u_beta(i,j-1)))/(8*gam) ); 
            
        end
    end
    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    n = n+1;
end

           % u(i,j)=(u(i,j+1)+u(i,j-1)+u(i+1,j)+u(i-1,j)/4-(pi*tow0*...
           %sin(pi*j/y(i))*(dx1^2))/4);

