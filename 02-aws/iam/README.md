# AWS IAM (Identity and Access Management)

## Objective

The objective of this module is to understand AWS Identity and Access Management (IAM), learn how to securely manage users, groups, roles, and permissions, and perform hands-on exercises following AWS security best practices.

---

# What is IAM?

AWS Identity and Access Management (IAM) is a service that helps you securely control access to AWS resources.

Using IAM, you can decide:

* Who can access AWS.
* Which AWS services they can use.
* What actions they are allowed to perform.
* Which resources they can access.

---

# Why IAM?

IAM helps improve security by:

* Creating separate users instead of using the AWS Root User.
* Assigning permissions based on job responsibilities.
* Controlling access using policies.
* Supporting Multi-Factor Authentication (MFA).
* Following the Principle of Least Privilege.

---

# Key Concepts

## Root User

The Root User is created when an AWS account is first created.

* Has full access to all AWS services.
* Should only be used for account-level tasks.
* Daily work should be performed using IAM users.

---

## IAM User

An IAM User represents an individual person or application that needs access to AWS.

Example:

* moorthi-devops
* backend-developer

---

## IAM Group

An IAM Group is a collection of IAM Users.

Examples:

* DevOps Team
* Developers
* QA Team

Permissions are assigned to the group, and all users in the group inherit those permissions.

---

## IAM Policy

An IAM Policy is a JSON document that defines permissions.

Examples of permissions:

* AmazonS3FullAccess
* AmazonEC2ReadOnlyAccess
* AdministratorAccess

Policies specify:

* What actions are allowed.
* Which AWS resources can be accessed.
* Whether access is allowed or denied.

---

## IAM Role

An IAM Role provides temporary permissions to AWS services or applications.

Common examples:

* EC2 accessing S3.
* Lambda accessing DynamoDB.
* ECS tasks accessing S3.

Unlike IAM Users, roles do not have permanent login credentials.

---

## Multi-Factor Authentication (MFA)

MFA adds an extra layer of security by requiring a second verification step during login.

Example:

* Password
* Mobile Authenticator Code

---

## Principle of Least Privilege

Always grant only the minimum permissions required to perform a task.

Example:

If a developer only needs to upload files to S3, do not grant AdministratorAccess.

---

# Hands-on Exercises

## Exercise 1

Login to the AWS Management Console.

---

## Exercise 2

Open the IAM Dashboard.

---

## Exercise 3

View the AWS Root User security recommendations.

---

## Exercise 4

Create a new IAM User.

Example:

* Username: devops-user

---

## Exercise 5

Create an IAM Group.

Example:

* DevOps-Team

---

## Exercise 6

Attach a policy to the group.

Example:

* AmazonS3FullAccess

---

## Exercise 7

Add the IAM User to the IAM Group.

---

## Exercise 8

Login using the IAM User credentials.

---

## Exercise 9

Explore IAM Roles.

View existing AWS service roles and understand their purpose.

---

## Exercise 10

Review IAM Policies.

View both AWS Managed Policies and Customer Managed Policies.

---

# Real-Time Project Usage (Inspect Lens)

In the Inspect Lens project, IAM is used to securely allow the backend application to access Amazon S3.

Example workflow:

1. Backend application needs to upload a generated PDF.
2. An IAM User or IAM Role is granted permission to access the S3 bucket.
3. The backend uses these permissions to upload the PDF.
4. Users without permission cannot access or modify the bucket.

This ensures secure access without exposing unnecessary AWS permissions.

---

# Learning Outcome

After completing this module, I am able to:

* Understand AWS IAM fundamentals.
* Create IAM Users and Groups.
* Assign permissions using IAM Policies.
* Understand the purpose of IAM Roles.
* Follow AWS security best practices.
* Explain how IAM secures access to AWS services such as Amazon S3.

---
