# Assessment

These are the steps I took to complete this assessment. I will continue to update
this document with justifications and alterations as I proceed.

## Steps

- [X] Create this readme
- [X] Update branch protections
- [X] Add basic repo setup
- [ ] Add GHA linting
- [ ] Add GHA tests
- [ ] Add GHA build
- [ ] Add GHA artifact shipping
- [ ] Create deployment definitions
- [ ] Create deployment environment
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

