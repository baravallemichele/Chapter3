clear all

name_distrR=['Norm'
             'Logn'
             'Weib'];
name_distrS=['Norm'
             'Logn'
             'Gumb'];

distributionR=[1 2 16]
distributionS=[1 2 15]
for i_dR=1:3
    for i_dS=1:3
        figure('Name',strcat('R_',name_distrR(i_dR,:),',___S_',name_distrS(i_dS,:)))
        distrR=distributionR(i_dR)
        distrS=distributionS(i_dS)
        MAIN_Create_plots_for_optimal_relaibility_run_several_2
        savefig(strcat('R_',name_distrR(i_dR,:),',___S_',name_distrS(i_dS,:)));
    end
end