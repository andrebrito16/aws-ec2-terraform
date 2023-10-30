resource "aws_autoscaling_group" "this" {
  name                      = "server-asg"
  min_size                  = var.asg_min_size
  max_size                  = var.asg_max_size
  health_check_grace_period = 300
  desired_capacity          = 1
  health_check_type         = "EC2"
  force_delete              = true

  target_group_arns   = [var.alb_target_group_arn]
  vpc_zone_identifier = var.vpc_zone_identifier

  lifecycle {
    create_before_destroy = true
  }

  mixed_instances_policy {
    instances_distribution {
      on_demand_base_capacity                  = 0
      on_demand_percentage_above_base_capacity = 20
      spot_allocation_strategy                 = "capacity-optimized"
    }

    launch_template {
      launch_template_specification {
        launch_template_id = var.launch_template_id
        version            = "$Latest"
      }
    }
  }


}

# resource "aws_cloudwatch_metric_alarm" "this" {
#   alarm_name          = "cpu-high"
#   comparison_operator = "GreaterThanOrEqualToThreshold"
#   evaluation_periods  = "2"
#   metric_name         = "CPUUtilization"
#   namespace           = "AWS/EC2"
#   period              = "60"
#   statistic           = "Average"
#   threshold           = "70"
#   alarm_description   = "This metric checks cpu utilization"
#   alarm_actions       = []
# }
