# Using RESUBMIT as mirror mechanism with dynamic forwarding

## Introduction

This is the third use of Resubmit as mirroring mechanism. Compared to [04_Resubmit2-IP](https://github.com/Selltowitz/p4/tree/main/VM_Exercices/04_Resubmit2_IP) following features have been added:
- Broadcast for forwarding ARPs
- adapted forwarding and parsing concerning ARPs & Broadcast




## Forwarding algorithm
- Lookup ipv4 destination address in table
- set the egress port regarding table value in ipv4-destination table 
		


## Network Topology
![alt text](https://github.com/Selltowitz/p4/blob/main/Topo-Drawings/Resubmit3-ARP.png?raw=true)

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