---
pagetitle: "HPC SLURM"
---

# HPC Introduction

:::{.callout-tip}
#### Learning Objectives

- Describe how a typical HPC is organised: _nodes_, _job scheduler_ and _filesystem_.
- Distinguish the roles of a _login node_ and a _compute node_.
- Describe the role of a _job scheduler_.
- Recognise the differences between "scratch" and "home" storage and when each should be used.
:::

## What is a HPC and what are its uses?

HPC stands for **High-Performance Computing** and refers to the use of powerful computers and programming techniques to solve computationally-intensive tasks. 
Very often, several of these high-performance computers are connected together in a network and work as a unified system, forming a **HPC cluster**. The main usage of HPC clusters is to run resource-intensive and/or parallel tasks.
For example: running thousands of simulations, each one taking several hours; assembling a genome from sequencing data, which requires computations on large volumes of data in memory. 

HPC clusters typically consist of numerous **nodes** (computers) connected through a high-speed network, and they are used to distribute and parallelise tasks.

There are two types of nodes:

- _login_ nodes (also known as _head_ or _submit_ nodes). This is where a user connects and interacts with the cluster/HPC (e.g. navigating the filesystem, download files, make small edits to files).
- _compute_ nodes (also known as _worker_ nodes). These are the machines that will actually do the hard work of running jobs. These have higher RAM/CPU capacity, suitable for computationally demanding tasks.

Users do not have direct access to the _compute nodes_ and instead submitting jobs via a _job scheduler_. A job scheduler is a software used to submit commands to be run on the compute nodes (orange box in @fig-hpc_overview).
This is needed because there may often be thousands of processes that all the users of the HPC want to run at any one time. 
The job scheduler's role is to manage all these jobs, so you don't have to worry about it.

When working on a HPC it is important to understand what kinds of _resources_ are available to us in the _compute_ nodes. The user can request specific resources to run their job (e.g. number of cores, RAM, how much time we want to reserve the compute node to run our job, etc.). The more accurate the user request is, the more appropriately the job will be assigned in the queue of the scheduler.

These are the main resources we need to consider:

- **CPU** (central processing units) is the "brain" of the computer, performing a wide range of operations and calculations. 
CPUs can have several "cores", which means they can run tasks in parallel, increasing the throughput of calculations per second. 
A typical personal computer may have a CPU with 4-8 cores. 
A single compute node on the HPC may have 32-48 cores (and often these are faster than the CPU on our computers).
- **RAM** (random access memory) is a quick access storage where data is temporarily held while being processed by the CPU. 
A typical personal computer may have 8-32Gb of RAM. 
A single compute nodes on a HPC may often have >100Gb RAM.
- **GPUs** (graphical processing units) are similar to CPUs, but are more specialised in the type of operations they can do. While less flexible than CPUs, each GPU can do thousands of calculations in parallel. 
This makes them extremely well suited for graphical tasks, but also more generally for matrix computations and so are often used in machine learning applications. 

Usually, HPC servers are available to members of large institutions (such as a Universities or research institutes) or sometimes from cloud providers. 
This means that:

- There are many users, who may simultaneously be using the HPC. 
- Each user may want to run several jobs concurrently. 
- Often large volumes of data are being processed and there is a need for high-performance storage (allowing fast read-writting of files).

So, at any one time, across all the users, there might be many thousands of processes running on the HPC!

Figure 1 shows a schematic of a HPC, and we go into its details in the following sections. 

![Organisation of a typical HPC.](images/hpc_overview.svg){#fig-hpc_overview}

## Parallelisation

In terms of parallelising calculations, there are two ways to think about it, and which one we use depends on the specific application. 
Some software packages have been developed to internally parallelise their calculations (or you may write your own script that uses a parallel library).
These are very commonly used in bioinformatics applications, for example.
In this case we may want to submit a single job, requesting several CPU cores for it.

In other cases, we may have a program that does not parallelise its calculations, but we want to run many iterations of it.
A typical example is when we want to run simulations: each simulation only uses a single core, but we want to run thousands of them.
In this case we would want to submit each simulation as a separate job, but only request a single CPU core for each job.


## Filesystem

The filesystem on a HPC cluster often consists of storage partitions that are shared across all the nodes, including both the _login_ and _compute_ nodes (green box in Figure 1).
This means that data can be accessed from all the computers that compose the HPC cluster.

Although the filesystem organisation may differ depending on the institution, typical HPC servers often have two types of storage:

- The user's **home directory** (e.g. `/home/user`) is the default directory that one lands on when logging in to the HPC. This is often quite small and possibly backed up. The home directory can be used for storing things like configuration files or locally installed software.
- A **scratch space** (e.g. `/scratch/user`), which is high-performance, large-scale storage. This type of storage may be private to the user or shared with a group. It is usually not backed up, so the user needs to ensure that important data are stored elsewhere. This is the main partition were data is processed from. 


## Summary

:::{.callout-tip}
#### Key Points

- A HPC consists of several computers connected in a network. Each of these computers are called a **node**: 
- The **login nodes** are the machines that we connect to and from where we interact with the HPC. 
  These should not be used to run resource-intensive tasks.
- The **compute nodes** are the high-performance machines on which the actual heavy computations run. 
  Jobs are submitted to the compute nodes through a job scheduler.
- The **job scheduler** is used to submit scripts to be run on the compute nodes. 
  - The role of this software is to manage large numbers of jobs being submitted and prioritise them according to their resource needs. 
  - We can configure how our jobs are run by requesting the adequate resources (CPUs and RAM memory). 
  - Choosing resources appropriately helps to get our jobs the right level of priority in the queue.
- The filesystem on a HPC is often split between a small (backed) **home directory**, and a large and high-performance (non-backed) **scratch space**. 
  - The user's home is used for things like configuration files and local software instalation.
  - The scratch space is used for the data and analysis scripts. 
  - Not all HPC servers have this filesystem organisation - always check with your local HPC admin.
:::
