# Using RESUBMIT as mirror mechanism

## Introduction

This exercice is very similar compared to [01_Simple_Clone](https://github.com/Selltowitz/p4/tree/main/VM_Exercices/01_Simple_Clone) but instead of cloning the incoming packets the switch resubmits them.


## Forwarding algorithm
Has the incoming packet been resubmitted already?
- No
	- save ingress port in own meta data
		- meta.mymeta.port = ingress port
	- resubmit the packet
- Yes
	- Forwarding as coded in 'meta.mymeta.port'
		- In: 1 -> Out: 2
		- In: 2 -> Out: 1
		- In: 0 -> Out: 2 (In: 0 = default = every other packet)
		


## Network Topology
![alt text](https://github.com/Selltowitz/p4/blob/main/Topo-Drawings/Reusbmit.png?raw=true)

## Header implementation
no IETF or similar headers have been implemented

## Self-declared meta data
- yes
- saves ingress port