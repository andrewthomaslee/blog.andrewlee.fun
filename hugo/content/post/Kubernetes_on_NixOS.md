+++
date = '2025-12-01T13:12:50-06:00'
draft = false
title = '☸️Kubernetes on Bare Metal⚙️'
summary = 'Creating a RKE2🚜 cluster on bare metal Hetzner servers with NixOS❄️'
+++

## 13 Months

October 2024 I decided to try and learn Computer Programming, but for real this time.
13 months later and I'm deep into self hosting RKE2🚜 Kubernetes clusters on bare metal Hetzner servers with NixOS❄️.

## 🐇🕳️

I have a strong adversion to paying for a service I know I can do myself. That is 85% of SaaS/PaaS/BaaS services, ie. "I don't want the burden of configuring this, I'll pay for the abstraction".

But if you find yourself getting into the game of creating the abstractions. You'll find out that is one large rabbit hole. At some point you'll have to pay for *something*.

I settled on paying for bare metal auctioned servers from Hetzner. 

I bought 3 server with similar specs:
- Intel Xeon E-2176G (12) @ 4.700GHz
- 64 GB RAM (DDR4 ECC)
- 960 GB SSD (NVMe) x 2
- 1 Gbps NICs
- IPv4 & IPv6

Total cost is ~ `$120` per month + `$6` load balancer.

*WAY* bigger than I need. . . But small cost for that much metal. ⚙️

## ❄️

NixOS was an obvious choice. 

I want a system that has built in **rollbacks**, is **immutable**, is **reproducible**. 🏭 I want a system that the configuration is **declarative**, and **know before hand**. I want a system that lets me configure it infinitely, and with fine grained control.

With NixOS my servers' OS configuration lives in version control git first, and then installed to the servers. No more random magic /etc/ files.

The are things to not like about NixOS. Learning curve. To use it you need to know Nix the programming language. Must people have an adversion to Nix.

But I'm well aware that NixOS is the superior OS. . .  for me. Not everyone.

## K3s, then RKE2🚜

K3s is f*cking great. But RKE2 feels cooler somehow.

Firstly I built many clusters with K3s and loved how easy and plugable everything was. But then I noticed that RKE2 got added as a NixOS module so I could easily* swap K3s service definitions for RKE2 in my cluster repo and things would just work.

Things did just work. But custom CNI helm installations didn't work so easily.

I learned that Rancher makes K3s and RKE2 with really good documentation and really good **defaults**. Just try and stick to the defaults. Please.

## Architecture
Host OS Features:
- `Tailscale`
- `HAProxy` for TLS termination + `keepalived` for load balancing

Cluster Features:
- `Cilium` with Kube-Proxy replacement
- `Longhorn`
- `Traefik` with Gateway API
- `ArgoCD`





