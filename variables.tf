variable "instance_profile" {}
variable "name" {}
variable "vpc_id" {}
variable "cr_request" {}
variable "Application" {}
variable "BussinessUnit" {}
variable "Department" {}
variable "ApplicationSupport" {}
variable "Environment" {}
variable "ApplicationRole" {}
variable "ApplicationOwner" {}
variable "DRRequired" {}
variable "Decomm" {}
variable "RTO" {}
variable "RPO" {}
variable "Backup" {}
variable "Notes" {}
variable "Project" {}
variable "default_sg" {}
variable "shared_management_sg" {}
variable "subnet_id" {}
variable "private_ips_count" {}
variable "ami_id" {}
variable "instance_type" {}
variable "key_name" {}
variable "user_data" {}
variable "availability_zone" {}
variable "root_drive_size" {}
variable "vol_count" {}
variable "kms_key_id" {}
variable "extra_drives_sizes" {
  type = list
}
variable "extra_drives_names" {
  type = list
}