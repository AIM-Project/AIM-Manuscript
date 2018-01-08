# This repo contains supporting documents for the manuscript \"Defining the AIM: An Abstraction for Improving Machine Learning Prediction\"

## Project Description:
We present code, data, and supplementary figures and documents used in the preparation of the manuscript \"Defining the AIM: An Abstraction for Improving Machine Learning Prediction\". We illustrate the need for abstraction describing Machine Learning pipelines to facilitate the comparison, improvement, and study of ML results by focusing on the famous ALL/AML dataset \[[1](https://github.com/AIM-Project/AIM-Manuscript/blob/master/LiteratureSearch/Articles/paper1.pdf)\]. We define an abstraction layer for leaderboard style competitions to improve ML results. 

## Repo Folder Contents:
- LiteratureSearch\
This folder contains two notebooks, one giving the results of our literature analysis (LiteratureSearchResults.ipynb) and the other presenting ML pipelines for the articles (SummaryofMLpipelines.ipynb).
- ReproducingMLpipelines\
This folder contains 12 notebooks, 5 for each article we studied in depth, 5 for the comparison of the articles\' methods (Table 1 in the manuscript), and 2 for comparison summaries. We also included the intermediate .Rdata file we created in the folder.
## Data and Associated Repos:
- [Data in the Golub et al. paper](https://www.bioconductor.org/packages/devel/data/experiment/html/golubEsets.html)\[[1](https://github.com/AIM-Project/AIM-Manuscript/blob/master/LiteratureSearch/Articles/paper1.pdf)\]: The datasets used in \[[1](https://github.com/AIM-Project/AIM-Manuscript/blob/master/LiteratureSearch/Articles/paper1.pdf)\] with training dataset(38 by 7129) and testing dataset(34 by 7129).
- [Data Version 2](https://cran.r-project.org/web/packages/spikeslab): leukemia data in R package spikeslab(72 by 3571). We have shown that this data is a transformed data based on the original data.
- [Data Version 3](http://faculty.mssm.edu/gey01/multtest/): \'golub\' data in R package multtest. In which, \'golub\' is the training dataset (38 by 3051) and \'golub.cl\' is the test dataset (34 by 3051). We also have shown that this data is another transformed dataset based on the original data.
- We use the data in \[[1](https://github.com/AIM-Project/AIM-Manuscript/blob/master/LiteratureSearch/Articles/paper1.pdf)\] (also [here](https://www.bioconductor.org/packages/devel/data/experiment/html/golubEsets.html) and in the LiteratureSearch folder) to reproduce results in the papers.
- Associated Repos\
[Previous work](https://github.com/victoriastodden/ReproducibilityCancerResearch)

If you have any questions, please contact us vcs@stodden.net and xwu64@illinois.edu .
