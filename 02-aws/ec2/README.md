# Amazon EC2 (Elastic Compute Cloud)

## Objective

The objective of this module is to understand Amazon EC2, learn how to launch and manage virtual servers in AWS, and perform basic hands-on exercises.

---

# What is Amazon EC2?

Amazon EC2 (Elastic Compute Cloud) is an AWS service that provides virtual servers in the cloud. It allows users to launch, configure, manage, and terminate virtual machines on demand without purchasing physical hardware.

---

# Why EC2?

* Create virtual servers within minutes.
* Pay only for the resources you use.
* Easily increase or decrease server capacity.
* Host applications, websites, APIs, and databases.
* Secure instances using Security Groups and IAM.

---

# Key Concepts

## Instance

A virtual machine running in AWS.

Example:

* Ubuntu Server
* Amazon Linux
* Windows Server

---

## Amazon Machine Image (AMI)

An AMI is a template used to launch an EC2 instance.

It contains:

* Operating System
* Installed Software
* Configuration
* Storage Information

Example:

* Ubuntu 24.04 LTS
* Amazon Linux 2023
* Windows Server 2022

---

## Instance Types

Instance types define the CPU, memory, storage, and network performance of an EC2 instance.

Examples:

* t2.micro
* t3.micro
* t3.small
* m5.large

For AWS Free Tier, **t2.micro** or **t3.micro** is commonly used (depending on the account).

---

## Key Pair

A Key Pair is used to securely connect to an EC2 instance.

It consists of:

* Public Key (stored by AWS)
* Private Key (.pem or .ppk) (downloaded by the user)

Never share your private key.

---

## Security Group

A Security Group acts as a virtual firewall for an EC2 instance.

Common inbound rules:

* SSH (22)
* HTTP (80)
* HTTPS (443)

---

## Elastic IP

An Elastic IP is a static public IP address that can be associated with an EC2 instance.

---

## EBS (Elastic Block Store)

EBS provides persistent storage for EC2 instances.

Data stored in EBS remains available even after the instance is stopped.

---

# Hands-on Exercises

## Exercise 1

Login to the AWS Management Console.

---

## Exercise 2

Navigate to the EC2 Dashboard.

---

## Exercise 3

Launch a new EC2 instance.

* Name the instance.
* Select Ubuntu Server AMI.
* Choose a Free Tier eligible instance type.
* Create or select an existing Key Pair.
* Configure the Security Group.
* Launch the instance.

---

## Exercise 4

Verify that the instance reaches the **Running** state.

---

## Exercise 5

Connect to the EC2 instance using SSH.

Example:

```bash
ssh -i my-key.pem ubuntu@<public-ip-address>
```

---

## Exercise 6

Run basic Linux commands.

```bash
pwd
ls
mkdir devops
touch notes.txt
```

---

## Exercise 7

Update the system.

```bash
sudo apt update
sudo apt upgrade -y
```

---

## Exercise 8

Stop the EC2 instance.

---

## Exercise 9

Start the EC2 instance again.

---

## Exercise 10

Terminate the EC2 instance.

---

# Learning Outcome

After completing this module, I am able to:

* Understand the purpose of Amazon EC2.
* Launch an EC2 instance.
* Select an appropriate AMI and instance type.
* Create and use a Key Pair.
* Configure Security Groups.
* Connect to an EC2 instance using SSH.
* Perform basic Linux administration on an EC2 instance.
* Stop, start, and terminate EC2 instances.

---
