output "lambda_function_name" {
  value = aws_lambda_function.daily_cost_report.function_name
}

output "eventbridge_rule" {
  value = aws_cloudwatch_event_rule.daily_trigger.name
}