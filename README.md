# P4

## Description
This git repo focuses on [P4_16 (Programming Protocol-Independent Packet Processors)](https://p4.org/).

It is connected to a [research program](https://www.ifaf-berlin.de/projekte/nettraffic-p4/) at the [Hochschule für Technik und Wirtschaft Berlin (HTW Berlin)](https://htw-berlin.de) by [Prof. Dr. Thomas Scheffler](https://github.com/tscheffl) and my own Bachelor thesis ["Aufbau einer Lernplattform zur Programmiersprache P4"](https://github.com/Selltowitz/p4/blob/main/Aufbau_einer_Lernplattform_zur_Programmiersprache_P4.pdf). An english translation can be found here: ["Building a training platform for the programming language P4"](https://github.com/Selltowitz/p4/blob/main/Building_a_training_plattform_for_the_programming_language_P4.pdf)
If you wanna cite any of those 2 here are the links to the ResearchGate uploads incl. DOI number:
[German version](https://www.researchgate.net/publication/371985470_Bachelor_Thesis_Aufbau_einer_Lernplattform_zur_Programmiersprache_P4_Building_a_training_platform_for_the_programming_language_P4?_sg%5B0%5D=FehitWY4qgoFO5dKxmeKDfzX9k7NEYa785VZbD3U6dd0gatUgS_H0F8Tdc4Gg6QWeRrFR0yNTTruQlYfaVFQvpQp2NE0cHP0CTNc1HDw.zExKtDydyWf-We7jP8KwkdoYDDZhM2TDmxZSTeqn4z4FNNiMAE3-Pb6VWu5dk7DfVf4LLhbN1Pud9Mdjg8j9Rg)
[English version](https://www.researchgate.net/publication/373829255_Bachelor_Thesis_Building_a_training_platform_for_the_programming_language_P4?_sg%5B0%5D=wS6YmlhTSLGP2nmR4BXmdxdRKrEr0L27KP-V8bP9vNHEVvXZID2bI_f2jL3bku2aV7bqzmCUmKtA3o-b4bwjrRyo5XedGv7YbBI8Vh9F.--QafriQLKzVbnhJ3MrqTdUYDbeQEgSNTXOuzqd5unDJ7MsqdqWMwDeQvGxZmpMFuIzSJvwsJ24ch59qfIs_1g)
I created 6 exercices on the [P4-VM](https://github.com/p4lang/tutorials) of the P4 Language Consortium using Mininet.
3 of those exercices have been successfully ported to real hardware (Edgecore Wedge 100BF-32X with Intel Tofino1). The main focus of those exercices is getting an "easier" start into the programming language and will be explained in the associated exercice folder or the thesis.

## Under construction
Confidentiality checks for my bachelor thesis were approved at the end of May 2023, so I firstly wanted to upload my P4 code here.
Mainly fixing READMEs for every exercice for now and doing my Masters in Information and Communication Engineering at HTW Berlin.
Feel free to contact me :)

## Papers
Out of the research program we did the following paper [Using P4-INT on Tofino for measuring device performance characteristics in a network lab](https://www.researchgate.net/publication/371877786_Using_P4-INT_on_Tofino_for_measuring_device_performance_characteristics_in_a_network_lab), which was presented at [WueWoWas'23](https://lsinfo3.github.io/WueWoWAS2023/). 

## Relevant Documentation

The documentation for P4_16 and P4Runtime is available [here](https://p4.org/specs/)

All excercises in the VM_Exercices folder use the v1model architecture, the documentation for which is available at:
1. The BMv2 Simple Switch target document accessible [here](https://github.com/p4lang/behavioral-model/blob/master/docs/simple_switch.md) talks mainly about the v1model architecture.
2. The include file `v1model.p4` has extensive comments and can be accessed [here](https://github.com/p4lang/p4c/blob/master/p4include/v1model.p4).


The documentation for Tofino Native Architecture (TNA) is available [here](https://raw.githubusercontent.com/barefootnetworks/Open-Tofino/master/PUBLIC_Tofino-Native-Arch.pdf).

## Thanks
Thanks to the people @
- MTI Teleport Munich GmbH
- HTW Berlin
- AVM GmbH
- BISDN
- Barefootnetworks
- P4 Language Consortium
- OpenNetworkFoundation
- IETF
- Linux
- Wikipedia
- Family and Friends <3


