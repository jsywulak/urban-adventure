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

tl;dr `make prereqs bootstrap all destroy` and then go run some errands because it is going to take a while.

Everything is controlled via `make` commands. 

**Do you have everything you need installed?**
```
make prereqs
```
Will print out any missing prerequisites you need.

**Bootstrap for first run**
```
make bootstrap
```
Will set up CDK and set the region and account number everywhere its needed. It will also create the ECR repo.

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
make att       # simple test that calls the endpoint
make destroy   # cleans up everything
```

**Run everything**
```
make all
```

This will do most everything above, skipping the local integration test. 

**Clean up**
```
make clean
```
This will nuke all your local images, so you may not want to run it. 

### Directory structure

What goes where why

```
\
|- bin              # where compiled go binary lives
|- deploy           # where the k8s yaml lives
|- infra            # where the CDK configuration lives
|- integration_test # where the single integration test lives
\- scripts          # where everything too complicated to go into the Makefile lives

```


### What I'd Do Differently
Despite the `prereqs` section being as long as it is, I did _try_ to limit the amount of tools I used. In a real project, I would've opted for something like Helm to handle the deployments to the Kubernetes cluster, and some sort of testing tool more advanced that bash script to handle the integration testing. 

The testing can be particularly improved; right now it's just testing "does the endpoint work" which does mean everything else is working too, but if the endpoint _wasn't_ working, it doesn't help you figure out why. Tests for the actual AWS resources (perhaps using awspec or similar) would confirm that everything is wired togetherly correctly, and then perhaps some tests to confirm that the k8s deployments are configured correctly would be very helpful. 

That also included not building a deployment pipeline either, which gives me the heebie jeebies. I tried to break the `make` targets down so that they'd be easy to translate into a pipeline if one is desired at a later date.

This project used the [AWS CDK EKS Blueprints](https://aws-quickstart.github.io/cdk-eks-blueprints/), a quick start for running EKS in AWS with CDK. While the EKS Blueprints gave me an EKS cluster and everything else necessary very easily, it also gave me the better part of a gig of node dependencies and was very much a black box. Fortunately, I did not need to do a lot of tweaking of the cluster, but I am not sure I'd use in a production situation. Unfortunately, it sometimes had a hard time cleaning up the stack resources, which I did end up doing quite a few times.

To make this "one click" I do a search and replace to insert the region and account ID where it's needed. This was a pain to set up and maintain, but since it was in the yaml files as well I couldn't just make in an environment var. This probably wouldn't have been as big of an issue in a production environment, since we could more reliably assume where the ECR repo would live. 

### Gotchas
* The EKS Blueprints include a bunch of custom cloudformation resources to install stuff into the k8s cluster. These take forever to delete (somehow even longer than provisioning!)
* The project relies on the CDK, which needs some base infrastructure in every region. The `bootstrap` command creates it if it does not exist, but since you might want it there for other projects, the Makefile does not clean it up. If you don't want those resources to continue to exist, you'll need to delete the Cloudformation stacks manually. 
