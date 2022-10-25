##
## Configure AWS resource access and ECR repository for GitHub actions
##

## Create an ECR repository for lambda images
resource "aws_ecr_repository" "function" {
  name                 = var.ecr_repo
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }
}

## Create an OIDC provider for GitHub
resource "aws_iam_openid_connect_provider" "github" {
  url             = "https://token.actions.githubusercontent.com"
  client_id_list  = ["sts.amazonaws.com"]
  thumbprint_list = ["6938fd4d98bab03faadb97b34396831e3780aea1"]
}

## Create an IAM role and policy for GitHub Actions to push to ECR
resource "aws_iam_role" "github" {
  name = join("-", ["github", var.github_org, var.github_repo])

  description = "Role for GitHub Actions in ${var.github_org}/${var.github_repo}"
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = ["sts:AssumeRoleWithWebIdentity"],
        Effect = "Allow",
        Principal = {
          Federated = aws_iam_openid_connect_provider.github.arn
        },
        Condition = {
          StringLike = {
            "token.actions.githubusercontent.com:sub" = "repo:${var.github_org}/${var.github_repo}:*"
          },
          "ForAllValues:StringEquals" = {
            "token.actions.githubusercontent.com:iss" = "https://token.actions.githubusercontent.com",
            "token.actions.githubusercontent.com:aud" = "sts.amazonaws.com",
          },
        }
      }
    ],
  })
}

resource "aws_iam_policy" "github" {
  name        = join("-", ["github", var.github_org, var.github_repo])
  path        = "/"
  description = "Policy for GitHub Actions to push container-images to ECR"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = [
          "ecr:GetAuthorizationToken",
        ],
        Effect   = "Allow",
        Resource = "*",
      },
      {
        Action = [
          "ecr:BatchGetImage",
          "ecr:BatchCheckLayerAvailability",
          "ecr:CompleteLayerUpload",
          "ecr:GetDownloadUrlForLayer",
          "ecr:InitiateLayerUpload",
          "ecr:PutImage",
          "ecr:UploadLayerPart"
        ],
        Effect   = "Allow",
        Resource = aws_ecr_repository.function.arn,
      }
    ],
  })
}

resource "aws_iam_role_policy_attachment" "github" {
  role       = aws_iam_role.github.name
  policy_arn = aws_iam_policy.github.arn
}
