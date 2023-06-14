h = 1:1:100;
g = 9.81;
T = 3;
dh = h';
m=1;
fg =figure('Menubar', 'none', 'Name', 'Wavelength vs Period and Depth', 'NumberTitle', 'off',...
                'Color' , 'w');

    while T ~= 15

        for i=1:100
                    con = 1;
                        l(con) = 0;
                    l(con+1) = 1.56 * T ^ 2; 
                    
                    while abs( l(con+1) - l(con) ) > 0.0001, 
                                l(con+2) = ( ( 9.81 * T ^ 2 ) / ( 2 * pi ) ) * tanh( ( 2 * pi * h(i) ) / l(con+1) );
                                con = con + 1;
                    end
                    
                    L(i) =  l(con);
                    k = ( 2 * pi ) / L(i);
        end
        
        Ls{1,m} = L';   
            hold on;
                fgh =plot(dh,Ls{1,m});
                    xlabel('Water Depth (h), meters', 'FontSize',15);
                        ylabel('Wave Length (L), meters','FontSize',15);
                    xlim( [ 1 100 ] )
                set(fgh,'Color',rand(1,3));
            set(gca,'Box','on');
        drt = title('Wavelength vs Period and Depth', 'HorizontalAlignment' , 'center' , 'FontWeight', 'bold');
            set(gca, 'XGrid', 'off', 'XMinorTick', 'on' , 'YGrid' , 'off' , 'YMinorTick' , 'on', 'Fontsize', 8 );
                m = m+1;
                    T = 1+T;
    end
    T= 3:1:15;
        hj =length(T);
        textos2 = 'T = ';
    
    for i = 1 : hj
            stringer{i,1} = num2str(T(1,i));
            textos{i,1} = horzcat(textos2,stringer{i,1},' s');
    end
        asdk = legend(textos, 'Location', 'EastOutside');
            set(asdk, 'FontSize', 10);
               
%{    
txt = {'주기가 커질수록 수심에 따른파장의 변화가 커진다.'};
text(4,300,txt)
%}
    %주기가 커질수록 수심에 따른 파장의 변화가 커진다.
  
% 5. Referents:
%      Darlymple, R.G. and Dean R.A. (1999). Water Wave Mechanics
%              for Engineers and Scientist. Advanced Series on Ocean Engineering, Vol. 2
%              World Scientific. Singapure.
%      Le Mehuate, Bernard. (1976). An introduction to hidrodynamics and water waves. 
%              Springer-Verlag. USA.

