resource "aws_route53_record" "www" {
  zone_id = var.zone_id  # your zone_id
  name    = var.route53_dns       #put your website name
  type    = "A"
  alias {
    name                   = aws_lb.group3_web_elb.dns_name
    zone_id                = aws_lb.group3_web_elb.zone_id
    evaluate_target_health = true
  }
}


