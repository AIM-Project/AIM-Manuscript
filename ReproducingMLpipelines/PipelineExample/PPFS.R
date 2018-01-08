load("GolubData.rda")
set.seed(2017)

# Paper 1
## Helper Functions
golub_filter = function(x, r = 5, d=500){
    minval = min(x)
    maxval = max(x)
    (maxval/minval>r)&&(maxval-minval>d)
}
## Neighbourhood analysis
### signal-to-noise ratio/PS in the paper
get_p = function(train_d, train_r){
    tr_m_aml =  colMeans(train_d[train_r == "AML",])
    tr_sd_aml = apply(train_d[train_r == "AML",], 2, sd)
    tr_m_all = colMeans(train_d[train_r == "ALL",])
    tr_sd_all = apply(train_d[train_r == "ALL",], 2, sd)
    p = (tr_m_aml-tr_m_all)/(tr_sd_aml+tr_sd_all)
    return(p)
}
PPFS1 = function(golub_train_predict, golub_train_response, golub_test_predict, golub_test_response){
    "carry out preprocessing on original Golub data and apply feature selection as both were done in Paper 1; 
     output is called TransformedData1"
    # Preprocessing
    ## Thresholding
    golub_train_pp = golub_train_predict
    golub_train_pp[golub_train_pp<100] = 100
    golub_train_pp[golub_train_pp>16000] = 16000

    ## Filtering
    index = apply(golub_train_pp, 2, golub_filter)
    golub_index = (1:7129)[index]
    golub_train_pp = golub_train_pp[, golub_index]

    golub_test_pp = golub_test_predict
    golub_test_pp[golub_test_pp<100] = 100
    golub_test_pp[golub_test_pp>16000] = 16000
    golub_test_pp = golub_test_pp[, golub_index]

    ## Log Transformation
    golub_train_p_trans = log10(golub_train_pp)
    golub_test_p_trans = log10(golub_test_pp)

    ## Normalization
    train_m = colMeans(golub_train_p_trans)
    train_sd = apply(golub_train_p_trans, 2, sd)
    golub_train_p_trans = t((t(golub_train_p_trans)-train_m)/train_sd)
    golub_test_p_trans  = t((t(golub_test_p_trans)-train_m)/train_sd)
    golub_train_3051 = golub_train_p_trans
    golub_test_3051 = golub_test_p_trans
    
    # Feature Selection
    nna = matrix(0, 400, 3051)
    set.seed(201702)
    ## Permutation test
    for(i in 1:400){
        t_r = sample(golub_train_response)
        nna[i, ] = get_p(golub_train_p_trans, t_r)
    }
    
    ## Predictor selection based on the result of Neighbourhood analysis
    nna_q = apply(nna, 2, quantile, prob = c(0.005, 0.995))
    p = get_p(golub_train_p_trans, golub_train_response)
    
    ## Keep the one with 0.01 significant level
    index_1 = (1:3051)[p>=nna_q[2,] | p<=nna_q[1,]]
    golub_train_p_trans = golub_train_p_trans[, index_1]
    train_m_aml = colMeans(golub_train_p_trans[golub_train_response == "AML",])
    train_m_all = colMeans(golub_train_p_trans[golub_train_response =="ALL",])
    golub_test_p_trans =golub_test_p_trans[, index_1]
    p = p[index_1]
    
    ## 50 most informative genes
    cl_index = c(head(order(p), 25), head(order(p, decreasing = T), 25))
    p_50 = p[cl_index]
    b = (train_m_aml[cl_index]+train_m_all[cl_index])/2
    train_cl = golub_train_p_trans[, cl_index]
    test_cl = golub_test_p_trans[, cl_index]
    golub_train_50 = train_cl
    golub_test_50 = test_cl
    train_vote = t(p_50*t(sweep(train_cl, 2, b)))
    TransformedData1 = list(train_predict = golub_train_50, test_predict = golub_test_50, train_response = golub_train_response, test_response = golub_test_response)
    return(TransformedData1)
}