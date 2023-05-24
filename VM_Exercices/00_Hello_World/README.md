# Implementing a very simple P4 "Hello World" Program

## Introduction

This first P4 program serves as a "Hello World" for the programming language. A "Hello World" output text isn't being generated compared to other programming languages. The code implements the "simplest" forwarding algorithm. Packets which ingress on Port1, will egress on Port2 and vice-versa.
No headers (Ethernet, IP, ...) are implemented.

## Network Topology
![alt text](https://github.com/Selltowitz/p4/blob/main/Topo-Drawings/Hello-World.png?raw=true)

## Header implementation
no IETF or similar headers have been implemented

## Self-declared meta data
no own meta data was declared

## Related hardware code
I wrote another version of this p4 code. The code was ported to be executed on a Intel Tofino1 in an Edgecore Wedge 100BF-32X switch.
You can view the code [here](https://github.com/Selltowitz/p4/tree/main/Tofino_Exercices/01_Hello_World)