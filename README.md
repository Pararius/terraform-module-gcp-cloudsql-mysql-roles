# Terraform module to manage mysql roles

This Terraform module provides role-based access control for Cloud SQL instances in a MySQL environment on Google Cloud Platform (GCP). It enables you to manage different types of accounts with specific permissions and privileges, such as read/write accounts, and read-only accounts.

## Features

- Role-based access control for Cloud SQL MySQL instances on GCP.
- Creation of read/write accounts for performing read and write operations.
- Configuration of read-only accounts with read-only access.

## Usage

module "db" {
  source = "github.com/Pararius/terraform-module-gcp-cloudsql-mysql.git"
.
.
}

NOTE: Using this module requires a two step approach using separate `terraform apply` runs:
* Provision the mysql instance itself
* Configure the `mysql` provider and provision (additional) roles using this module
