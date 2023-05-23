# Implementing the cloning mechanism of P4 with two switches

## Introduction

This P4 program uses the Cloning mechanism of P4 and both switches do clone packets. Every ingress packet on switch1 (S1) is cloned to its fourth port which is connected to the second switch S2. This switch is cloning its ingress on Port4 to Port3.


## Network Topology
![alt text](https://github.com/Selltowitz/p4/blob/main/Topo-Drawings/Double-Clone.png?raw=true)

## Relevant Documentation

The documentation for P4_16 and P4Runtime is available [here](https://p4.org/specs/)

All excercises in the VM_Exercices folder use the v1model architecture, the documentation for which is available at:
1. The BMv2 Simple Switch target document accessible [here](https://github.com/p4lang/behavioral-model/blob/master/docs/simple_switch.md) talks mainly about the v1model architecture.
2. The include file `v1model.p4` has extensive comments and can be accessed [here](https://github.com/p4lang/p4c/blob/master/p4include/v1model.p4).
