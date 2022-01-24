# terraform-aws-ec2-static-website

![image](https://user-images.githubusercontent.com/97295536/150816655-2635f21e-767d-4033-9c40-1dd8e0257355.png)


![image](https://user-images.githubusercontent.com/97295536/150805789-31258add-65f2-4dfc-b19e-6ad7aab53c1b.png)

## Usage
## Example Usage
These terraform actions can be added as steps to your own workflow files.
GitHub reads workflow files from `.github/workflows/` within your repository.
See the [Workflow documentation](https://docs.github.com/en/actions/configuring-and-managing-workflows/configuring-a-workflow#about-workflows) for details on writing workflows.

Here are some examples of how the terraform actions can be used together in workflows.

### Terraform plan PR approval

Terraform plans typically need to be reviewed by a human before being applied.
Fortunately, GitHub has a well established method for requiring human reviews of changes - a Pull Request.

We can use PRs to safely plan and apply infrastructure changes.

<p align="center">
    <img src="terraform-apply/planapply.gif" width="1000">
</p>

You can make GitHub enforce this using branch protection, see the [dflook/terraform-apply](terraform-apply) action for details.

In this example we use two workflows:

#### plan.yaml
This workflow runs on changes to a PR branch. It generates a terraform plan and attaches it to the PR as a comment.
```yaml
name: Create terraform plan

on: [pull_request]

jobs:
  plan:
    runs-on: ubuntu-latest
    name: Create a plan for an example terraform configuration
    env:
      GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}
    steps:
      - name: Checkout
        uses: actions/checkout@v2

      - name: terraform plan
        uses: dflook/terraform-plan@v1
        with:
          path: my-terraform-config
```

#### apply.yaml
This workflow runs when the PR is merged into the master branch, and applies the planned changes.
```yaml
name: Apply terraform plan

on:
  push:
    branches:
      - master

jobs:
  apply:
    runs-on: ubuntu-latest
    name: Apply terraform plan
    env:
      GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}
    steps:
      - name: Checkout
        uses: actions/checkout@v2

      - name: terraform apply
        uses: dflook/terraform-apply@v1
        with:
          path: my-terraform-config
```

### Deploying Infra


```hcl
#
terraform init
#
terraform fmt

#
terraform validate

#
terraform plan

#
terraform apply --auto-approve
```
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.13.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 2.0 |
| <a name="requirement_random"></a> [random](#requirement\_random) | >= 2.1 |


## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 2.0 |
| <a name="provider_random"></a> [random](#provider\_random) | >= 2.1 |

## Modules

| Name | Source |
|------|--------|
| <a name="module_app"></a> [app](#module\_app) | modules/app|
| <a name="module_network"></a> [network](#module\_network) | modules/network|
| <a name="module_routing"></a> [routing](#module\_routing) | modules/routing|
| <a name="module_security"></a> [network](#module\_security) | modules/security|


## Resources

| Name | Type |
|------|------|
| [aws_codepipeline.default](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/codepipeline) | resource |
| [aws_codedeploy.app](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/codedeploy_app) | resource |
| [aws_codedeploy.deployment.config](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/codedeploy_deployment_config) | resource |
| [aws_codedeploy.deployment.group](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/codedeploy_deployment_group) | resource |
| [aws_instance](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/instance) | resource |
| [aws_eip_association](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eip_association) | resource |
| [aws_s3](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket) | resource |
| [aws_security_group](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_internet_gateway](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/internet_gateway) | resource |
| [aws_subnet](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet) | resource |
| [aws_vpc](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc) | resource |
| [aws_route_table](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table) | resource |
| [aws_iam_role_ec2](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy) | resource |
| [aws_iam_role_s3](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy) | resource |
| [aws_iam_role_codepipeline](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy) | resource |
| [aws_iam_role_codedeploy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy) | resource |
| [aws_vpc](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc) | resource |
| [aws_route_table](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/route_table) | data source |
| [aws_eip](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/eip) | data source |

## Inputs
| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc_id)| It gets VPC ID. | `string` | `{}` | yes |
| <a name="input_subnet_id"></a> [subnet\_id](#input\_subnet_id)| It gets subnet id. | `string` | `{}` | yes |
| <a name="input_iam_ec2_profile"></a> [iam\_ec2\profile](#input\_iam_ec2_profile)| It gets the IAM EC2 Role | `string` | `{}` | yes |

## Outputs
| Name | Description |
|------|-------------|
| <a name="output_vpc_id"></a> [badge\_url](#output\_vpc\_id) |  VPC ID |
| <a name="output_subnet_id"></a> [subnet\_id](#output\_subnet\_id) | subnet ID|
| <a name="output_iam_ec2_profile"></a> [iam\_ec2\_profile](#output\_iam\_ec2\_profile) | IAM profile for EC2 instance|
| <a name="output_Webserver_Public_IP"></a> [Webserver\_Public\_IP](#output\_Webserver\_Public\_IP) | EC2 public IP |



