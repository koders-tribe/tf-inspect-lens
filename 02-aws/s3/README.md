# Amazon S3 (Simple Storage Service)

## Objective

The objective of this module is to understand Amazon S3, learn how to store and manage objects in the cloud, configure bucket permissions, and perform hands-on exercises.

---

# What is Amazon S3?

Amazon S3 (Simple Storage Service) is an object storage service provided by AWS. It is used to securely store and retrieve files such as images, videos, PDFs, backups, application assets, and logs from anywhere.

---

# Why Amazon S3?

* Highly scalable object storage.
* Highly durable and available.
* Secure access using IAM and Bucket Policies.
* Store unlimited objects.
* Pay only for the storage you use.
* Easily integrates with other AWS services.

---

# Key Concepts

## Bucket

A Bucket is a container that stores objects in Amazon S3.

Example:

* inspect-lens-pdfs
* company-backups
* project-images

Bucket names must be globally unique.

---

## Object

An Object is a file stored inside a bucket.

Examples:

* quotation.pdf
* report.pdf
* image.png
* invoice.pdf

Each object contains:

* File data
* Metadata
* Object key (file name)

---

## Object Key

The Object Key is the unique name of the object inside a bucket.

Example:

```text
quotation-agreements/QA-1001.pdf
reports/report-001.pdf
```

---

## Bucket Policy

A Bucket Policy is a JSON document that defines who can access the bucket and what actions they are allowed to perform.

---

## IAM

IAM controls which users, groups, or roles can access S3 resources.

Example permissions:

* ListBucket
* GetObject
* PutObject
* DeleteObject

---

## Versioning

Versioning stores multiple versions of the same object.

If a file is accidentally overwritten or deleted, a previous version can be restored.

---

## Storage Classes

Common storage classes:

* S3 Standard
* S3 Intelligent-Tiering
* S3 Standard-IA
* S3 Glacier Instant Retrieval
* S3 Glacier Flexible Retrieval
* S3 Glacier Deep Archive

---

## Lifecycle Rules

Lifecycle Rules automatically move or delete objects after a specified period.

Example:

* Move files to Glacier after 90 days.
* Delete temporary files after 365 days.

---

## Pre-signed URL

A Pre-signed URL provides temporary access to a private object without making the bucket public.

---

# Hands-on Exercises

## Exercise 1

Login to the AWS Management Console.

---

## Exercise 2

Navigate to Amazon S3.

---

## Exercise 3

Create a new S3 Bucket.

* Enter a globally unique bucket name.
* Select the AWS Region.
* Keep Block Public Access enabled.
* Create the bucket.

---

## Exercise 4

Upload files.

Upload:

* sample.pdf
* image.png
* notes.txt

---

## Exercise 5

Download an uploaded object.

---

## Exercise 6

Delete an object.

---

## Exercise 7

Create folders inside the bucket.

Example:

```text
quotation-agreements/
reports/
images/
```

---

## Exercise 8

Enable Bucket Versioning.

---

## Exercise 9

View Bucket Permissions.

* Bucket Policy
* IAM Permissions
* Block Public Access

---

## Exercise 10

Delete the bucket after removing all objects.

---

# Inspect Lens Project Usage

In the Inspect Lens project, Amazon S3 is planned to store generated quotation agreement PDF files.

Expected workflow:

1. Customer completes the quotation agreement.
2. Backend generates the PDF.
3. The PDF is uploaded to an Amazon S3 bucket.
4. The S3 object path is stored in the database.
5. The same PDF is attached to the customer email.
6. The stored PDF can be accessed later whenever required.

---

# Learning Outcome

After completing this module, I am able to:

* Understand Amazon S3 architecture.
* Create and manage S3 buckets.
* Upload, download, and delete objects.
* Configure bucket permissions.
* Understand IAM access for S3.
* Enable bucket versioning.
* Understand lifecycle rules.
* Explain how S3 integrates with real-world applications such as the Inspect Lens project.

---
