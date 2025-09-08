variable "region" {
  description = "AWS region to deploy into"
  type        = string
  default     = "us-east-1"
}

variable "ses_sender" {
  description = "Verified SES email address to send from"
  type        = string
}

variable "ses_recipient" {
  description = "Email address to receive cost reports"
  type        = string
}

variable "schedule_expression" {
  description = "EventBridge schedule expression (default = daily 9 AM)"
  type        = string
  default     = "cron(0 9 * * *)"
}