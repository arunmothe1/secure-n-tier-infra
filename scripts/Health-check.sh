#!/bin/bash
# Endpoint verification script for AWS Application Load Balancer (ALB)

ALB_DNS=$1

if [ -z "$ALB_DNS" ]; then
    echo "Error: ALB DNS name missing."
    echo "Usage: ./health-check.sh <ALB_DNS_URL>"
    exit 1
fi

echo "Checking Application Health at: http://${ALB_DNS}/health"

# Send request to the ALB /health endpoint and capture HTTP status code
HTTP_STATUS=$(curl -s -o /dev/null -w "%{http_code}" "http://${ALB_DNS}/health")

if [ "$HTTP_STATUS" -eq 200 ]; then
    echo "SUCCESS: Application is LIVE & Healthy! (HTTP Status: 200)"
    exit 0
else
    echo "ERROR: Health check failed! (HTTP Status: ${HTTP_STATUS})"
    exit 1
fi
