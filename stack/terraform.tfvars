aws_region     = "us-west-1"
aws_profile    = "terraform"

key_name       = "us-west-1"     #use your key
vpc_cidr       = "10.0.0.0/16"

cidrs = {
  public1  = "10.0.1.0/24"
  public2  = "10.0.2.0/24"
  private1 = "10.0.3.0/24"
  private2 = "10.0.4.0/24"
  private3 = "10.0.5.0/24"
  private4 = "10.0.6.0/24"
  rds1     = "10.0.7.0/24"
  rds2     = "10.0.8.0/24"
  rds3     = "10.0.9.0/24"
}

db_instance_class = "db.t2.micro"
db_name           = "user"
db_user           = "user"
db_password       = "12345678"
db_bak_retention  = "4"
db_port           = 3306

elb_healthy_threshold   = "5"
elb_unhealthy_threshold = "10"
elb_interval            = "10"
elb_timeout             = "5"
elb_drain_timeout       = "400"
elb_idle_timeout        = "60"

web_lc_instance_type = "t2.micro"
asg_web_max          = "2"
asg_web_min          = "1"
asg_web_grace        = "400"
asg_web_hct          = "ELB"
asg_web_cap          = "1"

app_lc_instance_type = "t2.micro"
asg_app_max          = "2"
asg_app_min          = "1"
asg_app_grace        = "400"
asg_app_hct          = "ELB"
asg_app_cap          = "1"

alarms_sms  = "+2154303837"

zone_id = "Z04238323JL5U5NJRKE1L"
route53_dns = "gurkancloud.com"
  
