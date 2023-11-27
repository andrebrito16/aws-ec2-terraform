variable "region" {
  default = "us-east-1"
}

variable "my_public_ip_cidr" {
  type    = string
  default = "203.0.113.10/32"
}

variable "vpc_cidr_block" {
  type    = string
  default = "172.16.0.0/16"
}

variable "domain_name" {
  type    = string
  default = "aws-cloud.compute.internal"
}

variable "environment" {
  type    = string
  default = "staging"
}

variable "dns_servers" {
  type    = list(string)
  default = ["AmazonProvidedDNS"]
}

variable "vpn-instance-id" {
  description = "value of the vpn-instance.id"
}
