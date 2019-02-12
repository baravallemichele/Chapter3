K1=1.2*10^-4
log(1/K1)

myfun=@(pp) (-dPf_dp( pp,2,15,.30,.45 )-K1)^2;

options = optimset('Display','notify','TolFun',1e-6,'TolX',1e-6);

p_acc=fminsearch(myfun,2,options);

Pf_acc=form_ferum( p_acc,2,15,.30,.45 );

-norminv(Pf_acc)


Optimal_Pf( 10^8,10^5,5.8*10^8,10^5,0.02,0.01,1,2,15,.3,.45 )
norminv(ans(1))