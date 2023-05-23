# Implementing the cloning mechanism of P4

## Introduction

This P4 program uses the Cloning mechanism of P4. Every ingress = Port1 packet is cloned to Port2.


## Network Topology
![alt text](https://github.com/Selltowitz/p4/blob/main/Topo-Drawings/Simple-Clone.png?raw=true)

## Relevant Documentation

The documentation for P4_16 and P4Runtime is available [here](https://p4.org/specs/)

All excercises in the VM_Exercices folder use the v1model architecture, the documentation for which is available at:
1. The BMv2 Simple Switch target document accessible [here](https://github.com/p4lang/behavioral-model/blob/master/docs/simple_switch.md) talks mainly about the v1model architecture.
2. The include file `v1model.p4` has extensive comments and can be accessed [here](https://github.com/p4lang/p4c/blob/master/p4include/v1model.p4).
