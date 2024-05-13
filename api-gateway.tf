resource "aws_api_gateway_rest_api" "fastfood_api" {
  name        = "${var.projectName}-auth"
  description = "Postech challenge FIAP FastFood"
}

resource "aws_api_gateway_resource" "api_resource" {
  rest_api_id = aws_api_gateway_rest_api.fastfood_api.id
  parent_id   = aws_api_gateway_rest_api.fastfood_api.root_resource_id
  path_part   = "login"
}


resource "aws_api_gateway_method" "api_method" {
  rest_api_id   = aws_api_gateway_rest_api.fastfood_api.id
  resource_id   = aws_api_gateway_resource.api_resource.id
  http_method   = "POST"
  authorization = "NONE"
}

# Enable CORS for API Gateway method
# resource "aws_api_gateway_method_response" "my_api_method_response" {
#   rest_api_id = aws_api_gateway_rest_api.fastfood_api.id
#   resource_id = aws_api_gateway_resource.api_resource.id
#   http_method = aws_api_gateway_method.api_method.http_method
#   status_code = "200"

#   response_parameters = {
#     "method.response.header.Access-Control-Allow-Headers" = "'Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token,X-Amz-User-Agent'",
#     "method.response.header.Access-Control-Allow-Origin"  = "'*'"
#   }
# }

resource "aws_api_gateway_integration" "gateway_integration" {
  rest_api_id             = aws_api_gateway_rest_api.fastfood_api.id
  resource_id             = aws_api_gateway_resource.api_resource.id
  http_method             = aws_api_gateway_method.api_method.http_method
  integration_http_method = "POST"
  type                    = "AWS"
  uri                     = aws_lambda_function.lambda.invoke_arn
}

resource "aws_api_gateway_method_response" "api_response" {
  rest_api_id = aws_api_gateway_rest_api.fastfood_api.id
  resource_id = aws_api_gateway_resource.api_resource.id
  http_method = aws_api_gateway_method.api_method.http_method
  status_code = "200"
}

resource "aws_api_gateway_integration_response" "api_integration_response" {
  rest_api_id = aws_api_gateway_rest_api.fastfood_api.id
  resource_id = aws_api_gateway_resource.api_resource.id
  http_method = aws_api_gateway_method.api_method.http_method
  status_code = aws_api_gateway_method_response.api_response.status_code

  response_templates = {
    "application/json" = ""
  }

  depends_on = [
    aws_api_gateway_integration.gateway_integration
  ]
}

# resource "aws_api_gateway_integration_response" "options_integration_response" {
#   rest_api_id = aws_api_gateway_rest_api.fastfood_api.id
#   resource_id = aws_api_gateway_resource.api_resource.id
#   http_method = "OPTIONS"
#   status_code = "200"

#   response_parameters = {
#     "method.response.header.Access-Control-Allow-Headers"     = "'Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token'"
#     "method.response.header.Access-Control-Allow-Origin"      = "'*'"
#     "method.response.header.Access-Control-Allow-Credentials" = "'false'"
#   }
# }

resource "aws_api_gateway_deployment" "deployment" {
  depends_on  = [aws_api_gateway_integration.gateway_integration]
  rest_api_id = aws_api_gateway_rest_api.fastfood_api.id
  stage_name  = "dev"
}
