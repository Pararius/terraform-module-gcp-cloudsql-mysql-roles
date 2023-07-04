terraform {
  required_version = ">= 1.0.0"
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 4.71.0"
    }
    mysql = {
      source  = "petoju/mysql"
      version = "~> 3"
    }
  }
}