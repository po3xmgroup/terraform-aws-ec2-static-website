resource "aws_codepipeline" "codepipeline" {
  name     = "pipeline-static-site-po3xm"
  role_arn = aws_iam_role.codepipeline_role.arn

  artifact_store {
    location = "s3-static-website-training"
    type     = "S3"
  }


  stage {
    name = "Source"

    action {
      name             = "Source"
      region           = "us-east-1"
      category         = "Source"
      owner            = "AWS"
      provider         = "CodeStarSourceConnection"
      version          = "1"
      output_artifacts = ["SourceArtifact"]
      namespace        = "SourceVariables"

      configuration = {
        ConnectionArn        = "arn:aws:codestar-connections:us-east-1:424819937310:connection/12c0fb8c-ce18-4b97-ba63-59c88389789c"
        FullRepositoryId     = "po3xmgroup/testS3StaticSite"
        BranchName           = "dev"
        OutputArtifactFormat = "CODE_ZIP"
      }
    }
  }


  stage {
    name = "Deploy"
    action {
      region = "us-east-1"
      name   = "Deploy"
      configuration = {
        ApplicationName     = "po3xm-testing"
        DeploymentGroupName = "po3xm-example-group"
      }

      category = "Deploy"
      owner    = "AWS"
      provider = "CodeDeploy"
      version  = "1"

      input_artifacts  = ["SourceArtifact"]
      namespace        = "DeployVariables"
      output_artifacts = []
    }
  }
  depends_on = [
    aws_instance.web
  ]

}


resource "aws_iam_role" "codepipeline_role" {
  name = "po3xm-test-role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "codepipeline.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "codepipeline_policy" {
  name = "codepipeline_policy"
  role = aws_iam_role.codepipeline_role.id

  policy = templatefile("./templates/policy_codepipeline.json", { aws_codepipeline = "tf-test-pipeline" })

}
