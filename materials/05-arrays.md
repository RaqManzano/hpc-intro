---
pagetitle: "HPC SLURM"
---

# Job Paralellisation [EXTRA]

:::{.callout-tip}
#### Learning Objectives

- Distinguish between different kinds of parallel computations: multi-threading within a job and job parallelisation across independent jobs.
- Use SLURM _job arrays_ to automatically submit several parallel jobs. 
- Customise each parallel job of an array to use different input -> output.
:::

## Parallelising Tasks

One of the important concepts in the use of a HPC is **parallelisation**. 
This concept is used in different ways, and can mean slightly different things. 

A program may internally support parallel computation for some of its tasks, which we may refer to as _multi-threading_ or _multi-core processing_. 
In this case, there is typically a single set of "input -> output", so all the parallel computations need to finish in order for us to obtain our result. 
In other words, there is some dependency between those parallel calculations. 

On the other hand, we may want to run the same program on different inputs, where each run is completely independent from the previous run. In these cases we say the task is "embarrassingly parallel".
Usually, running tasks completely in parallel is faster, since we remove the need to keep track of what each task's status is (since they are independent of each other). 

Finally, we may want to do both things: run several jobs in parallel, while each of the jobs does some internal parallelisation of its computations (multi-threading). 

![Schematic of parallelisation.](images/parallel.svg)

:::{.callout-note}
**Terminology Alert!**

Some software packages have an option to specify how many CPU cores to use in their computations (i.e. they can parallelise their calculations).
However, in their documentation this you may be referred to as **cores**, **processors**, **CPUs** or **threads**, which are used more or less interchangeably to essentially mean "how many calculations should I run in parallel?". 
Although these terms are technically different, when you see this mentioned in the software's documentation, usually you want to set it as the number of CPU cores you request from the cluster. 
:::


## Job Arrays

There are several ways to parallelise jobs on a HPC. 
One of them is to use a built-in functionality in SLURM called **job arrays**. 

_Job arrays_ are a collection of jobs that run in parallel with identical parameters.
Any resources you request (e.g. `-c`, `--mem`, `-t`) apply to each individual job of the "array".
This means that you only need to submit one "master" job, making it easier to manage and automate your analysis using a single script.

Job arrays are created with the *SBATCH* option `-a START-FINISH` where *START* and *FINISH* are integers defining the range of array numbers created by SLURM.
SLURM then creates a special shell variable `$SLURM_ARRAY_TASK_ID`, which contains the array number for the job being processed.
Later in this section we will see how we can use some tricks with this variable to automate our analysis.

For now let's go through this simple example, which shows what a job array looks like (you can find this script in the course folder `slurm/parallel_arrays.sh`):

```bash
# ... some lines omitted ...
#SBATCH -o logs/parallel_arrays_%a.log
#SBATCH -a 1-3

echo "This is task number $SLURM_ARRAY_TASK_ID"
echo "Using $SLURM_CPUS_PER_TASK CPUs"
echo "Running on:"
hostname
```

Submitting this script with `sbatch slurm/parallel_arrays.sh` will launch 3 jobs. 
The "_%a_" keyword is used in our output filename (`-o`) and will be replaced by the array number, so that we end up with three files: `parallel_arrays_1.log`, `parallel_arrays_2.log` and `parallel_arrays_3.log`. 
Looking at the output in those files should make it clearer that `$SLURM_ARRAY_TASK_ID` stores the array number of each job, and that each of them uses 2 CPUS (`-c 2` option). 
The compute node that they run on may be variable (depending on which node was available to run each job).


:::{.callout-note}
You can define job array numbers in multiple ways, not just sequencially. 

Here are some examples taken from SLURM's Job Array Documentation: 

| Option | Description |
| -: | :------ | 
| `-a 0-31` | index values between 0 and 31 |
| `-a 1,3,5,7` | index values of 1, 3, 5 and 7 |
| `-a 1-7:2` | index values between 1 and 7 with a step size of 2 (i.e. 1, 3, 5 and 7) |

:::



## Using `$SLURM_ARRAY_TASK_ID` to Automate Jobs

One way to automate our jobs is to use the job array number (stored in the `$SLURM_ARRAY_TASK_ID` variable) with some command-line tricks. 
The trick we will demonstrate here is to parse a CSV file to read input parameters for our scripts. 

For example, in our `data/` folder we have the following file, which includes information about parameter values we want to use with a tool in our next exercise. 

```bash
$ cat data/turing_model_parameters.csv
```

```
f,k
0.055,0.062
0.03,0.055
0.046,0.065
0.059,0.061
```

This is a CSV (comma-separated values) format, with two "columns" named "f" and "k".
Let's say we wanted to obtain information for the 2rd set of parameters, which in this case is in the 3rd line of the file (because of the column header). 
We can get the top N lines of a file using the `head` command (we pipe the output of the previous `cat` command):

```bash
$ cat data/turing_model_parameters.csv | head -n 3
```

This gets us lines 1-3 of the file. 
To get just the information about that 2nd set of parameters, we can now _pipe_ the output of the `head` command to the command that gets us the bottom lines of a file `tail`:

```bash
$ cat data/turing_model_parameters.csv | head -n 3 | tail -n 1
```

Finally, to separate the two values that are separated by a comma, we can use the `cut` command, which accepts a _delimiter_ (`-d` option) and a _field_ we want it to return (`-f` option):

```bash
$ cat data/turing_model_parameters.csv | head -n 3 | tail -n 1 | cut -d "," -f 1
```

In this example, we use comma as a delimiter field and obtained the first of the values after "cutting" that line. 

Schematically, this is what we've done:

![](images/head_tail.png)

So, if we wanted to use job arrays to automatically retrieve the relevant line of this file as its input, we could use `head -n $SLURM_ARRAY_TASK_ID` in our command pipe above. 
Let's see this in practice in our next exercise. 


## Summary

:::{.callout-tip}
#### Key Points

- Some tools internally parallelise some of their computations, which is usually referred to as _multi-threading_ or _multi-core processing_.
- When computational tasks are independent of each other, we can use job parallelisation to make them more efficient. 
- We can automatically generate parallel jobs using SLURM job arrays with the `sbatch` option `-a`.
- SLURM creates a variable called `$SLURM_ARRAY_TASK_ID`, which can be used to customise each individual job of the array. 
  - For example we can obtain the input/output information from a simple configuration text file using some command line tricks: 
  `cat config.csv | head -n $SLURM_ARRAY_TASK_ID | tail -n 1`

Further resources:

- [SLURM Job Array Documentation](https://slurm.schedmd.com/job_array.html)
:::
