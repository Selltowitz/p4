# Implementing a very simple P4 Program

## Introduction

This code only serves to highlight the structural patterns in a P4 program.
No packet processing or parsing is performed. Packets received via Port 1 are simply send to Port 2 and vice versa.

The switch does not have any table.

We will use the following simple topology for this exercise. The pod consists of a single switch that connects to two hosts H1 and H2.
The two hosts are in the same IP-Subnet.

The P4 program is written for the V1Model architecture implemented
on P4.org's bmv2 software switch. The architecture file for the V1Model
can be found at: /usr/local/share/p4c/p4include/v1model.p4. This file
describes the interfaces of the P4 programmable elements in the architecture,
the supported externs, as well as the architecture's standard metadata
fields. We encourage you to take a look at it.


## Run the code

The directory with this README also contains a P4 program,
`simple.p4`, which implements the network function described above.
The code assumes that the P4 tutorials from Github are loaded on the machine and are in the same directory tree.

Let's compile `simple.p4` and bring
up a switch in Mininet to test its behavior.

1. In your shell, run:
   ```bash
   make run
   ```
   This will:
   * compile `simple.p4`, and
   * start the pod-topo in Mininet and load a switch with
   the appropriate P4 program, and
   * configure all hosts with the commands listed in
   [pod-topo/topology.json](./pod-topo/topology.json)

2. You should now see a Mininet command prompt. Try to ping between
   hosts in the topology:
   ```bash
   mininet> h1 ping h2
   mininet> pingall
   ```
3. Type `exit` to leave each xterm and the Mininet command line.
   Then, to stop mininet:
   ```bash
   make stop
   ```
   And to delete all pcaps, build files, and logs:
   ```bash
   make clean
   ```

### A note about the control plane

A P4 program defines a packet-processing pipeline, but the rules
within each table are inserted by the control plane. When a rule
matches a packet, its action is invoked with parameters supplied by
the control plane as part of the rule.

In this exercise, there is no control plane interaction, because the
switch only executes a very simple program.
Normally, as part of bringing up the Mininet instance, the
`make run` command will install packet-processing rules in the tables of
each switch. These are defined in the `sX-runtime.json` files, where
`X` corresponds to the switch number.

**Important:** We use P4Runtime to install the control plane rules. The
content of files `sX-runtime.json` refer to specific names of tables, keys, and actions, as defined in the P4Info file produced by the compiler (look for the
file `build/simple.p4.p4info.txt` after executing `make run`). Any changes in the P4
program that add or rename tables, keys, or actions will need to be reflected in
these `sX-runtime.json` files.



### Troubleshooting

There are several problems that might manifest as you develop your P4 program:

1. `simple.p4` might fail to compile. In this case, `make run` will
report the error emitted from the compiler and halt.

2. `simple.p4` might compile but fail to support the control plane
rules in the `s1-runtime.json` through `s3-runtime.json` files that
`make run` tries to install using P4Runtime. In this case, `make run` will
report errors if control plane rules cannot be installed. Use these error
messages to fix your `simple.p4` implementation.

3. `simple.p4` might compile, and the control plane rules might be
installed, but the switch might not process packets in the desired
way. The `logs/s1.log` files contain detailed logs
that describe how the switch processes each packet. The output is
detailed and can help pinpoint logic errors in your implementation.

#### Cleaning up Mininet

In the latter two cases above, `make run` may leave a Mininet instance
running in the background. Use the following command to clean up
these instances:

```bash
make stop
```

## Relevant Documentation

The documentation for P4_16 and P4Runtime is available [here](https://p4.org/specs/)

All excercises in this repository use the v1model architecture, the documentation for which is available at:
1. The BMv2 Simple Switch target document accessible [here](https://github.com/p4lang/behavioral-model/blob/master/docs/simple_switch.md) talks mainly about the v1model architecture.
2. The include file `v1model.p4` has extensive comments and can be accessed [here](https://github.com/p4lang/p4c/blob/master/p4include/v1model.p4).
