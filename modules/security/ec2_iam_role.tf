resource "aws_iam_role_policy" "ec2_po3xm_policy" {
  name = "ec2_policy"
  role = aws_iam_role.EC2withCodeDeployPO3xm.name
  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Action" : [
          "s3:GetObject",
          "s3:GetObjectVersion",
          "s3:ListBucket"
        ],
        "Effect" : "Allow",
        "Resource" : "*"
      }
    ]
  })
}

resource "aws_iam_role" "EC2withCodeDeployPO3xm" {

  name = "EC2PO3xm"

  tags = {
    createdby = "po3xm"
    project   = "training"
  }

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_iam_instance_profile" "ec2_profile" {
  name = "EC2PO3xm_profile"
  role = aws_iam_role.EC2withCodeDeployPO3xm.name
}