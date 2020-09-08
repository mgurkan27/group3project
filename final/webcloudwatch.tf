resource "aws_autoscaling_policy" "group3-web-asp" {
  name                   = "web-cpu-asp"
  scaling_adjustment     = 1
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 300
  autoscaling_group_name = aws_autoscaling_group.group3_web_asg.name
  policy_type            = "SimpleScaling"  #by default
}

#scale up alarm
resource "aws_cloudwatch_metric_alarm" "web-cpu-alarm" {
  alarm_name          = "web-cpu-alarm"
  alarm_description   = "group3_web-scaleup-cpu-alarm"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "2"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = "120" #second
  statistic           = "Average"
  threshold           = "75"
  dimensions = {
    "AutoScalingGroupName" = aws_autoscaling_group.group3_web_asg.name
  }
  actions_enabled = true
  alarm_actions   = [aws_autoscaling_policy.group3-web-asp.arn]
}

#scale down alarm
resource "aws_autoscaling_policy" "group3-web-asp-scaledown" {
  name                   = "web-cpu-asp-scaledown"
  autoscaling_group_name = aws_autoscaling_group.group3_web_asg.name
  adjustment_type        = "ChangeInCapacity"
  scaling_adjustment     = "-1"
  cooldown               = "300"
  policy_type            = "SimpleScaling"
}
resource "aws_cloudwatch_metric_alarm" "web-cpu-alarm-scaledown" {
  alarm_name          = "web-cpu-alarm-scaledown"
  alarm_description   = "web-low-cpu-alarm-scaledown"
  comparison_operator = "LessThanOrEqualToThreshold"
  evaluation_periods  = "2"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = "120"
  statistic           = "Average"
  threshold           = "30"
  dimensions = {
    "AutoScalingGroupName" = aws_autoscaling_group.group3_web_asg.name
  }
  actions_enabled = true
  alarm_actions   = [aws_autoscaling_policy.group3-web-asp-scaledown.arn]
}

# scale up, low memory alarm

resource "aws_autoscaling_policy" "group3-web-memory-sp" {
  name                   = "group3-web-memory-sp"
  scaling_adjustment     = 1
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 300
  autoscaling_group_name = aws_autoscaling_group.group3_web_asg.name
  policy_type            = "SimpleScaling"
}

resource "aws_cloudwatch_metric_alarm" "group3-web-memory-alarm" {
  alarm_name          = "group3-web-memory-alarm"
  alarm_description   = "web-tier-scaleup-memory-alarm"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "2"
  metric_name         = "mem_used_percent"
  namespace           = "AWS/EC2"
  period              = "120"
  statistic           = "Average"
  threshold           = "80"
  dimensions = {
    "AutoScalingGroupName" = aws_autoscaling_group.group3_web_asg.name
  }
  actions_enabled = true
  alarm_actions   = [aws_autoscaling_policy.group3-web-memory-sp.arn]
}

resource "aws_sns_topic" "group3-web-scale-up-sms" {
  name = "group3-web-sms-alarm-topic"
}

resource "aws_sns_topic_subscription" "group3-web-send-sms-autoscaling" {
    topic_arn = aws_sns_topic.group3-web-scale-up-sms.arn
    protocol  = "sms"
    endpoint  = var.alarms_sms
  }

  # cloudwatch alarm for scaling up need, triggers sns topic that triggers sns subscription to send an SMS

  resource "aws_cloudwatch_metric_alarm" "group3-web-scale-up-sms" {
    alarm_name          = "web-tier-cpu-alarm-to-send-sms-to ....."
    alarm_description   = "web-tier-scaleup-cpu-alarm"
    comparison_operator = "GreaterThanOrEqualToThreshold"
    evaluation_periods  = "2"
    metric_name         = "CPUUtilization"
    namespace           = "AWS/EC2"
    period              = "120"
    statistic           = "Average"
    threshold           = "75"
    dimensions = {
      "AutoScalingGroupName" = aws_autoscaling_group.group3_web_asg.name
    }
    actions_enabled = true
    alarm_actions   = [aws_sns_topic.group3-web-scale-up-sms.arn]
  }