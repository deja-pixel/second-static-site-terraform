AWS Static Website with Terraform

This project deploys a static website to AWS S3 using Terraform. It automates bucket creation, website configuration, and file uploads.

Project Purpose

The goal is to host a fully static website (index.html, about.html, contact.html, error.html) on S3, managed entirely with Terraform. This makes it easy to replicate, update, or tear down the site.

Prerequisites

Terraform
 installed

AWS CLI installed and configured (aws configure)

An AWS account with permissions to manage S3 and IAM

Usage

Clone the repository to your local machine.

Add your static website files to the project folder.

Configure AWS credentials
aws configure

Initialize Terraform:
terraform init

Review the plan:
terraform plan

Apply the configuration:
terraform apply


Once complete, your website should be available at:

http://<bucket-name>.s3-website-<region>.amazonaws.com

Notes & Gotchas

ACLs are deprecated – S3 recommended using bucket policies instead. Trying to set acl may cause errors (AccessControlListNotSupported).

Block Public Access must be disabled for the bucket if you want public pages.

Terraform may warn about deprecated arguments; follow recommendations (aws_s3_bucket_website_configuration instead of website, aws_s3_object instead of aws_s3_bucket_object).

Make sure all static files you want uploaded are referenced in the Terraform configuration. Terraform will only upload files it knows about.

Learned the hard way: expect multiple iterations and a few late nights to get everything working—especially debugging permissions!

Folder Structure
aws-terraform-s3/
├─ main.tf        # Terraform configuration
├─ index.html
├─ about.html
├─ contact.html
├─ error.html
└─ README.md

Lessons Learned

Always double-check bucket policies and ACLs.

Terraform state can get tricky; plan before applying.

AWS S3 static hosting has quirks (like index.html and error.html) that need careful configuration.