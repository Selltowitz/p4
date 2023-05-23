# Using RESUBMIT as mirror mechanism with dynamic forwarding

## Introduction

This is the second use of Resubmit as mirroring mechanism. Compared to [03_Resubmit](https://github.com/Selltowitz/p4/tree/main/VM_Exercices/03_Resubmit) following features have been added:
- Forwarding via table lookup
- real Parser implementation instead of an empty apply{}
- Headers & Ethertypes 

## !!! Important Disclaimer !!!
**This p4 code + the network configuration for Mininet won't forward any packet. Broadcast wasn't implemented in this stage but in its successor [05_Resubmit3-ARP](https://github.com/Selltowitz/p4/tree/main/VM_Exercices/05_Resubmit3-ARP).**
**It was good practice, but I saved the final working code, net and exercise in its successor :)** 

## Forwarding algorithm
- Lookup ipv4 destination address in table
- set the egress port regarding table value in ipv4-destination table 
		


## Network Topology
![alt text](https://github.com/Selltowitz/p4/blob/main/Topo-Drawings/Resubmit2-ip.png?raw=true)

## Header implementation
- Ethernet
- IPv4

## Ethertypes
- ARP
- IPv4

## Tables
- IPv4 Destination Table -> Longest Prefix Match (LPM)

## Self-declared meta data
- yes
- 9bit port number -> saving ingress port for forwarding algorithm