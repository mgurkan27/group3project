variable "aws_region" {
  default = "us-west-1"
}

variable "aws_profile" {}



variable "vpc_cidr" {}
variable "key_name" {
  type = string
}

data "aws_availability_zones" "available" {}

variable "cidrs" {
  type = map(string)
}

variable "db_instance_class" {}
variable "db_name" {}
variable "db_user" {}
variable "db_password" {}
variable "db_bak_retention" {}
variable "db_port" {}

variable "elb_healthy_threshold" {}
variable "elb_unhealthy_threshold" {}
variable "elb_timeout" {}
variable "elb_interval" {}
variable "elb_drain_timeout" {}
variable "elb_idle_timeout" {}



#variable "web_ami" {}
variable "web_lc_instance_type" {}
variable "asg_web_max" {}
variable "asg_web_min" {}
variable "asg_web_grace" {}
variable "asg_web_hct" {}
variable "asg_web_cap" {}



#variable "app_ami" {}
variable "app_lc_instance_type" {}
variable "asg_app_max" {}
variable "asg_app_min" {}
variable "asg_app_grace" {}
variable "asg_app_hct" {}
variable "asg_app_cap" {}

variable "zone_id" {}
variable "route53_dns" {}
 
variable "alias" {
  type        = map
  default     = {}
  description = "An alias block. Conflicts with ttl & records. Alias record documented below."
}
variable stack {
  description = "this is name for tags"
  default     = "terraform"
}


variable "alarms_sms" {}
 