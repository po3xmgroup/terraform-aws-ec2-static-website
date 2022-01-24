resource "aws_codedeploy_app" "po3xm" {
  compute_platform = "Server"
  name             = "po3xm-testing"
}

resource "aws_codedeploy_deployment_config" "po3xm" {
  deployment_config_name = "test-deployment-config"

  minimum_healthy_hosts {
    type  = "HOST_COUNT"
    value = 1
  }
}

# resource "aws_codedeploy_deployment_group" "po3xm" {
#   app_name               = aws_codedeploy_app.po3xm.name
#   deployment_group_name  = "po3xm-group"
#   service_role_arn       = aws_iam_role.po3xm.arn
#   deployment_config_name = aws_codedeploy_deployment_config.po3xm.id

#   ec2_tag_filter {
#     key   = "filterkey"
#     type  = "KEY_AND_VALUE"
#     value = "filtervalue"
#   }

#   trigger_configuration {
#     trigger_events     = ["DeploymentFailure"]
#     trigger_name       = "foo-trigger"
#     trigger_target_arn = "foo-topic-arn"
#   }

#   auto_rollback_configuration {
#     enabled = true
#     events  = ["DEPLOYMENT_FAILURE"]
#   }

#   alarm_configuration {
#     alarms  = ["my-alarm-name"]
#     enabled = true
#   }
# }

resource "aws_iam_role" "po3xm" {
  name = "codeploy-example-role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "",
      "Effect": "Allow",
      "Principal": {
        "Service":  [
          "codedeploy.amazonaws.com",
          "ec2.amazonaws.com"
        ]
        },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "AWSCodeDeployRole" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSCodeDeployRole"
  role       = aws_iam_role.po3xm.name
}



# resource "aws_sns_topic" "example" {
#   name = "example-topic"
# }

resource "aws_codedeploy_deployment_group" "po3xm-group" {
  app_name              = aws_codedeploy_app.po3xm.name
  deployment_group_name = "po3xm-example-group"
  service_role_arn      = aws_iam_role.po3xm.arn

  ec2_tag_set {
    ec2_tag_filter {
      key   = "createdby"
      type  = "KEY_AND_VALUE"
      value = "po3xm"
    }


  }

  #   trigger_configuration {
  #     trigger_events     = ["DeploymentFailure"]
  #     trigger_name       = "example-trigger"
  #     trigger_target_arn = aws_sns_topic.example.arn
  #   }

  auto_rollback_configuration {
    enabled = true
    events  = ["DEPLOYMENT_FAILURE"]
  }

  alarm_configuration {
    alarms  = ["my-alarm-name"]
    enabled = true
  }
}