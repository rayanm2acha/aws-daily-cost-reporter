# AWS Daily Cost Reporter

Get a daily summary of your AWS spend delivered straight to your inbox.

This project provisions an AWS Lambda function that:
- Uses the Cost Explorer API to fetch yesterday’s spend
- Sends the result via Amazon SES
- Runs automatically every day via EventBridge

## 🚀 Deployment

### Prerequisites
- [Terraform](https://www.terraform.io/downloads.html) installed
- AWS credentials configured
- Verified email/domain in SES (for sending reports)

### Setup
1. Clone this repo:
   ```bash
   git clone https://github.com/<your-username>/aws-daily-cost-reporter.git
   cd aws-daily-cost-reporter/terraform