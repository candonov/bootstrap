# Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
# SPDX-License-Identifier: Apache-2.0

variable "region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "name" {
  description = "EKS Cluster Name and the VPC name"
  type        = string
  default     = "demo"
}

variable "cluster_version" {
  type        = string
  description = "Kubernetes Version"
  default     = "1.33"
}

variable "capacity_type" {
  type        = string
  description = "Capacity SPOT or ON_DEMAND"
  default     = "SPOT"
}
