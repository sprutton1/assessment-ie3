# Assessment

These are the steps I took to complete this assessment. I will continue to update
this document with justifications and alterations as I proceed.

## Steps

- [X] Create this readme
- [X] Update branch protections
- [X] Add basic repo setup
- [X] Add GHA linting
- [X] Add GHA tests
- [X] Add GHA build
- [X] Add GHA artifact shipping
- [X] Create deployment definitions
- [X] Create deployment environment
- [X] Deploy!
- [X] Deploy per PR!

- [ ] Bonus: Security Scans (somewhere a DevSecOps engineer is crying out in pain because this is a bonus)
- [ ] Bonus: Dependabot 

### Branch Protections

Basic protections to ensure there are no accidental pushes over `main`. In the real world I would
include more specific restrictions, but I don't want to block myself out from being able to merge PRs.
This is a great place to include checks for various pipeline tests once we have some.

### Basic Repo Setup

This is what I would consider the very basic not-project-specific tooling for a repo. This includes:

- Linting to ensure conventional commits are followed in PRs
  - I prefer squashing commits into the PR, so this helps the history stay clean and enables release tooling
- CODEOWNERS file so we know who the primary reviewers are 
  - This can be broken down into specific parts of the repo if necessary
- PR Template for consistency in PRs 
  - It's helpful for everyone to know the expectations when opening a PR, especially cross-team

### Add linters

I started using Earthly here. If you aren't familiar it's basically a handy little docker-like kit
for running self-contained workloads. Great for CI and local development so you can ensure you are running
the same things in both places. As they say, Dockerfile and Makefile had a baby.

Speaking of Makefile, I used a Taskfile here. It's very similar to Make, but with a modern, comfortable syntax.
I find it an easy alternative to Make. I wrap my CI functions with Task and also include developer convenience 
scripts (`task lint`) to run all of the linters at once in Earthly.

I create two GHA workflows, one for each lint. Each one only runs against the files specific to the directories
being changed. I tend to run linters separately from tests as you can still get good feedback from test failures
and linting failures separately. This also lets the tests start as soon as possible.

### Add tests

Pretty simple, we just extrend what we did before with linters to add a workflow for tests. I also refactored
the earthfiles so the bits can be more reusable.

### The build

Just continuing along here, adding `npm build` to our setup. Included tasks to run both builds simultaneously. I changed
the backend test workflow to better reflect that it is CI now as we test and build. Made a separate build for frontend
even though there are no tests (shame).

### Pushing images

I chose Dockerhub as my artifact store as I happen to have an account there. I also changed the images to point at my
user so I can push images. The pipelines just push over the latest image. If I have time, we'll do this with proper
versioning, but it didn't seem super salient at the moment.

### Deployment Environment 

I chose to use EKS here, mainly because I have a lot of familiarity with the platform and new I could get it up and running 
without much trouble. In all honesty, it's overkill for just running two containers, but who knows what kind of complicated
deployment architecture Taskly might have in the future? It also doesn't quite follow the "use free services" part of the 
assessment, but it's not much to add to my existing AWS bill. 

In order to create this environment, I included some Terraform modules and a pipeline to validate and deploy them. I think 
that using something like CDK to use Typescript may be a better fit in this project overall, and I will likely switch to that
if I have time. I wanted to start here to get the environment created so I could improve it later.

In the real world, I would likely not include these resources in this repo. This environment is likely to be fairly static
and potentially shared across many teams. It would be better in a separate repo, but I wanted to include it for demonstrative
purposes.

The environment includes EKS and some fancy add-ons for automatically creating load balancers and Route53 records from 
Kubernetes ingresses.

### Deploy

I created a Helm chart for our deployments and the related resources. Nothing too fancy here, but I left things generic so I
could make multiples of the deployment so we could support many instances.

Onto actually deploying the stack. This is definitely where I spent the most time. I don't have a ton of experience with 
vue/vite, so I had to do some learning to understand the deployment patterns. The backend was easy, but I had trouble getting
the frontend to play nice with talking to the backend. I tried http-server with no luck (once deployed in K8s). I started to 
use NGINX, did some research first and found Caddy, a pretty minimal webserver. It was so simple, I think I'll end up using 
this in some of my personal projects.

I also combined the separate CI processes here, just to make it easier to orchestrate the deployment. If I had more time I
could make something a little more complicated that doesn't require this. 

I caught a lot of issues from earlier PRs I had to fix to make the deployments actually work. An artifact of trying to move
quickly. Adding all of this CI helps with confidence, though. 

I wanted to make sure that Taskly developers could make PRs and validate changes in a strightforward manner, so each PR deploys
a discrete instance of Taskly. A nentry is automatically created in the ALB and, once it is ready, a comment is posted to the PR
with the URL so changes can be validated.

Note that in some cases it can take a few minutes for the PR environment to become responsive, mostly due to ALB registration 
timing. Even if the frontend is responsive, the backend may not be immediately. Give it a couple minutes.

### Things missing

Time constraints lead me towards using the tools I was most familiar with, not necessarily the best tools for the job.
There is a lot here I would change or improve given more time. Highlights include:

* Switching from Terraform to CDK to better align with the rest of the project. I didn't start here as I knew I could get 
the Terraform together very quickly
* PR environment create is real slow, mostly due to waiting for things like Fargate, the ALB, and DNS propagation. There 
are plenty of ways to make this faster (nodes already existing in EKS, not using ALBs, etc.)
* Including Security Scanning, Code Quality, Dependabot and other checks in the pipeline. These things are often shipped 
off to 3rd party tools and I didn't have any handy to integrate with 
* Build time could be improved. Caching could be added and the workflow could be more optimal
* Versioning isn't implemented, so automated deployments are somehwat clunky. This is easily addressed by including semantic 
versioning
* There's a ton of opportunity for work around the local dev experience. Earthly is great for this and could be extended to 
allow for all kinds of interesting tooling niceties. Using tools like MiniK8s or Kind, we could create on-the-fly deployment 
environments, too
