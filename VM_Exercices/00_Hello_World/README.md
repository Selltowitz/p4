# Implementing a very simple P4 "Hello World" Program

## Introduction

This first P4 program serves as a "Hello World" for the programming language. A "Hello World" output text isn't being generated compared to other programming languages. The code implements the "simplest" forwarding algorithm. Packets which ingress on Port1, will egress on Port2 and vice-versa.

![alt text](https://github.com/Selltowitz/p4/blob/main/topo-drawings/Hello-World.png?raw=true)

## Relevant Documentation

The documentation for P4_16 and P4Runtime is available [here](https://p4.org/specs/)

All excercises in this repository use the v1model architecture, the documentation for which is available at:
1. The BMv2 Simple Switch target document accessible [here](https://github.com/p4lang/behavioral-model/blob/master/docs/simple_switch.md) talks mainly about the v1model architecture.
2. The include file `v1model.p4` has extensive comments and can be accessed [here](https://github.com/p4lang/p4c/blob/master/p4include/v1model.p4).
