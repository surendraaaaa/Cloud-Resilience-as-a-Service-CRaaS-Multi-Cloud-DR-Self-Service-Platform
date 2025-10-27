##############################################
# AWS CLOUDWATCH MONITORING
##############################################

# SNS Topic for Alerts
resource "aws_sns_topic" "alerts" {
  name = "dr-monitoring-alerts"
}

# Subscribe your email to the alert topic
resource "aws_sns_topic_subscription" "email_sub" {
  topic_arn = aws_sns_topic.alerts.arn
  protocol  = "email"
  endpoint  = var.sns_alert_email
}

# cloud watch alarm
resource "aws_cloudwatch_metric_alarm" "foobar" {
  alarm_name                = "${var.lambda_function_name}-failures"
  comparison_operator       = "GreaterThanThreshold"
  evaluation_periods        = 1
  metric_name               = "Errors"
  namespace                 = "AWS/Lambda"
  period                    = 300
  statistic                 = "Sum"
  threshold                 = 0
  alarm_description         = "This metric monitors AWS Lamnda function failovers"
  dimensions = {
  FunctionName = var.lambda_function_name
    }
  alarm_actions = [aws_sns_topic.alerts.arn]
}

##############################################
# AZURE MONITOR ALERTS
##############################################



# Action group — defines where to send alerts (email, etc.)
resource "azurerm_monitor_action_group" "dr_alert_group" {
  name                = var.azure_action_group_name
  resource_group_name = var.azure_rg_name
  short_name          = "drmon"

  email_receiver {
    name          = "OpsTeam"
    email_address = var.sns_alert_email
  }

}

# VM health alert (example: CPU usage > 80%)
resource "azurerm_monitor_metric_alert" "vm_cpu_high" {
  name                = "DR-VM-HighCPU"
  resource_group_name = var.azure_rg_name
  scopes              = [var.azure_vm_id]
  description         = "Alert when VM CPU usage is too high"
  severity            = 2
  frequency           = "PT5M"
  window_size         = "PT5M"
  criteria {
    metric_namespace = "Microsoft.Compute/virtualMachines"
    metric_name      = "Percentage CPU"
    aggregation      = "Average"
    operator         = "GreaterThan"
    threshold        = 80
  }

  action {
    action_group_id = azurerm_monitor_action_group.dr_alert_group.id
  }
}
