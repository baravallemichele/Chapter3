function [Pf] = form_ferum( p,distrR,distrS,VR,VS )
%form_ferum execute FORM by FERUM script for the limit state function
%g=p*R-S
%   inputs: 
%       p=central safety factor (p=meanR/meanS)
%   output:
%       distrR,distrS= distribution function type
%       VR,VS=coeff. of varaitions for R and S
    global probdata gfundata
    clear probdata femodel analysisopt gfundata randomfield systems results output_filename
    %define the limit state function and the random variables
    gfundata(1).expression = 'gfundata(1).thetag(1).*x(1)-x(2)';
    probdata.marg = [distrR, 1, VR,1-VR*1.6, nan, nan, nan, nan, 0;...
                     distrS, 1, VS,1+VS*1.6, nan, nan, nan, nan, 0];
    % Correlation matrix (square matrix with dimension equal to number of r.v.'s)
    probdata.correlation = eye(2); 
    % Determine the parameters,the mean and standard deviation associated with the distribution of each random variable
    probdata.parameter = distribution_parameter(probdata.marg);
    %Load options for fERUM
    LoadFerumOptions;
    for i=1:length(p)
        % define the limit state function
        gfundata(1).parameter = 'yes';
        gfundata(1).thetag = [p(i)];
        [formresults] = form(1,probdata,analysisopt,gfundata,femodel,randomfield);
        Pf(i)=formresults.pf1;
    end 
end

