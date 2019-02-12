function [ output ] = dPf_dp( p,distrR,distrS,VR,VS )
%Input:
%     C0,CI,H = fixed construction, marginal construction and failure costs
%     omega = obsolescence rate
%     gamma = interest rate
%     lambda = poisson process rate
%     distrS,R = S and R distriubtion type (1=Normla;2=Lognormal;15=Gumbel)
%     VR,VS = coefficients of variation
%Output:
%     output(1)=derivative of Pf wrt p
    dp=0.001;
    p_up=p+dp;
    p_low=p-dp;
    Pf_up=form_ferum( p_up,distrR,distrS,VR,VS );
    Pf_low=form_ferum( p_low,distrR,distrS,VR,VS );
    output=(Pf_up-Pf_low)/(2*dp);
end