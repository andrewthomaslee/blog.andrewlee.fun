+++
date = '2026-02-15T14:58:00-06:00'
draft = false
title = '🚜RKE2 + 🚢Dockhand on NixOS❄️'
summary = "Truly reproducible infrastructure for any environment, defined in git."
+++

GitHub Repo 👉 [Clan-Kube](https://github.com/andrewthomaslee/Clan-Kube.git)

# 🚜RKE2 + 🚢Dockhand on NixOS❄️

This project creates a Kubernetes [`RKE2`](https://docs.rke2.io/) cluster and Docker Host with [`Dockhand`](https://dockhand.pro/). The cloud provider used is [Hetzner Cloud](https://www.hetzner.com/cloud) but this repo can be easily adapted to another provider or bare metal machines.



The goal of this project is to make **truly reproducible infrastructure** for any environment, defined in git. 



The host OS is `NixOS`❄️ and managed by a `flake` with [`Clan`](https://clan.lol/). Whether you're running a homelab or maintaining critical computing infrastructure, [`Clan`](https://clan.lol/) will help reduce maintenance burden by allowing a git repository to define your whole network of computers.


# Architecture 🗺️


Kubernetes Cluster Diagram:


![RKE2-Infra](Industrial-Host-Infra-mini.excalidraw.avif)


Full Infrastructure Diagram:


![Full-Infra](Industrial-Host-Infra-Full.excalidraw.avif)



# 🚜RKE2 Kubernetes☸️
[`RKE2`](https://docs.rke2.io/) is Rancher's enterprise-ready next-generation Kubernetes distribution. It has also been known as RKE Government.

It is a fully conformant Kubernetes distribution that focuses on security and compliance within the U.S. Federal Government sector.

Machine Features:
- [`RKE2`](https://docs.rke2.io/) version **1.35.0**
- [`Tailscale`](https://tailscale.com/) VPN
- [`HAProxy`](https://www.haproxy.com/) for Web Traffic and Kubernetes API Load Balancing

Cluster Features:
- [`Cilium`](https://cilium.io/use-cases/cni/) Container Network Interface
- [`Traefik`](https://doc.traefik.io/traefik/getting-started/quick-start-with-kubernetes/) Ingress Controller
- [`Cert-Manager`](https://cert-manager.io/) auto TLS Certificates
- [`Longhorn`](https://longhorn.io/) + [`Hetzner Cloud Volumes`](https://github.com/hetznercloud/csi-driver) + [`Local Path Provisioner`](https://artifacthub.io/packages/helm/containeroo/local-path-provisioner) Container Storage Interface
- [`ArgoCD`](https://argo-cd.readthedocs.io/en/stable/) GitOps



# 🐋Docker + Dockhand🚢
The Docker host features:
- [`Docker`](https://www.docker.com/) version **29.1.5**
- [`Tailscale`](https://tailscale.com/) VPN
- [`TSDProxy`](https://almeidapaulopt.github.io/tsdproxy/) Very simple proxy for Tailscale
- [`Dockhand`](https://dockhand.pro/) Docker Web UI
- [`lazydocker`](https://github.com/jesseduffield/lazydocker) Terminal UI for both docker and docker-compose
- [`rsync`](https://rsync.samba.org/) Fast incremental file transfer utility




## 🔍 Flake Inspection
To display the outputs of the `flake.nix` file run: 
```bash
nix flake show
```

`nixosConfigurations` are the machines this flake builds.
```bash
nixosConfigurations
├── mng-0
├── wrk-0
├── proxy
└── docker
```

`apps` are predefined scripts that can be run with `nix run .#<app-name>`.
```bash
apps
├── get-config
├── get-token
├── sops-add-user
├── setup-env
├── send-env
└── tmp-pod
```

`devShells` are the development shells that provide all the dependencies for the project.
```bash
devShells
└── default
```



# Prerequisites 📋
To use this project, you need either:
*   [`Nix package manager`](https://nixos.org/download/) + [`flakes`](https://nixos.wiki/wiki/Flakes) enabled.

or

*   [`Docker`](https://docs.docker.com/get-docker/) + [`Dev Containers`](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-containers) VSCode Extension *(Untested)*


### Static Variables 🔧
Static variables are defined in `infra.json` and used throughout the project.  For instance the field `meta.domain` is used in the `Traefik` ingress controller configuration and to define ingress routes for the other Web UIs. The top level `env` variable is used to define the environment of the cluster, ie *dev*, *staging* or *prod*.


### Assumptions 📋
- A remote storage box is available to store secrets and config files. This can be any host reachable over ssh. I am using a [Hetzner Storage Box](https://www.hetzner.com/storage/storage-box/)
- Tailscale is used as the VPN. Tailscale can be self hosted via [Headscale](https://headscale.net/stable/) but I am using Tailscale Cloud.
- Cloudflare Origin Certificates are used for mTLS with the Cloudflare Proxy for the domain `meta.domain` in `infra.json`. This ensures that only authorized users can access the cluster Web UIs.
- The domain `meta.domain` in `infra.json` has properly configured DNS records pointing to the IPs of the servers, either the `proxy` or the `docker` machine.


# devShell 🧑‍💻🐚

Use the Nix development shell to enter the environment with all development dependencies installed. *Optionally* use [direnv](https://direnv.net/docs/installation.html) to make life easier. `direnv` drops you into the devShell when it detects a `.envrc` file and reloads the devShell when it detects a change to the shell. Either download it or use the [VSCode extension](https://marketplace.visualstudio.com/items?itemName=mkhl.direnv).

```bash
nix develop
```
Nix devShell works best with `bash`. If you want to use a different shell see this [discussion](https://discourse.nixos.org/t/using-nix-develop-opens-bash-instead-of-zsh/25075/9).

Packages installed:

-   [`clan-cli`](https://docs.clan.lol/main/) Command-line interface for Clan.lol
-   [`hcloud`](https://github.com/hetznercloud/cli) Command-line interface for Hetzner Cloud
-   [`lazyhetzner`](https://github.com/grammeaway/lazyhetzner) TUI for managing Hetzner Cloud resources
-   [`rke2_1_35`](https://github.com/rancher/rke2) Rancher Kubernetes Engine (RKE2)
-   [`kubectl`](https://github.com/kubernetes/kubectl) Kubernetes CLI
-   [`kubernetes-helm`](https://github.com/helm/helm) Package manager for kubernetes
-   [`argocd`](https://argo-cd.readthedocs.io/en/stable/) GitOps for Kubernetes
-   [`kubeseal`](https://github.com/bitnami-labs/sealed-secrets) Kubernetes controller and tool for one-way encrypted Secrets
-   [`k9s`](https://github.com/derailed/k9s) Kubernetes CLI To Manage Your Clusters In Style
-   [`kubefetch`](https://github.com/andrewthomaslee/kubefetch) Neofetch-like tool to show info about your Kubernetes Cluster
-   [`tailscale`](https://tailscale.com/) Tailscale VPN client



# First Time Setup 🔧
*If you are coming to this project to join an existing repo, you can skip this section. ie my team at [`netsam.com`](https://netsam.com/).*

### 1. Generate the secrets 🔑
Generate an age key pair and place it at `$SOPS_AGE_KEY_FILE` then change the public key in `infra.json` and add your user to the [secrets backend](https://docs.clan.lol/main/guides/vars/sops/secrets/):
```bash
nix run .#sops-add-user
```


Generate all the secrets for the infrastructure:
```bash
clan vars generate mng-0

clan vars generate wrk-0

clan vars generate docker
```


Ensure the ssh key pair is generated and placed in your user's home directory at `~/.ssh/industrial-host` and `~/.ssh/industrial-host.pub`
```bash
clan vars get mng-0 industrial-host/ssh-key > ~/.ssh/industrial-host
clan vars get mng-0 industrial-host/ssh-key.pub > ~/.ssh/industrial-host.pub
```

### 2. Deploy the cluster 🚀
To deploy a machine all it takes is two commands:
```bash
clan machines init-hardware-config <machine-name> --target-host <machine-ip>

clan machines install <machine-name> --target-host <machine-ip>
```
To update a machine:
```bash
clan machines update <machine-name>
```


Deploy the machine `mng-0` before deploying the other kubernetes machines.


Once `mng-0` is deployed, run the following commands to fetch the **Join Token** and the **kubeconfig**:
```bash
nix run .#get-token

nix run .#get-config
```
Make sure the var `rke2/token` matches.
```bash
clan vars get wrk-0 rke2/token
```


Adding a new type of machine to the cluster is as simple as adding a *public IPv6* and *private IPv4* address to the `networking.public` and `networking.private` objects in `infra.json` and deploying the new machine with [`Clan`](https://docs.clan.lol/main/). Make sure to follow the naming convention for the machine type. ie `mng-<int>`, `wrk-<int>`, `docker` and `proxy`.


Most of the time only the `infra.json` file needs to be changed to re-define the cluster.


# Joining an Existing Repository ➕
Ensure the ssh key pair is placed in your user's home directory at `~/.ssh/industrial-host` and `~/.ssh/industrial-host.pub`


To fetch the secrets and config files from the storagebox run:
```bash
nix run .#setup-env
```



## Cluster Access 💻
#### 1. Enter the devShell 📥
This will set up the environment variables for the cluster you are accessing.
```bash
nix develop
```

#### 2. Environment Setup 🔧
Ensure you have placed the ssh key in `~/.ssh/industrial-host`. Keep this secret. Anyone with access to this key can access the cluster.
```bash
nix run .#setup-env
```

#### 3. Access the Cluster ☸️
Check the status of the `Tailscale` VPN connection:
```bash
tailscale status
```

`KUBECONFIG` environment variable is set automatically.
Run `kubectl` commands to interact with the cluster:

```bash
kubectl get nodes

kubectl get pods -A

kubefetch
```

## Cluster Management 🛠️

[`k9s`](https://github.com/derailed/k9s) is your swiss army knife for kubernetes clusters.

Watch this short video tutorial: [K8s Made Easy: Manage Your Clusters with the k9s Terminal UI](https://youtu.be/xDarAnuvxU4?si=YNuqPGVRpDcgv6Tx)
```bash
k9s
```




## 🚢Dockhand
[`Dockhand`](https://dockhand.pro/) is a powerful, intuitive Docker management platform.


![Dockhand](https://dockhand.pro/images/dashboard1.webp)


Dockhand has [Git Integration](https://dockhand.pro/manual/#stacks-git) for **GitOps** and an API for **CI/CD** + **Automated Deployments**.


Hosting Dockhand next to Kubernetes allows for a seamless transition from **Local Development** to **Docker Dev Environment** to **Kubernetes Prod Environment**. Or any other combination of environments. Heck! Deploy **Prod** to Dockhand! 🤷 🚀


See my guide for 👉 [GitOps with Dockhand and ArgoCD](https://github.com/andrewthomaslee/gitops-tutorial-for-docker-and-kubernetes.git).

## TSDProxy 🌐
[`TSDProxy`](https://github.com/almeidapaulopt/tsdproxy) is a reverse proxy that automatically adds docker containers to the Tailscale network.


Simply add a container label `"tsdproxy.enable=true"`. 


This will add the container as a machine to the Tailscale network. Making an address like `<container_name>.armadillo-frog.ts.net` available to users on the Tailscale network with **https** for no browser warnings.
