import boto3, os
from datetime import date, timedelta

def lambda_handler(event, context):
    ce = boto3.client("ce")
    ses = boto3.client("ses")

    # Get yesterday's cost
    end   = date.today()
    start = end - timedelta(days=1)

    response = ce.get_cost_and_usage(
        TimePeriod={"Start": start.isoformat(), "End": end.isoformat()},
        Granularity="DAILY",
        Metrics=["UnblendedCost"]
    )

    amount = response["ResultsByTime"][0]["Total"]["UnblendedCost"]["Amount"]

    # Format and send email
    subject = f"AWS Daily Cost Report ({start})"
    body    = f"Your AWS spend on {start}: ${float(amount):.2f}"

    ses.send_email(
        Source=os.environ["SES_SENDER"],
        Destination={"ToAddresses": [os.environ["SES_RECIPIENT"]]},
        Message={
            "Subject": {"Data": subject},
            "Body": {"Text": {"Data": body}}
        }
    )