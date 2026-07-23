# DevOps Learning Roadmap

A structured, self-paced journey toward **DevOps job/interview readiness**, built on a foundation of Linux fundamentals and hands-on AWS exploration. Each module includes console/CLI walkthroughs and exercises grounded in real projects where possible.

---

## Overall Learning Path

```
Linux Fundamentals
        ↓
AWS Deep Dive (core services + scaling + serverless + messaging)
        ↓
Git & GitHub Workflows
        ↓
CI/CD Pipelines (GitHub Actions / Jenkins)
        ↓
Containers (Docker)
        ↓
Container Orchestration (Kubernetes)
        ↓
Infrastructure as Code (Terraform / CloudFormation)
        ↓
Capstone / Portfolio Project
```

---

## Progress Tracker

### ✅ Phase 1: Linux Fundamentals (Completed)

| Module | Status | Topics |
|--------|--------|--------|
| `01-linux/day-1-linux-basics/` | ✅ Done | Filesystem navigation, pwd/ls/cd/mkdir/cp/mv/rm |
| `01-linux/day-2-users-groups/` | ✅ Done | Users, groups, sudoers, permissions |
| `01-linux/day-3-processes-services/` | ✅ Done | Process management, systemd, service control |
| `01-linux/day-4-networking/` | ✅ Done | IP configuration, DNS, curl/wget, packet inspection |
| `01-linux/day-5-bash-scripting/` | ✅ Done | Variables, loops, functions, error handling |

### ✅ Phase 2a: AWS Core Services (Completed)

| Module | Status | Topics | Interview Weight |
|--------|--------|--------|-------------------|
| `02-aws/ec2/` | ✅ Done | Instances, AMIs, instance types, key pairs, security groups, EBS, elastic IP | ⭐⭐⭐ High |
| `02-aws/iam/` | ✅ Done | Users, groups, policies, roles, MFA, least privilege | ⭐⭐⭐ High |
| `02-aws/s3/` | ✅ Done | Buckets, objects, versioning, storage classes, lifecycle, pre-signed URLs | ⭐⭐⭐ High |
| `02-aws/vpc/` | ✅ Done | CIDR, subnets, IGW, route tables, NAT, security groups vs NACLs | ⭐⭐⭐ High |
| `02-aws/cloudwatch/` | ✅ Done | Metrics, logs, alarms, dashboards, EventBridge | ⭐⭐ Medium |
| `02-aws/rds/` | ✅ Done | DB instances, engines, backups, Multi-AZ, read replicas | ⭐⭐ Medium |
| `02-aws/route53/` | ✅ Done | Hosted zones, DNS records, routing policies, health checks | ⭐⭐ Medium |
| `02-aws/ses/` | ✅ Done | Verified identities, sandbox vs production, domain identity | ⭐ Low |

### 🔄 Phase 2b: AWS Advanced Services (In Progress)

| Module | Status | Topics | Interview Weight | Notes |
|--------|--------|--------|-------------------|-------|
| `02-aws/elastic-load-balancing-autoscaling/` | ⏳ Todo | ALB/NLB/CLB, target groups, autoscaling policies, launch configs | ⭐⭐⭐ High | Pairs with EC2; heavily asked |
| `02-aws/lambda/` | ⏳ Todo | Serverless, event triggers, IAM roles, layers, concurrency | ⭐⭐⭐ High | Modern DevOps essential |
| `02-aws/systems-manager/` | ⏳ Todo | Parameter Store, Secrets Manager, config management | ⭐⭐ Medium | Security best practice |
| `02-aws/messaging/` | ⏳ Todo | SNS, SQS, message decoupling, FIFO queues | ⭐⭐ Medium | Pairs with CloudWatch |
| `02-aws/ecr-ecs/` | ⏳ Todo | ECR registry, ECS task definitions, services, Fargate | ⭐⭐⭐ High | Bridge to Docker/Kubernetes |
| `02-aws/cloudfront-cdn/` | ⏳ Todo | CDN, distributions, origins, caching, invalidation | ⭐⭐ Medium | + hands-on Route 53 refresh |
| `02-aws/billing-cost/` | ⏳ Todo | Cost Explorer, budgets, Reserved Instances, Trusted Advisor | ⭐⭐ Medium | Often skipped, commonly asked |

