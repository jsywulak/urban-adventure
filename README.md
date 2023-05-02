# all the things

This is the sample project for my interview at **[REDACTED]**. It builds an AWS EKS cluster and then deploys a simple go app to it. 

### Prereqs
You're going to need a _few_ things installed and configured to make this work. This was all tested on an OSX laptop running zsh; running it on other OSes might work but no promises. 🙃

* [AWS CLI](https://aws.amazon.com/cli/), with `aws configure` run to point it at the account and region you'd like to test with.
* [AWS CDK](https://aws.amazon.com/cdk/), but the Makefile will handle bootstrapping for the region you're in.
* [jq](https://stedolan.github.io/jq/) is used by some of the scripts to parse json output
* [docker](https://www.docker.com/), or some other container runtime, but I only tested with Docker.
* [kubectl](https://kubernetes.io/docs/tasks/tools/#kubectl) to handle deploying to the cluster
* [go](https://go.dev/doc/install), though you could remove the `go` commands from the `build` target and everything would _probably_ still work.


### How to run it

tl;dr `make all` and then go run some errands because it is going to take a while.

Everything is controlled via `make` commands. 

**Do you have everything you need installed?**
```
make prereqs
```
Will print out any missing prerequisites you need.

**Build and run locally**
```
make build
make local
```
You can then `curl localhost:8080` and see the program run.

**Integration test**
```
make test
```
This will start the container, run the integration test against it, and then kill the container.

**Set up Kubernetes cluster and deploy it there**
```
make up        # standup the cloud resources, including the EKS cluster
make login     # login to the ECR repo
make apply     # deploys the container and assisting services to the EKS cluster
make att       # calls the endpoint
make destroy   # cleans up everything
```

**Run everything**
```
make all
```

This will do most everything above, skipping the local integration test. 

### Directory structure

What goes where why

```
\
|- bin              # where compiled go binary lives
|- deploy           # where the k8s yaml lives
|- infra            # where the CDK configuration lives
|- integration_test # where the single integration test lives
|- scripts          # where everything too complicated to go into the Makefile lives

```


### What I'd Do Differently
Despite the `prereqs` section being as long as it is, I did _try_ to limit the amount of tools I used. In a real project, I would've opted for something like Helm to handle the deployments to the Kubernetes cluster, and some sort of testing tool more advanced that bash script to handle the integration testing. 

That also included not building a deployment pipeline either, which gives me the heebie jeebies. I tried to break the `make` targets down so that they'd be easy to translate into a pipeline if one is desired at a later date.

This project used the [AWS CDK EKS Blueprints](https://aws-quickstart.github.io/cdk-eks-blueprints/), a quick start for running EKS in AWS with CDK. While the EKS Blueprints gave me an EKS cluster and everything else necessary very easily, it also gave me the better part of a gig of node dependencies and was very much a black box. Fortunately, I did not need to do a lot of tweaking of the cluster, but I am not sure I'd use in a production situation. Unfortunately, it sometimes had a hard time cleaning up the stack resources, which I did end up doing quite a few times.

