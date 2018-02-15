# Example

This is an example (using paper1) for running the pipeline using reproducible 
[containers](https://opensource.com/resources/what-are-linux-containers). The original code is in the [source folder](src), and these files have been organized into modular applications using a [Scientific Fileystem](https://sci-f.github.io) that has been installed into the containers. The entry points to the containers serve to provide the steps in a modular fashion, and we describe in detail usage below for the container technologies [Singularity](http://singularity.lbl.gov) and [Docker](https://docs.docker.com/get-started/). The steps include preprocessing and feature selection ("PPFS") and  classification ("classifier,") that together form a simple machine learning algorithm pipeline.

## Quick Start
If you don't feel like reading tutorials, here are the commands to run everything for each
of Docker and Singularity.

```
# [docker]
$ docker run vanessa/aim-ml run pipeline

# [singularity]
$ singularity pull --name aim-ml shub://vsoch/AIM-Manuscript

# Without any arguments, is akin to running ./aim-ml run pipeline
$ ./aim-ml

[pipeline] executing /bin/bash /scif/apps/pipeline/scif/runscript
starting [preprocess]...
     preprocessed data --> /tmp/PPFS_databc4ebe0b.rda
starting [classify]...
Reading in testing and training from /tmp/PPFS_databc4ebe0b.rda
             Train_Actual
Train_Predict ALL AML
    ALL        26   0
    AML         0  11
    Uncertain   1   0
            Test_Actual
Test_Predict ALL AML
   ALL        19   0
   AML         0  12
   Uncertain   1   2
```

For detailed walkthroughs of (optionally) building, running, and interacting with
the image, continue reading.

## The Scientific Filesystem Recipe
Whether we are installing these applications as modules onto your host *or* a container,
we can do this easily using a [Scientific Fileystem (SCIF)](https://sci-f.github.io). SCIF is nothing more than a filesystem organization, and a set of environment variables and functions that make it easy to discover your work. The core of SCIF is a simple recipe file, and we have [written one here](https://github.com/vsoch/AIM-Manuscript/blob/master/ReproducingMLpipelines/PipelineExample/aim-ml.scif) to define each of the steps in "preprocess" and "classify".


## Singularity
Singularity is a container technology that is friendly to run on a shared resource. If 
you are a researcher, and aren't running this on your local machine, you likely will want
to use a Singularity image. If you aren't familiar with Singularity, read about it [here](http://singularity.lbl.gov) and [install it](http://singularity.lbl.gov/install-linux). We will build our image from the included [Singularity](https://github.com/vsoch/AIM-Manuscript/blob/master/ReproducingMLpipelines/PipelineExample/Singularity) recipe, which uses the same Scientific Filesystem as the Dockerfile, and the same base image on [Docker Hub](https://hub.docker.com/r/vanessa/aim-manuscript/). The container is available on Singularity Hub, and can be pulled first instead of a build.

[![https://www.singularity-hub.org/static/img/hosted-singularity--hub-%23e32929.svg](https://www.singularity-hub.org/static/img/hosted-singularity--hub-%23e32929.svg)](https://singularity-hub.org/collections/602)

```
# Pull the container...
$ singularity pull --name aim-ml shub://vsoch/AIM-Manuscript

# or build the container
sudo singularity build aim-ml Singularity
```

What applications are installed?

```
$ ./aim-ml apps
  pipeline
preprocess
  classify
```

We can inspect any particular application:

```
$ ./aim-ml inspect
$ ./aim-ml inspect pipeline
```

or just ask for help:

```
$ ./aim-ml help pipeline
```

To be brief, we can run the entire pipeline without thinking about the individual modules with the included application `pipeline`. This will use the [included data](src/GolubData.rda) and save it to a temporary file, and that temporary file will be passed on to the final classification step:

```
$ ./aim-ml run pipeline
```

Here is what it looks like to run an individual step. In the example below, we do the "preprocess" step to output a file to tmp. Singularity has the advantage over Docker here because it will automatically map the /tmp directory to your machine (Docker doesn't).

```
# Preprocess
$ ./aim-ml run preprocess
[preprocess] executing /bin/bash /scif/apps/preprocess/scif/runscript
/tmp/PPFS_data836fc2f45.rda
```

The steps "preprocess" and "classify" are both combined to run together (inside the container) using "pipeline."


### Interaction with the Container
The previous commands, although run externally to the container, can also be run from an interactive shell inside the container. You can shell into the container as follows:

```
$ ./aim-ml shell

# or in context of an application
$ ./aim-ml shell preprocess
```

See the section after Docker, discussed next, for interaction with the SCIF (it's the same for both containers once you shell inside.


## Docker
If you aren't familiar with Docker, read about it [here](https://docs.docker.com/get-started/). First we will build our image from the included [Dockerfile](https://github.com/vsoch/AIM-Manuscript/blob/master/ReproducingMLpipelines/PipelineExample/Dockerfile), and it's [base](https://github.com/vsoch/AIM-Manuscript/blob/master/ReproducingMLpipelines/PipelineExample/Dockerfile.base). You can choose to skip these steps as we provide the images on [Docker Hub](https://hub.docker.com/r/vanessa/aim-manuscript/).

```
# Build the base and the image that uses it
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
        "apphelp": [
            "    You can run the entire pipeline as the creators intended, using the",
            "    provided input data (no arguments) or a custom data file (one .Rda file).",
            "    Keep in mind that if you use your own data file, with  Docker you need to",
            "    make sure it's location is mapped to the conainer.",
            "    [docker]",
            "    docker run vanessa/aim-ml run pipeline"
        ],
        "apprun": [
            "    echo \"Starting [preprocess]...\"",
            "    PPFS_DATA=$(scif --quiet run preprocess)",
            "    echo \"[preprocessed data]:${PPFS_DATA}\"",
            "    echo \"Starting [classify]...\"",
            "    scif --quiet run classify ${PPFS_DATA}"
        ]
    }
}
```

or just ask for help:

```
$ docker run vanessa/aim-ml help pipeline
    You can run the entire pipeline as the creators intended, using the
    provided input data (no arguments) or a custom data file (one .Rda file).
    Keep in mind that if you use your own data file, with  Docker you need to
    make sure it's location is mapped to the conainer.
    [docker]
    docker run vanessa/aim-ml run pipeline
```

To be brief, we can run the entire pipeline without thinking about the individual modules with the included application `pipeline`. This will use the [included data](src/GolubData.rda) and save it to a temporary file, and that temporary file will be passed on to the final classification step:

```
$ docker run vanessa/aim-ml run pipeline
```

Here is what it looks like to run an individual step. In the example below, we do the "preprocess" step to output a file to tmp. Note that if you want to save the output, you would need to map it as a volume to the container.

```
# Preprocess
$ docker run vanessa/aim-ml run preprocess
[preprocess] executing /bin/bash /scif/apps/preprocess/scif/runscript
/tmp/PPFS_data836fc2f45.rda
```

The steps "preprocess" and "classify" are both combined to run together (inside the container) using "pipeline."


## Interaction with the Container
Whether you use Doker or Singularity, it's useful to be able to shell inside to debug
and test. For Docker, you can shell into the container by defining an "interactive terminal" with an entrypoint as `/bin/bash`:

```
$ docker run -it --entrypoint /bin/bash  vanessa/aim-ml
```

And for Singularity, it's a bit simple (and you can rest assured /tmp and your `$HOME` 
are automatically bound).

```
$ ./aim-ml shell

# or in context of an application
$ ./aim-ml shell preprocess
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
            "    default. If you run the application module alone, you can specify your own.",
            "    Here is a simple running command. You can specify the output file as the",
            "    first argument, and you would need to map it to the container to retrieve",
            "    it. Note that by default, the output Rda file is written to /tmp in the",
            "    container.",
            "    [docker]",
            "    docker run vanessa/aim-ml run preprocess    "
        ],
        "appfiles": [
            "/src/GolubData.rda"
        ],
        "appinstall": [
            "    cp /src/PPFS.R bin/",
            "    cp /src/run_preprocess.R bin/"
        ],
        "appenv": [
            "PPFS_DATA=\"${SCIF_APPROOT}/GolubData.rda\"",
            "export PPFS_DATA"
        ],
        "apprun": [
            "PPFS_DATA=\"${SCIF_APPROOT}/GolubData.rda\"",
            "export PPFS_DATA",
            "    if [ $# -eq 0 ]",
            "        then",
            "        Rscript ${SCIF_APPBIN}/run_preprocess.R \"${PPFS_DATA}\"",
            "    else",
            "        Rscript ${SCIF_APPBIN}/run_preprocess.R \"$@\"",
            "    fi"
        ]
    }
}
```

We can run a step:

```
$ scif run preprocess
$ scif --quiet run preprocess  # suppress additional output

/tmp/PPFS_data95ef71b08.rda
```

Then run the classify step:

```
$ scif run classify /tmp/PPFS_data95ef71b08.rda
/tmp/PPFS_data15558b60a0.rda[classify] executing /bin/bash /scif/apps/classify/scif/runscript /tmp/PPFS_data95ef71b08.rda
Reading in testing and training from /tmp/PPFS_data95ef71b08.rda
             Train_Actual
Train_Predict ALL AML
    ALL        26   0
    AML         0  11
    Uncertain   1   0
            Test_Actual
Test_Predict ALL AML
   ALL        19   0
   AML         0  12
   Uncertain   1   2
```

That's it! Please [post an issue](https://github.com/AIM-project/AIM-Manuscript) if you have any questions.
