# Implementing the cloning mechanism of P4

## Introduction

This P4 program uses the Cloning mechanism of P4. Every ingress = Port1 packet is cloned to Port3. Only ingress cloning is used.

- Forwarding as in "00_Hello_World".
- Clone-Session IDs hard-coded in p4 file (-> static cloning to Port3)
- Cloning to Port3 is coded in 'pod-topo/s1-commands.txt'
-> Clone-Session-ID = 100, Egress-Port = 3


## Network Topology
![alt text](https://github.com/Selltowitz/p4/blob/main/Topo-Drawings/Simple-Clone.png?raw=true)

## Header implementation
no IETF or similar headers have been implemented

## Self-declared meta data
no own meta data was declared
