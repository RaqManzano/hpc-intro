---
pagetitle: "HPC SLURM"
---

# SLURM Scheduler

:::{.callout-tip}
#### Learning Objectives

- Describe the role of a job scheduler on a HPC cluster.
- Submit a simple job using SLURM and recognise where the output is saved to.
- Edit job submission scripts to request non-default resources.
- Use SLURM environment variables to customise scripts.
- Monitor the progress of a job using commands such as `squeue`, `seff` and `sacct`.
- Troubleshoot errors during and after job execution.
:::

## Job Scheduler Overview

As we briefly discussed in "[Introduction to HPC](01-intro.md)", HPC servers usually have a **job scheduler** software that manages all the jobs that the users submit to be run on the _compute nodes_. 
This allows efficient usage of the compute resources (CPUs and RAM), and the user does not have to worry about affecting other people's jobs. 

The job scheduler uses an algorithm to prioritise the jobs, weighing aspects such as: 

- How much time did you request to run your job? 
- How many resources (CPUs and RAM) do you need?
- How many other jobs have you got running at the moment?

Based on these, the algorithm will rank each of the jobs in the queue to decide on a "fair" way to prioritise them. Note that priority changes dynamically depending on how jobs are submitted and managed.

In these materials we will cover a job scheduler called **SLURM**, however the way this scheduler works is very similar to other schedulers.
The specific commands may differ, but the functionality is the same (see [this document](https://slurm.schedmd.com/rosetta.pdf) for matching commands to other job sheculers).


## Submitting a Job with SLURM

To submit a job to SLURM, you need to include your code in a _shell script_.
Let's start with a minimal example.

```bash
#!/bin/bash

sleep 60 # hold for 60 seconds
echo "This job is running on:"
hostname
```

You can save this script as `simple_job.sh` and run it from the login node using the `bash` interpreter: 

```bash
bash simple_job.sh
```

Which prints the output:

```
This job is running on:
login-node-name
```

To submit the job to the SLURM scheduler we instead use the `sbatch` command in a very similar way:

```bash
sbatch simple_job.sh
```

In this case, we are informed that the job is submitted to the SLURM queue with a `jobid` number assigned by the scheduler. By default an output file is stored under the name `slurm-JOBID.out`.

You can see all your jobs in the queue with: 

```bash
squeue -u yourusername
```

and we will see an output like this one:

```
JOBID  PARTITION      NAME      USER  ST  TIME  NODES  NODELIST(REASON)
  193   training  simple_j  particip   R  0:02      1  training-dy-t2medium-2
```

More information of the `sbatch` and `squeue` command, options, arguments and output can be found in SLURM documentation [here](https://slurm.schedmd.com/squeue.html) and [here](https://slurm.schedmd.com/sbatch.html)

### Partitions

Often, HPC servers have different types of compute node setups (e.g. queues for fast jobs, or long jobs, or high-memory jobs, etc.). 
SLURM calls these "partitions" and you can use the `-p` option to choose which partition your job runs on. 
Usually, which partitions are available on your HPC should be provided by the admins.

It's worth keeping in mind that partitions have separate queues, and you should always try to choose the partition that is most suited to your job. 


## Getting Job Information

After submitting a job, we may want to know:

- What is going on with my job? Is it running or has it finished?
- If it finished, did it finish successfully, or did it fail? 
- How many resources (e.g. RAM) did it use?
- What if I want to cancel a job because I realised there was a mistake in my script?

To see more **information for a job** (and whether it completed or failed), you can use:

```bash
seff JOBID
```

This shows you the status of the job (running, completed, failed), how many cores it used, how long it took to run and how much memory it used. 

Alternatively, you can use the `sacct` command, which allows displaying this and other information in a more condensed way (and for multiple jobs if you want to). 

For example:

```bash
sacct -j JOBID
```

All the format options available with `sacct` can be listed using `sacct -e`. There are many options to extract information of your jobs, you can get familiar with them in the [SLURM documentation](https://slurm.schedmd.com/sacct.html).


:::{.callout-note}
The `sacct` command may not be available on every HPC, as it depends on how it was configured by the admins.
:::

You can also see more details about a job, such as the working directory and output directories, using: 

```bash
scontrol show job <JOBID>
```

Finally, if you want to **cancel a job**, you can use:

```bash
scancel <JOBID>
```

And to cancel all your jobs simultaneously: `scancel -u <USERNAME>` (you will not be able to cancel other people's jobs, so don't worry about it).


## SLURM Environment Variables

One useful feature of SLURM jobs is the automatic creation of environment variables. 
Generally speaking, variables are a character that store a value within them, and can either be created by us, or sometimes they are automatically created by programs or available by default in our shell. 
When you submit a job with SLURM, it creates several variables, all starting with the prefix `$SLURM_`. 
One useful variable is `$SLURM_CPUS_PER_TASK`, which stores how many CPUs we requested for our job.
This means that we can use the variable to automatically set the number of CPUs for software that support multi-processing. 
We will see an example in the following exercise. 

Here is a table summarising some of the most useful environment variables that SLURM creates: 

| Variable | Description |
| -: | :- |
| `$SLURM_CPUS_PER_TASK` | Number of CPUs requested with `-c` |
| `$SLURM_JOB_ID` | The job ID | 
| `$SLURM_JOB_NAME` | The name of the job defined with `-J` |
| `$SLURM_SUBMIT_DIR` | The working directory defied with `-D` |
| `$SLURM_ARRAY_TASK_ID` | The number of the sub-job when running parallel arrays (covered in the [Job Arrays](05-arrays.md) section) |


## Summary

:::{.callout-tip}
#### Key Points

- Include the commands you want to run on the HPC in a shell script.
  - Always remember to include `#!/bin/bash` as the first line of your script (this is called a (shebang)[https://en.wikipedia.org/wiki/Shebang_(Unix)]).
- Submit jobs to the scheduler using `sbatch submission_script.sh`.
- Customise the jobs by including `#SBATCH` options at the top of your script as described in (SLURM docs)[https://slurm.schedmd.com/sbatch.html].
- Check the status of a submitted job by using `squeue -u USERNAME`,  `seff JOBID` or ` -j JOBID`.
- To cancel a running job use `scancel JOBID`.

See this [SLURM cheatsheet](https://slurm.schedmd.com/pdfs/summary.pdf) for a summary of the available commands.
:::
