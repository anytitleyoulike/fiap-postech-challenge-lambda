resource "aws_lambda_function" "lambda" {
  role          = var.labRole
  function_name = "${var.projectName}-lambda"
  filename      = "lambda.zip"
  handler       = "handler.lambda_handler"
  runtime       = "python3.12"
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