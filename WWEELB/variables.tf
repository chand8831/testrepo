variable "AWS_ACCESS_KEY" {}

variable "AWS_SECRET_KEY" {}

variable "AWS_REGION" {
default = "ap-south-1"
}

variable "AMIS" {
    type = map
    default = {
        ap-south-1 = "ami-0f5ee92e2d63afc18"
        
    }
}

variable "PATH_TO_PRIVATE_KEY" {
  default = "wwealb_key"
}

variable "PATH_TO_PUBLIC_KEY" {
  default = "wwealb_key.pub"
}

variable "INSTANCE_USERNAME" {
  default = "ubuntu"
}