#############################
# main.tf
#############################

provider "aws" {
  region = "us-east-1" # or your SES-supported region
}

# ---- IAM Role for Lambda ----
resource "aws_iam_role" "lambda_role" {
  name = "daily-cost-reporter-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action    = "sts:AssumeRole"
      Effect    = "Allow"
      Principal = {
        Service = "lambda.amazonaws.com"
      }
    }]
  })
}

# Attach policies for Cost Explorer + SES + CloudWatch logs
resource "aws_iam_role_policy" "lambda_policy" {
  name = "daily-cost-reporter-policy"
  role = aws_iam_role.lambda_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect   = "Allow"
        Action   = [
          "ce:GetCostAndUsage",
          "ses:SendEmail",
          "ses:SendRawEmail",
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ]
        Resource = "*"
      }
    ]
  })
}

# ---- Lambda Function ----
resource "aws_lambda_function" "daily_cost_report" {
  function_name = "daily-cost-report"
  role          = aws_iam_role.lambda_role.arn
  handler       = "lambda_function.lambda_handler"
  runtime       = "python3.12"

  # Your packaged Lambda code (zip containing lambda_function.py)
  filename         = "${path.module}/lambda_package.zip"
  source_code_hash = filebase64sha256("${path.module}/lambda_package.zip")

  environment {
    variables = {
      SES_SENDER    = "email"
      SES_RECIPIENT = "email"
    }
  }
}

# ---- EventBridge Rule (Daily trigger) ----
resource "aws_cloudwatch_event_rule" "daily_trigger" {
  name                = "daily-cost-report-trigger"
  description         = "Triggers Lambda every day at 09:00 UTC"
  schedule_expression = "cron(0 9 * * ? *)"
}

resource "aws_cloudwatch_event_target" "daily_target" {
  rule      = aws_cloudwatch_event_rule.daily_trigger.name
  target_id = "daily-cost-report"
  arn       = aws_lambda_function.daily_cost_report.arn
}

# Allow EventBridge to invoke Lambda
resource "aws_lambda_permission" "allow_eventbridge" {
  statement_id  = "AllowExecutionFromEventBridge"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.daily_cost_report.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.daily_trigger.arn
}

# ---- SES Domain/Email (must verify manually if domain is new) ----
resource "aws_ses_email_identity" "sender" {
  email = "email"
}