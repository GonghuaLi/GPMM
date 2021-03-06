function flag = multi_threading_mcmc
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  SGMM: Semi-kinetic Genome-wide metaoblic modeling
%  Written By Gonghua Li  Ph.D.
%  Kunming Institute of Zoology, Chinese Academy of Sciences
%  Email: ligonghua@mail.kiz.ac.cn
%  Version 2019-09-30
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
pars = parse_parsfile('pars.txt');
%%
numCPU = pars.numCPU;
load('./data/lb_ub_for_PQMM.mat');

%%
N_sample = size(lb,2);
N_block = floor(N_sample/numCPU);
if N_block < 1
    warning('Number of CPU > Number of sample. One threading was used.\n');
    copyfile('./bin/mcmc_PQMM.m','temp_mcmc_PQMM.m');
    system('matlab -nodesktop -nojvm -r temp_mcmc_PQMM &');
    %delete('temp_mcmc_PQMM.m');
    flag = 1;
    return;
end
%% write scrips
s = file2cell('./bin/mcmc_PQMM.m','\n');
for i  = 1:numCPU
    a = (i-1)*N_block +1;
    if i < numCPU 
        b = i*N_block;
    else
        b = N_sample;
    end
    outS = s;
    for j  = 1:length(outS)
        if regexp(outS{j},'for\s+i\s+=')
            outS{j} = ['for i = ',num2str(a),':',num2str(b)];
        end
    end
    writetxt(outS,['temp_mcmc_PQMM',num2str(i),'.m'],'\n');
    system(['matlab -nodesktop -nojvm -r temp_mcmc_PQMM',num2str(i),' &'])
     pause(1)
    %delete(['temp_mcmc_PQMM',num2str(i),'.m']);
end
flag = numCPU;

    




    