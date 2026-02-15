+++
date = '2026-02-15T10:12:17-06:00'
draft = false
title = 'GitOps Tutorial for 🐋Docker and Kubernetes☸️'
summary = "A basic example showing how to develop applications locally and deploy with GitOps using 🚢Dockhand and ArgoCD🐙"
+++

GitHub Repo 👉 [gitops-tutorial-for-docker-and-kubernetes](https://github.com/andrewthomaslee/gitops-tutorial-for-docker-and-kubernetes.git)


# GitOps Tutorial for 🐋Docker and Kubernetes☸️
This is a basic example showing the use of docker compose to run applications locally and how to deploy applications to a remote server using [`GitOps`](https://about.gitlab.com/topics/gitops/), ie a docker host using 🚢[`Dockhand`](https://dockhand.pro/manual/) and a kubernetes cluster using 🐙[`ArgoCD`](https://argo-cd.readthedocs.io/en/stable/).



To get started fork this repo and replace the domain `andrewlee.cloud` with your own domain.



#### Prerequisites
- `Docker` installed locally
- `Domain` records pointing to the servers' IP address

#### Assumptions
- `Dockhand` host has [`Traefik`](https://doc.traefik.io/traefik/getting-started/install-traefik/) configured to listen for container labels on the network `proxy` and a `certresolver` called `letsencrypt`.
- `ArgoCD` host has [`Traefik`](https://doc.traefik.io/traefik/getting-started/install-traefik/) ingress controller and [`Cert-Manager`](https://cert-manager.io/) installed.





## Local 🧑‍💻
To start the whoami-example on your local machine run:
```bash
docker compose -f ./docker/compose.yaml -f ./docker/compose.local.yaml up
```
This will merge the two files and expose the port 8888 on localhost.

![whoami-local](whoami-local.avif)

To stop the whoami-example use `Ctrl+C` and run:
```bash
docker compose -f ./docker/compose.yaml -f ./docker/compose.local.yaml down
```

![whoami-local-down](whoami-local-down.avif)

## Dockhand 🚢
[`Dockhand`](https://dockhand.pro/manual/) is a modern, powerful Docker management platform with a focus on simplicity and ease of use. It allows you to manage and monitor Docker infrastructure from a single interface. With Git integration, you can easily deploy applications from Git repositories.

#### Credentials 🔑
Go to `Settings` > `Git`. To deploy the whoami-example to Dockhand first add a deploy key in GitHub then add it to Dockhand credentials. SSH keys and GitHub Tokens are supported.

![Credentials](Dockhand-Git-Credentials.avif)

#### Git Repo 📂
Add the repo to Dockhand using the correct branch and url. SSH keys url looks like `git@github.com:andrewthomaslee/whoami-example.git`. GitHub Tokens url looks like `https://github.com/andrewthomaslee/whoami-example.git`.

![GitRepo](Dockhand-Git-Repositories.avif)

#### Deploy 🚀
Go to `Stacks` > `From Git`. Select the repo you just added and the branch you want to deploy and the path to the `compose.yaml` file. Toggle `Deploy Now` and click `Deploy`.

![Deploy](Dockhand-Deploy-Stacks.avif)

The `compose.yaml` file is merged with the `compose.override.yaml` file to generate the production deployment.

#### View 🔍
Once deployed you can view the logs and the application by clicking the `Inspect Container` button.

![View](Dockhand-Live-Stacks.avif)


#### Refresh ♻️
When changes are made to the `compose.yaml` files the application will automatically be refreshed on a timer if enabled. To manually sync the changes use the `Sync from Git` button.

![Sync](Dockhand-Git-Sync.avif)

![Synced](Dockhand-Git-Synced.avif)

## ArgoCD 🐙
[`ArgoCD`](https://argo-cd.readthedocs.io/en/stable/) is a declarative, `GitOps` continuous delivery tool for Kubernetes. It follows the `GitOps` pattern of using Git repositories as the source of truth for defining the desired state of the application.

#### Credentials 🔑
Go to `Settings` > `Connect Repo`. Add the deploy key from GitHub to the `whoami-example` repo. SSH keys and GitHub Tokens are supported.

![Credentials](ArgoCD-Git-Credentials.avif)

Enusre the credentials are added successfully and can connect to the repo.

![Credentials-Successful](ArgoCD-Git-Credentials-Successful.avif)

#### Deploy 🚀
Go to `Applications` > `New App`. Fill in the details for how the application will be deployed.

![Create](ArgoCD-Application-General.avif)

Fill in the details for the source and destination.

![Source](ArgoCD-Application-Source.avif)

Press `Create` and the application will be deployed.

#### View 🔍
Once created you can view the application in the `Applications` tab.

![View](ArgoCD-Application-Tile.avif)

Click the application tile to view the application's created objects. 

![View](ArgoCD-Application-Objects.avif)

This application's manifest has 4 objects:
- `Issuer`: issues TLS certificates
- `Deployment`: runs the whoami container
- `Service`: exposes the deployment to the cluster
- `Ingress`: comsumes TLS certificate and exposes the service to the internet

The `Deployment` object creates a `ReplicaSet` and `Pod`.
The `Ingress` object creates a `Certificate` and `Secret`.

#### Make a Change ♻️
In the repo's `kubernetes/whoami.yaml` file use `Ctrl+F` to search for `8888` and replace it with `8080` and push the changes. This simply changes the port the application listens on. In the ArgoCD wait for the sync to happen automatically or press the `Refresh` button to sync the changes.


The old `Pod` will be terminated once the new `Pod` is deployed.

![Syncing](ArgoCD-Syncing.avif)

Since a change was made to the `Deployment` object a new `ReplicaSet` will be created.

![Synced](ArgoCD-Synced.avif)


#### Rollback 🔙
To rollback to the previous version of the `Deployment` object use the `History and Rollback` button.

![History](ArgoCD-History.avif)

Rolling back will use the old `ReplicaSet` and take the application off auto-sync and will require a manual sync to be triggered to re-enable auto-sync.

![Rollback](ArgoCD-Rollback.avif)

#### Delete 🗑️
To delete the application use the `Delete` button. This will delete all the objects created by the application.

![Delete](ArgoCD-delete.avif)


# Conclusion 🎉
This tutorial demonstrated how to use the `GitOps` pattern to deploy applications to a docker host and a kubernetes cluster! Congratulations on making it this far! 🎉