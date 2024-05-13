resource "aws_cognito_user_pool" "user_pool" {
  name = "example-user-pool"

  #username_attributes = ["email"]

  #   schema {
  #     name                = "email"
  #     attribute_data_type = "String"
  #     mutable             = true
  #     required            = true
  #   }


  password_policy {
    minimum_length    = 6
    require_lowercase = false
    require_numbers   = false
    require_symbols   = false
    require_uppercase = false
  }
}

resource "aws_cognito_user_pool_client" "client" {
  name = "${var.projectName}-cognito-client"

  user_pool_id                  = aws_cognito_user_pool.user_pool.id
  generate_secret               = false
  refresh_token_validity        = 90
  prevent_user_existence_errors = "ENABLED"
  explicit_auth_flows = [
    "ALLOW_REFRESH_TOKEN_AUTH",
    "ALLOW_USER_PASSWORD_AUTH",
    "ALLOW_ADMIN_USER_PASSWORD_AUTH"
  ]
}