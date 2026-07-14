# AWS SES (Simple Email Service)

## Objective

The objective of this module is to understand Amazon Simple Email Service (SES), learn how to verify email identities, send emails securely, and understand how SES is used in real-world applications.

---

# What is Amazon SES?

Amazon Simple Email Service (SES) is a cloud-based email service provided by AWS. It enables applications to send transactional and notification emails securely and reliably.

---

# Why Amazon SES?

Amazon SES is used to:

* Send transactional emails.
* Send notification emails.
* Send OTP and verification emails.
* Send invoices and PDF attachments.
* Improve email delivery with high scalability.
* Integrate with AWS applications.

---

# Key Concepts

## Verified Identity

Before sending emails, the sender email address or domain must be verified in Amazon SES.

---

## Sandbox Mode

New AWS SES accounts start in Sandbox Mode.

In Sandbox Mode:

* Emails can only be sent to verified email addresses.
* Production access must be requested to send emails to any recipient.

---

## Production Access

After AWS approves your request, SES can send emails to any valid email address.

---

## Email Identity

An Email Identity is a verified email address used to send emails through Amazon SES.

Example:

* [example@gmail.com](mailto:example@gmail.com)
* [support@company.com](mailto:support@company.com)

---

## Domain Identity

Instead of verifying a single email address, you can verify an entire domain.

Example:

company.com

---

# Hands-on Exercises

## Exercise 1

Login to the AWS Management Console.

---

## Exercise 2

Navigate to Amazon SES.

---

## Exercise 3

Open **Verified Identities**.

---

## Exercise 4

Create a new Email Identity.

Example:

[your-email@example.com](mailto:your-email@example.com)

---

## Exercise 5

Verify the email address by clicking the verification link sent to your inbox.

---

## Exercise 6

Confirm that the Email Identity status is **Verified**.

---

## Exercise 7

Explore the SES Dashboard.

* Verified Identities
* Account Dashboard
* Configuration Sets
* Email Templates

---

## Exercise 8

Understand the difference between Sandbox Mode and Production Access.

---

# Real-Time Project Usage (Inspect Lens)

In the Inspect Lens project, Amazon SES is used to send the generated quotation agreement PDF to the customer's email.

Project Workflow:

1. Customer requests a quotation agreement.
2. Backend generates the PDF.
3. The PDF is stored in Amazon S3.
4. Backend sends the PDF as an email attachment using Amazon SES.
5. Customer receives the email with the attached PDF.

---

# Learning Outcome

After completing this module, I am able to:

* Understand Amazon SES fundamentals.
* Verify email identities.
* Explain the difference between Sandbox and Production Mode.
* Understand how Amazon SES sends emails.
* Explain how SES integrates with Amazon S3 in the Inspect Lens project.

---
