# AIM-Manuscript
## Project Description:
We started from answering the third question at beginning of Three Dream Applications of Verifiable Computational Results by Matan Gavish and David Donoho. Our reproduce work is based on the famous acute lymphoblastic leukemia dataset(Golub.) mentioned in the question. We looked trough about 25 papers using the dataset and select 5 to go in depth. We reproduced the work in those 5 paper in R and compare our result with the publish result. We also compared the result of mixing different steps in ML pipeline between different paper and checked the impact of each step in ML pipeline.
## Repo Folder Contents:
- Part1: Literature Analysis\
This folder contains two notebooks, one for the table to referencing related articles and the other one for summary of each article.
- Part2: Reproducing Classification Algorithms\
This folder contains 12 notebooks, 5 for each article we studied in depth(5/23), 5 for mix comparison between the articles selected and 2 for comparison summaries. We also included the intermediate .Rdata file we created in the folder.
- Part3: Related Articles\
This folder contains figures and text for the "CompareML" articles.
## Reference:
- Data:
- [Data in Golub. Paper](https://www.bioconductor.org/packages/devel/data/experiment/html/golubEsets.html):The datasets used in the Golub. Paper with training dataset(38 by 7129) and testing dataset(34 by 7129).
- [Data Version 2](https://cran.r-project.org/web/packages/spikeslab):`leukemia` data in R package spikeslab(72 by 3571). We have shown that this data is a transformed data based on the original data.
- [Data Version 3](http://faculty.mssm.edu/gey01/multtest/): `golub` data in R package multtest. In which, `golub` is the training dataset(38 by 3051) and `golub.cl` is the testing dataset(34 by 3051). We also have shown that this data is another transformed data based on the original data.
- We use the [Data in Golub. Paper](https://www.bioconductor.org/packages/devel/data/experiment/html/golubEsets.html) to reprocude most of the paper. However, if the reproduced paper is based on Data Version 2 or Data Version 3, we will use the corresponding data.
- Associated Repos\
[Previous work](https://github.com/victoriastodden/ReproducibilityCancerResearch)

If you have any questions, please contact us xwu64@illinois.edu or vcs@stodden.net.
