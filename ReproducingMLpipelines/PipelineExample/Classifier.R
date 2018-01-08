# Paper 1
## Helper function 
get_p = function(train_d, train_r){
    tr_m_aml =  colMeans(train_d[train_r == "AML",])
    tr_sd_aml = apply(train_d[train_r == "AML",], 2, sd)
    tr_m_all = colMeans(train_d[train_r == "ALL",])
    tr_sd_all = apply(train_d[train_r == "ALL",], 2, sd)
    p = (tr_m_aml-tr_m_all)/(tr_sd_aml+tr_sd_all)
    return(p)
}
classifier1 = function(train_p, train_r, test_p, test_r){
    "carry out classification as in Paper 1; 
     output is called Rates1 and is the value in row 1, column_i 
     call this function 6 times using every TransformedData_i as input in turn to get a 1x6 output for row 1"
    train_m_aml = colMeans(train_p[train_r == "AML",])
    train_m_all = colMeans(train_p[train_r =="ALL",])
    b = (train_m_aml+train_m_all)/2
    p = get_p(train_p, train_r)
    #train
    train_vote = t(p*t(sweep(train_p, 2, b)))
    train_V1 = apply(train_vote, 1, function(x) sum(x[x>0]))
    train_V2 = abs(apply(train_vote, 1, function(x) sum(x[x<=0])))
    train_pred = (train_V1-train_V2)/(train_V1+train_V2)
    train_pred_r = ifelse(abs(train_pred)>0.3, ifelse(train_pred>0, "AML", "ALL"), "Uncertain")
    train_table = table(Train_Predict = train_pred_r, Train_Actual = train_r)
    ##train_table
    #test
    test_vote = t(p*t(sweep(test_p, 2, b)))
    test_V1 = apply(test_vote, 1, function(x) sum(x[x>0]))
    test_V2 = abs(apply(test_vote, 1, function(x) sum(x[x<=0])))
    test_pred = (test_V1-test_V2)/(test_V1+test_V2)
    test_pred_r = ifelse(abs(test_pred)>0.3, ifelse(test_pred>0, "AML", "ALL"), "Uncertain")
    test_table = table(Test_Predict = test_pred_r, Test_Actual = test_r)
    ##test accuracy rate
    return(list(train = train_table, test = test_table))
}

