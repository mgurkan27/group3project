resource "aws_autoscaling_policy" "group3-app-asp" {
  name                   = "app-cpu-asp"
  scaling_adjustment     = 1
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 300
  autoscaling_group_name = aws_autoscaling_group.group3_app_asg.name
  policy_type            = "SimpleScaling"  #by default
}

#scale up alarm
resource "aws_cloudwatch_metric_alarm" "app-cpu-alarm" {
  alarm_name          = "app-cpu-alarm"
  alarm_description   = "group3_app-scaleup-cpu-alarm"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "2"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = "120" #second
  statistic           = "Average"
  threshold           = "75"
  dimensions = {
    "AutoScalingGroupName" = aws_autoscaling_group.group3_app_asg.name
  }
  actions_enabled = true
  alarm_actions   = [aws_autoscaling_policy.group3-app-asp.arn]
}

#scale down alarm
resource "aws_autoscaling_policy" "group3-app-asp-scaledown" {
  name                   = "app-cpu-asp-scaledown"
  autoscaling_group_name = aws_autoscaling_group.group3_app_asg.name
  adjustment_type        = "ChangeInCapacity"
  scaling_adjustment     = "-1"
  cooldown               = "300"
  policy_type            = "SimpleScaling"
}
resource "aws_cloudwatch_metric_alarm" "app-cpu-alarm-scaledown" {
  alarm_name          = "app-cpu-alarm-scaledown"
  alarm_description   = "app-low-cpu-alarm-scaledown"
  comparison_operator = "LessThanOrEqualToThreshold"
  evaluation_periods  = "2"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = "120"
  statistic           = "Average"
  threshold           = "30"
  dimensions = {
    "AutoScalingGroupName" = aws_autoscaling_group.group3_app_asg.name
  }
  actions_enabled = true
  alarm_actions   = [aws_autoscaling_policy.group3-app-asp-scaledown.arn]
}

# scale up, low memory alarm--------------------------------------

resource "aws_autoscaling_policy" "group3-app-memory-sp" {
  name                   = "group3-app-memory-sp"
  scaling_adjustment     = 1
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 300
  autoscaling_group_name = aws_autoscaling_group.group3_app_asg.name
  policy_type            = "SimpleScaling"
}

resource "aws_cloudwatch_metric_alarm" "group3-app-memory-alarm" {
  alarm_name          = "group3-app-memory-alarm"
  alarm_description   = "app-tier-scaleup-memory-alarm"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "2"
  metric_name         = "mem_used_percent"
  namespace           = "AWS/EC2"
  period              = "120"
  statistic           = "Average"
  threshold           = "80"
  dimensions = {
    "AutoScalingGroupName" = aws_autoscaling_group.group3_app_asg.name
  }
  actions_enabled = true
  alarm_actions   = [aws_autoscaling_policy.group3-app-memory-sp.arn]
}

#SNS--------------------------------------------------------
resource "aws_sns_topic" "group3-app-scale-up-sms" {
  name = "group3-app-sms-alarm-topic"
}

resource "aws_sns_topic_subscription" "group3-app-send-sms-autoscaling" {
    topic_arn = aws_sns_topic.group3-app-scale-up-sms.arn
    protocol  = "sms"
    endpoint  = var.alarms_sms
  }

  # cloudwatch alarm for scaling up need, triggers sns topic that triggers sns subscription to send an SMS

  resource "aws_cloudwatch_metric_alarm" "group3-app-scale-up-sms" {
    alarm_name          = "app-tier-cpu-alarm-to-send-sms-to ....."
    alarm_description   = "app-tier-scaleup-cpu-alarm"
    comparison_operator = "GreaterThanOrEqualToThreshold"
    evaluation_periods  = "2"
    metric_name         = "CPUUtilization"
    namespace           = "AWS/EC2"
    period              = "120"
    statistic           = "Average"
    threshold           = "75"
    dimensions = {
      "AutoScalingGroupName" = aws_autoscaling_group.group3_app_asg.name
    }
    actions_enabled = true
    alarm_actions   = [aws_sns_topic.group3-app-scale-up-sms.arn]
  }
