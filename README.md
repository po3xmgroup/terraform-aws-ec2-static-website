# terraform-aws-ec2-static-website

![image](https://user-images.githubusercontent.com/97295536/150816655-2635f21e-767d-4033-9c40-1dd8e0257355.png)


![image](https://user-images.githubusercontent.com/97295536/150805789-31258add-65f2-4dfc-b19e-6ad7aab53c1b.png)

## Usage

This action can be run on `ubuntu-latest`, `windows-latest`, and `macos-latest` GitHub Actions runners. When running on `windows-latest` the shell should be set to Bash.

The default configuration installs the latest version of Terraform CLI and installs the wrapper script to wrap subsequent calls to the `terraform` binary.

```yaml
steps:
- uses: hashicorp/setup-terraform@v1
```

A specific version of Terraform CLI can be installed.

```yaml
steps:
- uses: hashicorp/setup-terraform@v1
  with:
     terraform_version: 0.13.0
```

Credentials for Terraform Cloud (app.terraform.io) can be configured.

```yaml
steps:
- uses: hashicorp/setup-terraform@v1
  with:
    cli_config_credentials_token: ${{ secrets.TF_API_TOKEN }}
```



Select working directory and the next steps are : 
    terraform fmt ---> to format the files 
    terraform init ---> to charging the modules and installing plugins
    terraform validate ---> to check if the code is valid 
    terraform plan ---> to see what resources are creating and using
Outputs can be used in subsequent steps to comment on the pull request:

```yaml
defaults:
  run:
    working-directory: ${{ env.tf_actions_working_dir }}
steps:
- uses: actions/checkout@v2
- uses: hashicorp/setup-terraform@v1

- name: Terraform fmt
  id: fmt
  run: terraform fmt -check
  continue-on-error: true

- name: Terraform Init
  id: init
  run: terraform init

- name: Terraform Validate
  id: validate
  run: terraform validate -no-color

- name: Terraform Plan
  id: plan
  run: terraform plan -no-color
  continue-on-error: true

- uses: actions/github-script@0.9.0
  if: github.event_name == 'pull_request'
  env:
    PLAN: "terraform\n${{ steps.plan.outputs.stdout }}"
  with:
    github-token: ${{ secrets.GITHUB_TOKEN }}
    script: |
      const output = `#### Terraform Format and Style 🖌\`${{ steps.fmt.outcome }}\`
      #### Terraform Initialization ⚙️\`${{ steps.init.outcome }}\`
      #### Terraform Validation 🤖\`${{ steps.validate.outputs.stdout }}\`
      #### Terraform Plan 📖\`${{ steps.plan.outcome }}\`
      
      <details><summary>Show Plan</summary>
      
      \`\`\`\n
      ${process.env.PLAN}
      \`\`\`
      
      </details>
      
      *Pusher: @${{ github.actor }}, Action: \`${{ github.event_name }}\`, Working Directory: \`${{ env.tf_actions_working_dir }}\`, Workflow: \`${{ github.workflow }}\`*`;
        
      github.issues.createComment({
        issue_number: context.issue.number,
        owner: context.repo.owner,
        repo: context.repo.repo,
        body: output
      })
```

## Inputs

The action supports the following inputs:

- `cli_config_credentials_hostname` - (optional) The hostname of a Terraform Cloud/Enterprise instance to 
   place within the credentials block of the Terraform CLI configuration file. Defaults to `app.terraform.io`.

- `cli_config_credentials_token` - (optional) The API token for a Terraform Cloud/Enterprise instance to
   place within the credentials block of the Terraform CLI configuration file.

- `terraform_version` - (optional) The version of Terraform CLI to install. Instead of a full version string,
   you can also specify a constraint string (see [Semver Ranges](https://www.npmjs.com/package/semver#ranges)
   for available range specifications). Examples are: `<0.14.0`, `~0.13.0`, `0.13.x` (all three installing
   the latest available 0.13 version). Prerelease versions can be specified and a range will stay within the
   given tag such as `beta` or `rc`. If no version is given, it will default to `latest`.

- `terraform_wrapper` - (optional) Whether to install a wrapper to wrap subsequent calls of 
   the `terraform` binary and expose its STDOUT, STDERR, and exit code as outputs
   named `stdout`, `stderr`, and `exitcode` respectively. Defaults to `true`.


## Outputs

This action does not configure any outputs directly. However, when you set the `terraform_wrapper` input
to `true`, the following outputs is available for subsequent steps that call the `terraform` binary.

- `stdout` - The STDOUT stream of the call to the `terraform` binary.

- `stderr` - The STDERR stream of the call to the `terraform` binary.

- `exitcode` - The exit code of the call to the `terraform` binary.





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


