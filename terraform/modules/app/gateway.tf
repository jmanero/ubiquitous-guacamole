##
## Contains API Gateway (v2) resources for the application
##

resource "aws_apigatewayv2_api" "gateway" {
  name          = var.app_name
  protocol_type = "HTTP"
}

# resource "aws_apigatewayv2_integration" "example" {
#   api_id           = aws_apigatewayv2_api.example.id
#   integration_type = "HTTP_PROXY"

#   integration_method = "POST"
#   integration_uri    = "https://example.com/{proxy}"
# }

# resource "aws_lambda_permission" "gateway" {
#   statement_id  = "AllowAPIGatewayInvoke"
#   action        = ""
#   function_name = function_name
#   principal     = ""

#   # The /*/* portion grants access from any method on any resource
#   # within the API Gateway "REST API".
#   source_arn = "${aws_apigatewayv2_api.gateway.execution_arn}/*/*"
# }


# resource "aws_apigatewayv2_route" "example" {
#   api_id    = aws_apigatewayv2_api.example.id
#   route_key = "ANY /example/{proxy+}"

#   target = "integrations/${aws_apigatewayv2_integration.example.id}"
# }

# resource "aws_apigatewayv2_deployment" "gateway" {
#   api_id      = aws_apigatewayv2_api.gateway.id
#   description = "Example deployment"

#   lifecycle {
#     create_before_destroy = true
#   }
# }

# output "base_url" {
#   value = aws_apigatewayv2_api.gateway.url
# }


## Create an IAM role and policy for the Lambda function
resource "aws_iam_role" "gateway" {
  name = "gateway-" + var.app_name

  description = "Role for ${var.app_name} gateway"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Effect": "Allow",
      "Principal": {
        "Service": "apigateway.amazonaws.com"
      }
    }
  ]
}
EOF
}

resource "aws_iam_policy" "gateway" {
  name        = "gateway-" + var.app_name
  path        = "/"
  description = "Policy for ${var.app_name} lambda function"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "lambda:InvokeFunction"
      ],
      "Effect": "Allow",
      "Resource": "${aws_lambda_function.function.arn}"
    }
  ]
}
EOF

  depends_on = [
    aws_lambda_function.function,
  ]
}

resource "aws_iam_role_policy_attachment" "gateway" {
  role       = aws_iam_role.gateway.name
  policy_arn = aws_iam_policy.gateway.arn
}
