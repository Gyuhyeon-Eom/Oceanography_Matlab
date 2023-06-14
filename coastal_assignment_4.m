T = input('input the period [s] :');
h_max = input('input the max depth[m] :');
h = 1:h_max;
g = 9.81;
vel_dw = g*T/(2*pi);
vel_sw = sqrt(g*h);

dh = h';
m=1;

        for i=1:h_max
                    con = 1;
                        l(con) = 0;
                    l(con+1) = 1.56 * T ^ 2; 
                    
                    while abs( l(con+1) - l(con) ) > 0.0001 
                                l(con+2) = ( ( 9.81 * T ^ 2 ) / ( 2 * pi ) ) * tanh( ( 2 * pi * h(i) ) / l(con+1) );
                                con = con + 1;
                    end
                    
                    L(i) =  l(con);
                    k = ( 2 * pi ) / L(i);
        end
        
Ls{1,m} = L';   

for i = 1:length(h)
    if h(i)/L(i) > 0.5
        vel(i) = vel_dw;

    else
        vel(i) = vel_sw(i);
    end
    i = i+1;
end

figure;
plot(h,vel,'Color','red'); hold on;
plot(h,vel_sw, 'Color','b')
ax = gca;
ax.XLim = [1 h_max];
ax.YLim = [0 200];
ax.XLabel.String = 'Water depth (m)';
ax.YLabel.String = 'Wave speed (m/s)';
legend('Vel','Vel_ sw','Location','eastoutside');
ld = h./L;

ldq = find(ld <= 0.05);
fprintf('Shallow water로 간주되는 최소 파장 : %5.3f m \r\n',L(1));

filename = 'Figure2';
saveas(gcf, filename);




% Referents:
%              Darlymple, R.G. and Dean R.A. (1999). Water Wave Mechanics
%              for Engineers and Scientist. World Scientific.
%              Singapure.
%              Fenton,J.D and Mckee,W.D.(1990). On calculating the lengths
%              of water waves. Coastal Engineering 14, 499-513p.
%              Gabriel Ruiz Martinez 2006.