resource "aws_lambda_function" "lambda" {
  role          = var.labRole
  function_name = "authentication"
  filename      = "lambda.zip"
  handler       = "handler.lambda_handler"
  runtime       = "python3.12"
}

resource "aws_lambda_permission" "example_lambda_permission" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.lambda.function_name
  principal     = "apigateway.amazonaws.com"

  source_arn = "${aws_api_gateway_rest_api.fastfood_api.execution_arn}/*/*"
}

# # IAM
# data "aws_iam_policy_document" "assume_role" {
#   statement {
#     effect = "Allow"

#     principals {
#       type        = "Service"
#       identifiers = ["lambda.amazonaws.com"]
#     }

#     actions   = ["sts:AssumeRole"]
#     resources = [var.labRole]
#   }
# }

# resource "aws_iam_role" "role" {
#   name               = "myrole"
#   assume_role_policy = data.aws_iam_policy_document.assume_role.json
# }