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
- [ ] Create deployment definitions
- [X] Create deployment environment
- [ ] Deploy!
- [ ] Deploy per PR!

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
