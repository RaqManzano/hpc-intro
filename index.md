---
title: "Working on HPC Clusters using SLURM"
date: today
number-sections: false
---

## Overview 

Knowing how to work on a **High Performance Computing (HPC)** system is an essential skill for applications such as bioinformatics, big-data analysis, image processing, machine learning, parallelising tasks, and other high-throughput applications. 

These materials give a brief practical overview of working on HPC servers, with a particular focus on submitting and monitoring jobs using a job scheduling software. 
We focus on the job scheduler SLURM, although the concepts covered are applicable to other commonly used job scheduling software. 

These materials are a reduced version of the University of Cambridge Bioinformatics Training Unit HPC workshop. The complete set of materials can be found [here](https://github.com/cambiotraining/hpc-intro).


:::{.callout-tip}
#### Learning Objectives

- Describe how a HPC cluster is typically organised and how it differs from a regular computer.
- Recognise the tasks that a HPC cluster is suitable for. 
- Access and work on a HPC server.
- Submit and manage jobs running on a HPC.
:::


## Prerequisites

We assume some knowledge of the Unix command line. 
If you don't feel comfortable with the command line, we recommend [Introduction to the Unix Command Line](https://training.csx.cam.ac.uk/bioinformatics/course/bioinfo-unix2) course from the Bioinformatics Training Facility at the University of Cambridge.

Namely, we expect you to be familiar with the following:

- Navigate the filesystem: `pwd` (where am I?), `ls` (what's in here?), `cd` (how do I get there?)
- Investigate file content using utilities such as: `head`/`tail`, `less`, `cat`/`zcat`, `grep`
- Using "flags" to modify a program's behaviour, for example: `ls -l`
- Redirect output with `>`, for example: `echo "Hello world" > some_file.txt`
- Use the pipe `|` to chain several commands together, for example `ls | wc -l`
- Execute shell scripts with `bash some_script.sh`


## Authors

Please cite these materials if:

- You adapted or used any of them in your own teaching.
- These materials were useful for your research work. For example, you can cite us in the methods section of your paper: "We carried our analyses based on the recommendations in _YourReferenceHere_".

<!-- 
This is generated automatically from the CITATION.cff file. 
If you think you should be added as an author, please get in touch with us.
-->

{{< citation CITATION.cff >}}


## Acknowledgements

<!-- if there are no acknowledgements we can delete this section -->

- Thanks to Qi Wang (Department of Plant Sciences, University of Cambridge) for constructive feedback and ideas in the early iterations of this course.
- Thanks to [@Alylaxy](https://github.com/Alylaxy) for his pull requests to the repo ([#34](https://github.com/cambiotraining/hpc-intro/pull/34)).
- Thanks to the [HPC Carpentry](https://www.hpc-carpentry.org/index.html) community for developing similar content.
- Thanks to the [Bioinformatics Training Facility](https://www.gen.cam.ac.uk/facilities/bioinformatics-training) of the University of Cambridge for letting us adapt these materials.
