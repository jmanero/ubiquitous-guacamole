##
## Contains Lambda resources for the application
##

resource "aws_lambda_function" "function" {
  function_name = var.app_name
  role          = aws_iam_role.function.arn

  runtime      = "go1.x"
  package_type = "Image"
  image_uri    = var.image_uri
}

## Collect logs from the lambda function
resource "aws_cloudwatch_log_group" "function" {
  name              = "/aws/lambda/${var.app_name}"
  retention_in_days = 14
}

## Create an IAM role and policy for the Lambda function
resource "aws_iam_role" "function" {
  name = "function-${var.app_name}"

  description        = "Role for ${var.app_name} lambda function"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Effect": "Allow",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      }
    }
  ]
}
EOF
}

resource "aws_iam_policy" "function" {
  name        = "function-${var.app_name}"
  path        = "/"
  description = "Policy for ${var.app_name} lambda function"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "logs:CreateLogStream",
        "logs:PutLogEvents"
      ],
      "Effect": "Allow",
      "Resource": "${aws_cloudwatch_log_group.function.arn}"
    },
    {
      "Action": [
        "s3:GetObject"
      ],
      "Effect": "Allow",
      "Resource": "${aws_s3_bucket.state.arn}"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "function" {
  role       = aws_iam_role.function.name
  policy_arn = aws_iam_policy.function.arn
}
