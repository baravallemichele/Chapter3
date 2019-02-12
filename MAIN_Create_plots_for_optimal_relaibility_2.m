%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% This script creates the simplified plots for communicating target
% reliabilities
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Copyright (C) 2017 Michele Baravalle, NTNU
%
% This program is free software; you can redistribute it and/or modify
% it under the terms of the GNU General Public License as published by
% the Free Software Foundation; either version 3 of the License, or (at
% your option) any later version.

% This program is distributed in the hope that it will be useful, but
% WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
% General Public License for more details.

% You should have received a copy of the GNU General Public License
% along with this program; if not, write to the Free Software
% Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301, USA.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear all
clc
clf
%% INPUT %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Costs
    C0=1;       % Fixed construction costs
    A=0;        % Demolition costs
% Other input    
    omega=1/50; % Obsolescence rate
    gamma=0.02; % Yearly societal real interest rate
    lambda=1;   % Parameter of the Poisson process representing failures
% Random varaibles distributions    
    distrR=2;
    distrS=15; %Distribution type (1 = Normal;2 = Lognormal;3 = Gamma;4 = Shifted Exponential marginal distribution;  5 = Shifted Rayleigh marginal distribution; 6 = Uniform distribution; 7 = Beta; 8 = Chi-square; 11 = Type I Largest Value marginal distribution;12 = Type I Smallest Value marginal distribution                                                             %
                                      %13 = Type II Largest Value marginal distribution;14 = Type III Smallest Value marginal distribution ;15 = Gumbel (same as type I largest value) ;16 = Weibull marginal distribution (same as Type III Smallest Value marginal distribution with epsilon = 0 ) %
% Resolution for plots
    res=5;
% Colors and line styles    
    linestyle=['- ';'--';': ';'-.'];
    color=['k';'g';'b';'r'];    
    
%% SCRIPT %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%    
dum_H=[linspace(.1,9,2*res)]; %dummy varaibles representing the failure costs H
min1=999; max1=-999;min2=999; max2=-999; %Initialize dummy varaibles 
% for j=1:4
%     plot([0 0],[1e-4 1.1e-4],'Color','black','LineStyle',linestyle(j,:)); hold on;
% end % trick for having correct legend
i=1;ii=1;
for VR=[.05 .15 .30] % Values of the Resistance Coefficient of Variation
    j=1;
    for VS=[.10 .30 .45 .60] % Values of the load coeff. of variation
       % Find the optimal Pf and optimal design for different combinations of H and CI
            clear H CI
            [H,CI]=meshgrid(dum_H,[logspace(-5,0,res)]);
            for c_h=1:size(H,2)
                for r_ci=1:size(CI,1)
                    %Evalaute optimal Probability of failure and optimal design
                    dum=Optimal_Pf( C0,CI(r_ci,c_h),H(r_ci,c_h),A,omega,gamma,lambda,distrR,distrS,VR,VS );
                    Pf_opt(r_ci,c_h)=dum(1);                % Optimal Pf
                    beta_opt(r_ci,c_h)=-norminv(dum(1));    % Optimal rel. index
                    p_opt(r_ci,c_h)=dum(2);                 % Optimal design
                end
            end
            rho=((C0+CI.*p_opt+H)./(C0+CI.*p_opt));         % Ratio between total failure costs and construction costs
            min1=min(min1,min(min(log(((1+H)./(CI)))-log((C0+CI.*p_opt+H)./CI))));
            max1=max(max1,max(max(log(((1+H)./(CI)))-log((C0+CI.*p_opt+H)./CI))));
            min2=min(min2,min(min(log(((rho)./(CI)))-log((C0+CI.*p_opt+H)./CI))));
            max2=max(max2,max(max(log(((rho)./(CI)))-log((C0+CI.*p_opt+H)./CI))));
       % Plot ln([(C0+CI p_opt+H) * (i_plot+omega_plot) ] / [CI * (i+omega)] )  VS. beta_opt
            dum_log_rho_div_CI=[log(((C0+CI(1,:).*p_opt(1,:)+H(1,:))./C0)./(CI(1,:)./C0.*(omega+gamma)))];
            dum_Pfopt=[Pf_opt(1,:)];
            for k=2:res
               dum_log_rho_div_CI=[dum_log_rho_div_CI log(((C0+CI(k,:).*p_opt(k,:)+H(k,:))./C0)./(CI(k,:)./C0.*(omega+gamma)))];
               dum_Pfopt=[dum_Pfopt Pf_opt(k,:)];
            end
            dum5=[dum_log_rho_div_CI;-norminv(dum_Pfopt)]';
            dum5=sortrows(dum5);
            plot(dum5(:,1),dum5(:,2),color(i,:),'LineStyle',linestyle(j,:)) 
            hold on; 
            axis([3 14 3 6])
            legendInfo{4*(i-1)+j} = [strcat('V_R=',num2str(VR),', V_S=',num2str(VS))];
            j=j+1;
            drawnow
        jj=1;
%         for K1=[1e-5 1e-4 1e-3 1e-2]
%         % Find acceptance limit
%             myfun=@(pp) (-dPf_dp( pp,distrR,distrS,VR,VS )-K1)^2;
%             options = optimset('Display','iter','TolFun',1e-6,'TolX',1e-6);
%             p_acc(jj)=fminsearch(myfun,2,options);
%             Pf_acc(jj)=form_ferum( p_acc(jj),distrR,distrS,VR,VS );
%             beta_acc(jj)=-norminv(Pf_acc(jj));
%             %plot acceptance limit in the plot
%                 x(ii,jj)=spline(dum5(:,2),dum5(:,1),beta_acc(jj));
%                 y(ii,jj)=beta_acc(jj);
%                 %plot(x(i,jj),y(i,jj),'o')
%             jj=jj+1 ; 
%         end
        ii=ii+1;
    end
    i=i+1;
end
% plot([8.98 8.98 3],[3 4.45 4.45],'-om'); 
% plot([7.67 7.67 3],[3 4.18 4.18],'-oc'); 
% K1=[1e-5 1e-4 1e-3 1e-2]
% for jj=1:4
%     text(max(x(:,jj)),min(y(:,jj))-0.1,strcat('K_1=',num2str(K1(jj))))
%     dum3=[x(:,jj),y(:,jj)]; dum3=sortrows(dum3,2);
%     plot(dum3(:,1),dum3(:,2),'-r','LineWidth',2)            
% end

hold on
grid minor
%legendInfo{13}=['Example 1'];legendInfo{14}=['Example 2'];
legendInfo{13}=['Accept. domain lower bound'];
legend(legendInfo,'Location','eastoutside')
legend('boxoff')
name_distrR=['Norm';'Logn';'Gamm';'Expo';'Rayl';'Unif';'Beta';'ChiS';'    ';'    ';'TILV';'TISV';'TIIL';'TIII';'Gumb';'Weib'];
name_distrS=['Norm';'Logn';'Gamm';'Expo';'Rayl';'Unif';'Beta';'ChiS';'    ';'    ';'TILV';'TISV';'TIIL';'TIII';'Gumb';'Weib'];
title(strcat('R ~ ',name_distrR(distrR,:),'(\mu_R=1.0; \sigma_R=V_R); S ~ ',name_distrS(distrS,:),'(\mu_S=1.0; \sigma_S=V_S); C_0 = 1MU'))
og=omega+gamma; %Omega + gamma used for deriving the plot
xlabel(strcat('ln([(C_0+C_I p_o_p_t+H) / [C_I \cdot ({i^{(1a)}+\omega})] )  \cong ln([(C_0+H) / [C_I \cdot ({i^{(1a)}+\omega})] )'));
ylabel('\beta_{opt}^{(1a )}')
savefig(strcat('R_',num2str(distrR),',___S_',num2str(distrS)));
    
