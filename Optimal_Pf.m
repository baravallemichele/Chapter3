function [ output ] = Optimal_Pf( C0,CI,H,A,omega,gamma,lambda,distrR,distrS,VR,VS )
%Input:
%     C0,CI,H = fixed construction, marginal construction and failure costs
%     omega = obsolescence rate
%     gamma = interest rate
%     lambda = poisson process rate
%     distrS,R = S and R distriubtion type (1=Normla;2=Lognormal;15=Gumbel)
%     VR,VS = coefficients of variation
%Output:
%     output(1)=Pf_opt
%     output(2)=p_opt
%Total expected costs
    ECtot=@(p) (C0+CI.*p)+((C0+CI.*p+A).*omega./gamma)+((C0+CI.*p+H).*lambda.*form_ferum( p,distrR,distrS,VR,VS )./gamma);
% Simplex method
    options = optimset('Display','iter','TolFun',1e-6,'TolX',1e-6);
    [p_opt]=fminsearch(ECtot,3,options);
    Pf_opt=form_ferum( p_opt,distrR,distrS,VR,VS );
    output=[Pf_opt,p_opt];
end