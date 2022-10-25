
## Configure IAM and ECR resources for GitHub Actions run by _this_ repository
module "build" {
  source = "./modules/build"
  github_org = "jmanero"
  github_repo = "ubiquitous-guacamole"
}

output "ecr_repository_url" {
  value = module.build.ecr_repository_url
}

output "github_role_arn" {
  value = module.build.github_role_arn
}

module "app" {
  source = "./modules/app"
  image_uri = "${module.build.ecr_repository_url}:latest"
}
