# Amazon RDS (Relational Database Service)

## Objective

The objective of this module is to understand Amazon RDS, learn how to create and manage relational databases in AWS, and perform basic hands-on exercises.

---

# What is Amazon RDS?

Amazon RDS (Relational Database Service) is a managed database service provided by AWS. It simplifies the creation, operation, backup, and scaling of relational databases in the cloud.

---

# Why RDS?

* Easily create relational databases.
* Automate backups and maintenance.
* Scale database resources.
* Improve database availability.
* Reduce database administration effort.

---

# Key Concepts

## DB Instance

A DB Instance is a managed database server running in AWS.

Examples:

* MySQL
* PostgreSQL
* MariaDB

---

## Database Engine

The database engine determines the type of relational database.

Examples:

* MySQL
* PostgreSQL
* Oracle
* Microsoft SQL Server

---

## Storage

Amazon RDS stores database files using Amazon EBS.

Storage can be increased when required.

---

## Automated Backup

RDS automatically creates database backups based on the configured backup retention period.

---

## Multi-AZ Deployment

Multi-AZ provides high availability by maintaining a standby database in another Availability Zone.

---

## Read Replica

A Read Replica improves application performance by handling read-only database requests.

---

# Hands-on Exercises

## Exercise 1

Login to the AWS Management Console.

---

## Exercise 2

Navigate to the Amazon RDS Dashboard.

---

## Exercise 3

Create a new DB Instance.

* Select PostgreSQL or MySQL.
* Choose a Free Tier eligible configuration.
* Configure database username and password.
* Launch the database.

---

## Exercise 4

Verify that the database reaches the **Available** state.

---

## Exercise 5

Connect to the database using a database client.

---

## Exercise 6

Create a sample database and table.

---

## Exercise 7

Delete the DB Instance after testing.

---

# Learning Outcome

After completing this module, I am able to:

* Understand the purpose of Amazon RDS.
* Create a relational database.
* Select an appropriate database engine.
* Configure database settings.
* Connect to an RDS database.
* Understand backups and high availability.
