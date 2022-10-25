##
## Module variables
##
variable "ecr_repo" {
  description = "AWS ECR repository name"
  type = string
  default = "functions/ubiquitous-guacamole"
}

variable "github_org" {
  description = "GitHub user/organization name"
  type = string
}

variable "github_repo" {
  description = "GitHub repository name"
  type = string
}
