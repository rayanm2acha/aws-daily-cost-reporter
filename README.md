AWS Daily Cost Reporter

Get a daily summary of your AWS spend delivered straight to your inbox.
Never be surprised by the bill at the end of the month again.

This project provisions an AWS Lambda function (via Terraform) that:
	•	📊 Queries the Cost Explorer API for yesterday’s cost
	•	📧 Sends a formatted email via Amazon SES
	•	⏰ Runs automatically every day using Amazon EventBridge

⸻

🖼️ Architecture

EventBridge (daily cron)
        │
        ▼
     Lambda ───> Cost Explorer API
        │
        ▼
       SES ───> Your Inbox


⸻

🛠 Prerequisites
	•	Terraform installed
	•	AWS credentials configured in your environment
	•	Verified email identity in SES (for sender & recipient)
👉 SES sandbox mode requires both sender and recipient to be verified

⸻

⚡ Quick Start
	1.	Clone the repository

git clone https://github.com/<your-username>/aws-daily-cost-reporter.git
cd aws-daily-cost-reporter/terraform


	2.	Package the Lambda function

cd ../lambda
zip ../terraform/lambda_package.zip lambda_function.py
cd ../terraform


	3.	Deploy with Terraform

terraform init
terraform apply \
  -var ses_sender="noreply@yourdomain.com" \
  -var ses_recipient="you@example.com"


	4.	Check your inbox
You should receive your first AWS cost report the next day at the scheduled time.

⸻

⚙️ Configuration

You can adjust behavior using variables in variables.tf:

Variable	Default	Description
region	us-east-1	AWS region (SES must be available)
ses_sender	— (required)	Verified SES sender email
ses_recipient	— (required)	Recipient email address
schedule_expression	cron(0 9 * * ? *)	EventBridge schedule (default = 09:00 UTC daily)

📌 Example: run at midnight UTC instead:

schedule_expression = "cron(0 0 * * ? *)"


⸻

🔍 Example Email Output

Subject: AWS Daily Cost Report (2025-09-06)

Your AWS spend on 2025-09-06: $3.42

You can easily extend the Lambda code to include:
	•	Service-level breakdowns (EC2, S3, RDS, etc.)
	•	Weekly or monthly reports
	•	Cost anomaly detection

⸻

🛑 Cleanup

To remove all resources:

terraform destroy

This will delete the Lambda, IAM roles, EventBridge rule, and SES identity (if managed by Terraform).

⸻

🤝 Contributing

Pull requests and issues are welcome!
If you’d like to enhance the Lambda with richer reporting or dashboards, feel free to fork and submit improvements.

⸻

📜 License

This project is licensed under the MIT License – see LICENSE.