# Using RESUBMIT as mirror mechanism with dynamic forwarding

## Introduction

This is the third use of Resubmit as mirroring mechanism. Compared to [04_Resubmit2-IP](https://github.com/Selltowitz/p4/tree/main/VM_Exercices/04_Resubmit2_IP) following features have been added:
- Broadcast for forwarding ARPs
- adapted forwarding and parsing concerning ARPs & Broadcast

Because of this two implementations this code is forwarding packets as expected compared to [04_Resubmit2-IP](https://github.com/Selltowitz/p4/tree/main/VM_Exercices/04_Resubmit2_IP).


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

## Parser states
- Parse Ethernet
- Parse IPv4
- ARP Forward

## Multicast/Broadcast
- Multicast-Group = 1
- acts like Broadcast
- all 3 Hosts are in MC-GRP 1

## Checksum Computation
is done

## Deparser
active

## Self-declared meta data
- yes
- 9bit port number -> saving ingress port for forwarding algorithm