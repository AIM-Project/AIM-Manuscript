# Example

This is an example (using paper1) for running the pipeline using reproducible 
[containers](https://opensource.com/resources/what-are-linux-containers). The original code is in the [source folder](src), and these files
have been organized into modular applications using a [Scientific Fileystem](https://sci-f.github.io) that has been installed into the containers. The entry points to the containers
serve to provide the steps in a modular fashion, and we describe in detail usage below for 
the container technologies [Singularity](http://singularity.lbl.gov) and [Docker](https://docs.docker.com/get-started/). The steps include preprocessing and feature selection ("PPFS") and  classification ("classifier,") that together form a simple machine learning algorithm pipeline.

## The Scientific Filesystem Recipe
Whether we are installing these applications as modules onto your host *or* a container,
we can do this easily using a [Scientific Fileystem (SCIF)](https://sci-f.github.io). SCIF is nothing more than a filesystem organization, and a set of environment variables and functions that make it easy to discover your work. The core of SCIF is a simple recipe file, and we have [written one here]() to define each of the steps in "preprocess" and "classify".

## Docker
If you aren't familiar with Docker, read about it [here](https://docs.docker.com/get-started/).
First we will build our image from the included [Dockerfile](Dockerfile), and it's [base](Dockerfile.base). You can choose to skip these steps as we provide the images on [Docker Hub]().

```
docker build -f Dockerfile.base -t vanessa/aim-ml:base .
docker build -t vanessa/aim-ml .
```

What applications did we install?

```
$ docker run vanessa/aim-ml apps
  pipeline
preprocess
  classify
```

We can inspect any particular application:

```
$ docker run vanessa/aim-ml inspect pipeline
{
    "pipeline": {
        "apprun": [
            "    PPFS_DATA=$(scif run preprocess)",
            "    scif run classify $PPFS_DATA    "
        ]
    }
}
```
To be brief, we can run the entire pipeline without thinking about the individual modules with the included application `pipeline`:

```

```

This would be the same as doing:

```
```

### Interaction with the Container
The previous commands, although run externally to the container, can also be run from an interactive shell inside the container. You can shell into the container by defining an "interactive terminal" with an entrypoint as `/bin/bash`:

```
$ docker run -it --entrypoint /bin/bash  vanessa/aim-ml
```

Once inside, we interact with the scientific filesystem via the `scif` client. This is what we are interacting with from the outside to - it serves as a single entrypoint that maps to many different entry points, one for each application (or step in our pipeline). In fact, the entire thing was installed with one command, and this is the command that can be run on
any host, container or not.

```
scif install /aim-ml.scif 
Installing base at /scif
+ apprun     preprocess
+ apphelp     preprocess
+ appfiles preprocess
+ apprun     classify
+ apphelp     classify
+ appfiles classify
+ apprun     pipeline
```

Note that you don't need to run the above - the step is done during the image build. What applications are installed?

```
$ scif apps
  pipeline
preprocess
  classify
```

Inspect all (or one) application:

```
scif inspect preprocess
{
    "preprocess": {
        "apphelp": [
            "This script will perform basic preprocessing, including cleaning and feature",
            "    selection for a dataset. If used without providing any input arguments,",
            "    the dataset that comes with the container (GolubData.rda) is used by ",
            "    default. If you run the application module alone, you can specify your own."
        ],
        "appinstall": [
            "    cp /src/GolubData.rda bin/",
            "    cp /src/PPFS.R bin/",
            "    cp /src/run_preprocess.R bin/"
        ],
        "apprun": [
            "    if [ $# -eq 0 ]",
            "        then",
            "        exec Rscript ${SCIF_APPBIN}/run_preprocess.R ${SCIF_APPROOT}",
            "    else",
            "        exec Rscript ${SCIF_APPBIN}/run_preprocess.R \"$@\"",
            "    fi"
        ]
    }
}
```

We can run a step:

```
```


We could also do this interactively in a shell (meaning the environment as we defined for a particular application is active).  For example, if I want to test to preprocess command above, I would do:

```
$ scif shell preprocess
$ echo $SCIF_APPBIN
/scif/apps/preprocess/bin
$ echo $SCIF_APPROOT
/scif/apps/preprocess
```



## Preprocessing anid Feature Selection(PPFS)
This notebook is for prerprocessing the data and do feature selection for building classifiers later.
## Classifier
This notebook is for building classifiers.
## GolubData
A R data file include all our data.
