addpath('./bin');
Reduce_recon3('pars.txt');
get_lb_ub_rxns_by_PQM_from_matrix('pars.txt');
recon_PQMM;
%recon_PQMM_multi;
%recon_PQMM_gimme;
multi_threading_mcmc;
%multi_threading_mcmc_mkl;


