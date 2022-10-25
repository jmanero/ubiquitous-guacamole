## Variables
variable "app_name" {
  type = string
  default = "ubiquitous-guacamole"
}

variable "image_uri" {
  type = string
  description = "value"
}

data "aws_caller_identity" "current" {}

locals {
  unique_id = sha1(data.aws_caller_identity.current.account_id)

  ## Append a hash derived from the AWS account ID if the default app-name is
  ## used. This avoids naming collisions in global (s3 bucket) resources.
  unique_name = var.app_name == "ubiquitous-guacamole" ? "${var.app_name}-${local.unique_id}" : var.app_name
}
