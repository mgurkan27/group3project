# this creates an SNS topic that would send an email to the var.**email.com when the cloudwatch alarm triggers

resource "aws_sns_topic" "group-3-error-400-alarm" {
  name            = "alarms-topic"
  delivery_policy = <<EOF
{
  "http": {
    "defaultHealthyRetryPolicy": {
      "minDelayTarget": 20,
      "maxDelayTarget": 20,
      "numRetries": 3,
      "numMaxDelayRetries": 0,
      "numNoDelayRetries": 0,
      "numMinDelayRetries": 0,
      "backoffFunction": "linear"
    },
    "disableSubscriptionOverrides": false,
    "defaultThrottlePolicy": {
      "maxReceivesPerSecond": 1
    }
  }
}
EOF
}

resource "aws_cloudwatch_metric_alarm" "group-3-error-400-alarm" {
  alarm_name          = "group-3-error-400-alarm"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = "2"
  metric_name         = "HTTPCode_ELB_400_Count"
  namespace           = "AWS/ApplicationELB"
  period              = "60"
  statistic           = "Sum"
  threshold           = "100"
  alarm_description   = "This metric monitors http errors 400"
  alarm_actions       = [aws_sns_topic.group-3-error-400-alarm.arn]
 
  dimensions = {
    LoadBalancer = aws_lb.group3_web_elb.arn_suffix
  }
}

resource "aws_sns_topic_subscription" "admin-sms-error" {
  topic_arn = aws_sns_topic.group-3-error-400-alarm.arn
  protocol  = "sms"
  endpoint  = var.alarms_sms
}