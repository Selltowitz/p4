# Implementing the cloning mechanism of P4 with two switches

## Introduction

This P4 program uses the Cloning mechanism of P4 and both switches do clone packets. Every ingress packet on switch1 (S1) is cloned to its fourth port which is connected to the second switch S2. This switch is cloning its ingress on Port4 to Port3.

- only static ingress cloning on both switches
- Forwarding:
	- In: 1 -> Out: 4
	- In: 4 -> Out: 2
- copy and original packet from H1 will be send to S2. S2 is cloning both packets. The clones are forwarded to H3; the "originals" (from S2's perspective) are sent to H2.

## Network Topology
![alt text](https://github.com/Selltowitz/p4/blob/main/Topo-Drawings/Double-Clone.png?raw=true)

## Header implementation
no IETF or similar headers have been implemented

## Self-declared meta data
no own meta data was declared
