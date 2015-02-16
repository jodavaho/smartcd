# smartcd
Bash scripts to support tab complete / subdirectory search when changing direrectory. See ReadMe for instructions on how to set up.

## Setup

Note, adjust the source statements to match where you checked out the code. 

1. add `source ~/.scd_setup` to your ~/.bashrc to add the scd command with full subdirectory pattern serach
2. add `source ~/.scdrc` to your ~/.bashrc to enable tab completion. (currently EXPERIMENTAL). have a look in .scdrc to see how to use it.

## Examples of use

### Ex 1: 

To change to the Documents directory in home, 

> scd ~ Documents

Not very interesting...

### Ex 2:

To change to the log directory, and the subdirectory in its tree that contains the word 'error'

> scd ~/logs error

### Ex 3: 

I use it like this. In '.bashrc' I put:

> export $paperdir=~/Dropbox/docs/papers
>
> function pcd(){ pcd $paperdir $@; }

My and my labmates papers are organized with the following naming convention: `<conf><year><subject>/<submission number>`. But there's often a lot of them.

So I can:

> pcd tro two n1

to cd to ~/Dropbox/docs/papers/vhook/journal/tro2014/tworobot/submission1

As you can see that's pretty concise.
