resource "aws_autoscaling_group" "this" {
  name                      = "server-asg"
  min_size                  = var.asg_min_size
  max_size                  = var.asg_max_size
  health_check_grace_period = 300
  desired_capacity          = 3
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

resource "aws_cloudwatch_metric_alarm" "this" {
  alarm_name          = "cpu-high"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "2"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = "60"
  statistic           = "Average"
  threshold           = "70"
  alarm_description   = "This metric checks cpu utilization"
  alarm_actions       = []
}

resource "aws_cloudwatch_metric_alarm" "high_request_count" {
  alarm_name                = "high-request-count"
  comparison_operator       = "GreaterThanOrEqualToThreshold"
  evaluation_periods        = "1"
  metric_name               = "RequestCount"
  namespace                 = "AWS/ApplicationELB"
  period                    = "30"
  statistic                 = "Sum"
  threshold                 = "300"
  alarm_description         = "This alarm monitors the number of requests"
  alarm_actions             = [aws_autoscaling_policy.scale_up.arn]
  dimensions = {
    LoadBalancer = var.load_balancer_name
  }
}

resource "aws_autoscaling_policy" "scale_up" {
  name                   = "scale-up-on-high-request"
  scaling_adjustment     = 1
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 10
  autoscaling_group_name = aws_autoscaling_group.this.name
}

resource "aws_cloudwatch_metric_alarm" "low_request_count" {
  alarm_name          = "low-request-count"
  comparison_operator = "LessThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = "RequestCount"
  namespace           = "AWS/ApplicationELB"
  period              = "60"
  statistic           = "Sum"
  threshold           = "500" # Set to your desired low threshold for scaling down
  alarm_description   = "This alarm monitors the low number of requests"
  alarm_actions       = [aws_autoscaling_policy.scale_down.arn]
  dimensions = {
    LoadBalancer = var.load_balancer_name
  }
}

resource "aws_autoscaling_policy" "scale_down" {
  name                   = "scale-down-on-low-request"
  scaling_adjustment     = -1
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 15
  autoscaling_group_name = aws_autoscaling_group.this.name
  enabled = false
}

resource "aws_autoscaling_policy" "scale_up_down_tracking" {
  policy_type = "TargetTrackingScaling"
  name = "scale-up-down-tracking"
  autoscaling_group_name = aws_autoscaling_group.this.name
  target_tracking_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ALBRequestCountPerTarget"
      resource_label = "${split("/", var.load_balancer_id)[1]}/${split("/", var.load_balancer_id)[2]}/${split("/", var.load_balancer_id)[3]}/targetgroup/${split("/", var.alb_target_group_arn)[1]}/${split("/", var.alb_target_group_arn)[2]}"
    }
    target_value = 300
    
  }

  lifecycle {
    create_before_destroy = true 
  }
}