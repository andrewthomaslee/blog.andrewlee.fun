+++
date = '2026-02-23T06:44:46-06:00'
draft = false
title = 'Bytes all the way down🐢'
summary = 'How learning ❄️Nix *Supercharged* my Linux skills🐧'
+++

# Infinite Regress♾️🌏🐢🐢🐢

The allegory **Turtles all the way down** illustrates *infinite regress*: an explanation relying on the same explanation repeatedly, never reaching a foundation.

![Turtles all the way down](https://render.fineartamerica.com/images/rendered/default/poster/4/8/break/images-medium-5/turtles-all-the-way-down-susan-culver.jpg)

For software developers, however, there is a foundational truth: **Bytes on Disk**. Yes, there are deeper layers like electrons, but our job is knowing how to put bytes on disk.

# What if you compiled EVERYTHING? 🧑‍💻

Technically, compiling from source is the "purest" way to install software. But doing that for Firefox, the Kernel, and GCC? That is **Linux From Scratch**, and you'd be nuts🥜 to do it manually.

**The Trade-off:**
*   ✅ **Pros:** Extreme educational value, zero bloat, ultimate customization, bleeding edge access, and you know exactly where every byte came from.
*   ❌ **Cons:** Exorbitant build times, dependency hell, system instability, nightmare maintenance.

**The Verdict:** Do it if you want to be a Linux expert. Don't do it if you want to get work done today.

## ❄️NixOS *is* Linux From Scratch with magic🪄

If `Linux From Scratch` is building a car by manually welding every piece of metal, **NixOS** is writing a blueprint and having a robot factory build it instantly every time you turn the key.

NixOS is essentially Linux built from source by bash scripts. It gives you the benefits of *Linux From Scratch* without the manual labor.

## Why I started using ❄️Nix
![20 minute adventure rick morty nix](20-minute-adventure-rick-morty-nix.png)

When Windows 10 hit End-of-Life, I switched to Ubuntu. Initially, it was great. But as I learned Linux, I tinkered. I copy-pasted commands, edited `/etc/` files, and ran **Imperative** commands.

> **Imperative:** Commands that tell the system *how* to do something (e.g., `apt install firefox`).

Eventually, my tinkering caught up with me. I bricked my system and spent 30 minutes staring at a black screen, debugging via my phone. I needed a better way.

I remembered a `Fireship` video about **Nix**. I was intimidated by the learning curve, but desperate for a working machine. I flashed a NixOS USB, formatted my drives, and to my surprise it just worked. Despite me knowing zero about **Nix**, my machine was in fact **NixOS**!

### The Evolution: From "It Works" to "It's Robust"

For a while, I used a standard install. But I knew I was missing the real power. I dove into **Nix Flakes**, version control, and `home-manager`. After a crammed learning journey, I achieved an OS that was:

*   **Declarative:** Describing *what* the result should be (e.g., `firefox is installed`), not *how* to do it.
*   **Reproducible:** My OS is identical every time I build it.
*   **Rollback-able:** If I break something, I just boot the previous generation.
*   **Version Controlled:** My entire OS config lives in Git.

Finally, I could tinker with **Zero Fear**😎. I could swap desktop environments, mess with kernels, and break things, knowing I could always revert to a working state. I achieved ***system configuration nirvana***. 🌞 🌴 🏄

## The Last 10%: Managing the Fleet

For fun I watch talks from conventions and confernces. One day I watched a talk about this project called **Clan**.

Clan is a framework built on NixOS for managing machines (networking, backups, secrets) declaratively. I started by managing a remote VPS on Hetzner, replacing my old Docker/Ubuntu setup with a robust NixOS configuration.

Now, I treat my computers like cattle, not pets. My cluster is / has:
*   Managed by a `Clan Flake`
*   Automatic backups with `borg`
*   Secrets are encrypted with `sops`
*   Networking VPN with `wireguard`
*   Version controlled in a public repository

***True Bliss***🥇

## Why do people hate ❄️Nix?
![Superiority Complex](superiority-complex.webp)

Everyone agrees that *reproducible builds* are valuable. They hate Nix because of the **Paradigm Shift**.

Common complaints include:
*   "I don't want to learn a new functional language."
*   "Why can't I just use Dockerfiles?"
*   "The learning curve is a wall."

And yes, you can just use Docker. But learning new things grows the brain 🧠. While I don't judge Fedora or Arch users (okay, maybe a little 🧑‍⚖️), I am incredibly happy I pushed through the difficulty to learn Nix.

## Learning Nix Supercharged my Linux Skills🐧

The "Turtles" metaphor extends to NixOS because everything is a **derivation**.

A derivation is a bridge between the Nix language and the filesystem. It is an instruction sheet that tells Nix exactly how to **Put Bytes on Disk**. It solves dependency hell by listing every single input required before the build starts.

**It is derivations all the way down.**
Your OS, kernel, desktop environment, and apps are all derivations.

Once I understood this, I was freed from the constraints of traditional Linux management. Whether it's a Kubernetes cluster or a gaming rig, I just write the derivation, and Nix handles the rest.

Learn to put bytes on disk *declaratively*, and you will unlock the true power of your machine.


### My Public NixOS Repos
*  My Personal Computers: [nixos](https://github.com/andrewthomaslee/nixos)
*  Kubernetes Cluster + Docker: [Clan-Kube](https://github.com/andrewthomaslee/Clan-Kube)


### Want to learn about Nix in 212 seconds?🔥🚢
{{< youtube FJVFXsNzYZQ >}}

### NixCon2024 Clan: Fully automated distributed NixOS management
{{< youtube zI8MrBP1LCc >}}