FROM vanessa/aim-ml:base

##############################################
# docker build -t vanessa/aim-ml .
##############################################

ADD src/ /src/

##############################################
# Install Scientific Filesystem Recipe
##############################################

ADD aim-ml.scif /aim-ml.scif
RUN pip3 install scif
RUN scif install /aim-ml.scif

ENV PATH /usr/local/bin:$PATH
ENTRYPOINT ["/usr/local/bin/scif"]