### ⏸️ Phase 3: Git & Version Control (Planned)

| Module | Status | Topics | Notes |
|--------|--------|--------|-------|
| `03-git/` | ⏳ Not started | GitHub workflows, branching, PRs, collaboration | Prerequisite for CI/CD |

### ⏸️ Phase 4: CI/CD Pipelines (Planned)

| Module | Status | Topics | Notes |
|--------|--------|--------|-------|
| `04-cicd/` | ⏳ Not started | GitHub Actions, Jenkins, artifact management, deployment | Pairs with Git |

### ⏸️ Phase 5: Containers (Planned)

| Module | Status | Topics | Notes |
|--------|--------|--------|-------|
| `05-docker/` | ⏳ Not started | Images, containers, Dockerfile, registries, networking | Foundation for K8s |

### ⏸️ Phase 6: Orchestration (Planned)

| Module | Status | Topics | Notes |
|--------|--------|--------|-------|
| `06-kubernetes/` | ⏳ Not started | Pods, deployments, services, namespaces, helm | Modern cluster management |

### 🔄 Phase 7: Infrastructure as Code (Started Early)

| Module | Status | Topics | Notes |
|--------|--------|--------|-------|
| `02-aws/s3/terraform/` | 🚀 In Progress | Terraform import, state, modules, AWS provider, security best practices | Real ticket from your reviewer; first step toward 3-tier architecture |
| `07-terraform/` | ⏳ Planned | HCL, remote state, modules, workspaces | Full deep dive after S3 hands-on |
| `07-cloudformation/` | ⏳ Not started | Templates, stacks, change sets | AWS-native IaC |

### ⏸️ Phase 8: Capstone Project (Planned)

| Project | Status | Scope | Notes |
|---------|--------|-------|-------|
| Portfolio DevOps Project | ⏳ Not started | End-to-end: Git → CI/CD → Container → Deploy to AWS | Demonstrates all phases |

---

## How to Use This Roadmap

1. **Work module-by-module**, in order. Each module includes:
   - Objective and learning outcomes
   - Key topics and AWS console/CLI walkthroughs
   - Hands-on exercises (performed in your AWS account)
   - Real-world ties to the **Inspect Lens** project where relevant

2. **Mark progress** by checking off items as you complete hands-on exercises and document them.

3. **Interview prep**: The "Interview Weight" column highlights topics that come up frequently in DevOps interview loops — prioritize these for review.

4. **Flex as needed**: This roadmap is a guide, not a straitjacket. If you find a topic needs more depth, take the time. If you want to skip ahead or reorder, let your mentor know.

---

## Current Focus

**Current Module:** Terraform S3 Import (Real ticket from your reviewer)  
**Why:** A real-world infra-as-code task: bring your existing S3 bucket under Terraform management, applying security best practices (versioning, encryption, public-access blocking). This is the first concrete step toward the 3-tier architecture your reviewer proposed.  
**What You'll Do:** 
1. Set up AWS CLI profiles for secure credential management.
2. Use `terraform import` to sync your existing S3 bucket with Terraform state.
3. Write modular, reusable Terraform config following the 3-tier pattern.
4. Learn the `terraform init` → `import` → `plan` → `apply` workflow.

**Interview Relevance:** High — IaC is table stakes for DevOps roles. Expect questions like "How do you manage drift?" and "Why use modules?"  
**After this:** Continue with ELB/Auto Scaling if you want more AWS console work, or dive deeper into Terraform/CI-CD if you prefer to consolidate this momentum.

---

## Notes

- All modules follow a consistent template: Objective → Topics Covered → Commands/Console Steps → Hands-on Exercises → Learning Outcome.
- Exercises are performed **in your AWS account** (or local environment for Linux/Git/Docker). I'll guide you through each step as your mentor, but you execute them.
- Some modules reference the **Inspect Lens** project (a PDF quotation/agreement generator app) to ground learning in real use cases.
- Free-tier AWS services are prioritized; costs are minimized where possible.

---

## Session Log

**Session 1 (Today):**
- Set up root roadmap with 8-phase learning path.
- Decided to tackle a real ticket from your reviewer: Terraform S3 import.
- Created Terraform module structure and 9 hands-on exercises (AWS CLI profile setup, import, plan, apply, verify).

## Last Updated
Date: 2026-07-21
