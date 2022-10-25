##
## Outputs
##
output "ecr_repository_url" {
  description = "URI for the ECR repository that GitHub actions should push to"
  value = aws_ecrpublic_repository.function.repository_uri
}

output "github_role_arn" {
  description = "ARN for `aws-actions/configure-aws-credentials@v1` actions `role-to-assume` argument in GitHub Workflow configurations"
  value = aws_iam_role.github.arn
}
