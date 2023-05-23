# p4
## This repo
This git repo focuses on [P4_16 (Programming Protocol-Independent Packet Processors)](https://p4.org/)

It is connected to a [research program](https://www.ifaf-berlin.de/projekte/nettraffic-p4/) at the [Hochschule für Technik und Wirtschaft Berlin (HTW Berlin)](https://htw-berlin.de) by [Prof. Dr. Thomas Scheffler](https://github.com/tscheffl) and my own Bachelor thesis ["Aufbau einer Lernplattform zur Programmiersprache P4"](https://github.com/Selltowitz/p4/blob/main/Aufbau_einer_Lernplattform_zur_Programmiersprache_P4.pdf).

I created 6 exercices on the [P4-VM](https://github.com/p4lang/tutorials) of the P4 Language Consortium using Mininet.
3 of those exercices have been successfully ported to real hardware (Edgecore Wedge 100BF-32X with Intel Tofino1). The main focus of those exercices is getting an "easier" start into the programming language and will be explained later.


## Relevant Documentation

The documentation for P4_16 and P4Runtime is available [here](https://p4.org/specs/)

All excercises in the VM_Exercices folder use the v1model architecture, the documentation for which is available at:
1. The BMv2 Simple Switch target document accessible [here](https://github.com/p4lang/behavioral-model/blob/master/docs/simple_switch.md) talks mainly about the v1model architecture.
2. The include file `v1model.p4` has extensive comments and can be accessed [here](https://github.com/p4lang/p4c/blob/master/p4include/v1model.p4).


The documentation for Tofino Native Architecture (TNA) is available [here](https://raw.githubusercontent.com/barefootnetworks/Open-Tofino/master/PUBLIC_Tofino-Native-Arch.pdf)

## Thanks
Thanks to the people @
- MTI Teleport Munich GmbH
- HTW Berlin
- AVM GmbH
- BISDN
- Barefootnetworks
- P4 Language Consortium
- OpenNetworkFoundation


