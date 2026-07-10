# AWS VPC (Virtual Private Cloud)

## Objective

The objective of this module is to understand Amazon Virtual Private Cloud (VPC), learn how AWS networking works, and perform hands-on exercises to create a secure network for AWS resources.

---

# What is Amazon VPC?

Amazon VPC (Virtual Private Cloud) is a service that allows you to create your own private network inside AWS.

You can launch AWS resources such as EC2 instances within your VPC and control how they communicate with each other and with the internet.

---

# Why VPC?

Amazon VPC helps you:

* Create an isolated network in AWS.
* Control inbound and outbound traffic.
* Improve security.
* Organize applications into public and private networks.
* Connect AWS resources securely.

---

# Key Concepts

## CIDR Block

A CIDR block defines the IP address range for your VPC.

Example:

* 10.0.0.0/16
* 192.168.0.0/16

---

## Subnet

A Subnet is a smaller network inside a VPC.

Types:

* Public Subnet
* Private Subnet

Example:

VPC:

10.0.0.0/16

Public Subnet:

10.0.1.0/24

Private Subnet:

10.0.2.0/24

---

## Internet Gateway (IGW)

An Internet Gateway allows resources in a public subnet to communicate with the internet.

Without an Internet Gateway, EC2 instances cannot access the internet.

---

## Route Table

A Route Table contains rules that determine where network traffic should go.

Example:

Destination:

0.0.0.0/0

Target:

Internet Gateway

This route allows internet access.

---

## Public Subnet

A subnet connected to an Internet Gateway through a Route Table.

Example:

* Web Server
* Bastion Host

---

## Private Subnet

A subnet without direct internet access.

Example:

* Database Server
* Internal Application Server

---

## NAT Gateway

A NAT Gateway allows instances in a private subnet to access the internet for updates without allowing inbound internet access.

---

## Security Group

A Security Group acts as a virtual firewall for an EC2 instance.

It controls:

* Inbound traffic
* Outbound traffic

---

## Network ACL (NACL)

A Network ACL provides security at the subnet level.

It controls traffic entering and leaving an entire subnet.

---

# Hands-on Exercises

## Exercise 1

Open the AWS Management Console.

---

## Exercise 2

Navigate to the VPC Dashboard.

---

## Exercise 3

Create a new VPC.

Example:

* Name: DevOps-VPC
* CIDR: 10.0.0.0/16

---

## Exercise 4

Create a Public Subnet.

Example:

* Name: Public-Subnet
* CIDR: 10.0.1.0/24

---

## Exercise 5

Create a Private Subnet.

Example:

* Name: Private-Subnet
* CIDR: 10.0.2.0/24

---

## Exercise 6

Create an Internet Gateway.

Attach it to the VPC.

---

## Exercise 7

Create a Route Table.

Associate it with the Public Subnet.

Add the following route:

Destination:

0.0.0.0/0

Target:

Internet Gateway

---

## Exercise 8

Launch an EC2 instance inside the Public Subnet.

Verify that it has internet connectivity.

---

## Exercise 9

Explore the default Network ACL.

Understand how it controls subnet-level traffic.

---

## Exercise 10

Delete the test resources after completing the exercises to avoid unnecessary charges.

---

# Real-Time Project Usage (Inspect Lens)

In the Inspect Lens project, the backend application may be deployed on an EC2 instance inside a VPC.

Example architecture:

* EC2 runs the backend API.
* Amazon S3 stores generated PDF files.
* The backend communicates with S3 over AWS networking.
* Security Groups control access to the backend.
* Public-facing resources are placed in a Public Subnet, while databases are typically placed in a Private Subnet.

---

# Learning Outcome

After completing this module, I am able to:

* Understand Amazon VPC fundamentals.
* Create a VPC and Subnets.
* Configure Internet Gateway and Route Tables.
* Understand Public and Private Subnets.
* Explain the purpose of NAT Gateway.
* Differentiate between Security Groups and Network ACLs.
* Describe how AWS networking supports secure application deployment.

---
