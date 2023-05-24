# Implementing a very simple P4 "Hello World" Program on a Intel Tofino Chip in an EdgeCore Wedge 100BF-32X whitebox switch with Ubuntu

## Introduction

This first P4 program serves as a "Hello World" for the programming language. A "Hello World" output text isn't being generated compared to other programming languages. The code implements the "simplest" forwarding algorithm. Packets which ingress on QSFP1-3, will egress on QSFP1-4 and vice-versa.
No headers (Ethernet, IP, ...) are implemented.

## Header implementation
no IETF or similar headers have been implemented

## Self-declared meta data
no own meta data was declared