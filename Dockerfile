FROM biocorecrg/centos-perlbrew-pyenv3-java:centos7


# File Author / Maintainer
MAINTAINER Toni Hermoso Pulido <toni.hermoso@crg.eu>
MAINTAINER Luca Cozzuto <lucacozzuto@gmail.com> 

ARG FASTQC_VERSION=0.11.8
ARG BOWTIE_VERSION=1.2.3
ARG SAMTOOLS_VERSION=1.9
ARG MACS_VERSION=2.2.4

#upgrading pip
RUN pip install --upgrade pip

#INSTALLING FASTQC
RUN bash -c 'curl -k -L https://www.bioinformatics.babraham.ac.uk/projects/fastqc/fastqc_v${FASTQC_VERSION}.zip > fastqc.zip'
RUN unzip fastqc.zip; chmod 775 FastQC/fastqc; ln -s $PWD/FastQC/fastqc /usr/local/bin/fastqc

#INSTALLING BOWTIE1
RUN bash -c 'curl -k -L https://sourceforge.net/projects/bowtie-bio/files/bowtie/${BOWTIE_VERSION}/bowtie-${BOWTIE_VERSION}-linux-x86_64.zip/download > bowtie.zip'
RUN unzip bowtie.zip; mv bowtie-${BOWTIE_VERSION}-linux-x86_64/bowtie* /usr/local/bin/

# Installing samtools
RUN yum install -y xz-devel.x86_64
RUN bash -c 'curl -k -L https://github.com/samtools/samtools/releases/download/${SAMTOOLS_VERSION}/samtools-${SAMTOOLS_VERSION}.tar.bz2 > samtools.tar.bz2' 
RUN tar -jvxf samtools.tar.bz2
RUN cd samtools-${SAMTOOLS_VERSION}; ./configure; make; make install; cd ../ 

# Installing MACS2
RUN git clone https://github.com/taoliu/MACS.git 
RUN cd MACS; git checkout release_v${MACS_VERSION}; 
RUN pip install --trusted-host pypi.python.org --upgrade pip && pip install --trusted-host pypi.python.org -r ./MACS/requirements.txt
RUN cd ./MACS && python setup.py install

#cleaning
RUN yum clean all
RUN rm -fr *.zip *.gz *.bz2 
