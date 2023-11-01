#!/bin/bash

# Set AWS credentials as environment variables
export AWS_ACCESS_KEY_ID="your-access-key"
export AWS_SECRET_ACCESS_KEY="your-secret-key"
export AWS_DEFAULT_REGION="us-east-1"  # Change to your desired AWS region

# Set the organization name
ORG_NAME="your-organization-name"

# Use the GitHub API to get a list of repositories in the organization
REPOS=$(curl -s "https://api.github.com/orgs/$ORG_NAME/repos" | jq -r '.[].name')

# Loop through the repositories and back them up to S3
for REPO in $REPOS
do
    # Clone the repository
    git clone "https://github.com/$ORG_NAME/$REPO.git"
    
    # Backup the repository to S3
    aws s3 cp --recursive "$REPO" "s3://your-s3-bucket/$ORG_NAME/$REPO/$(date +%Y-%m-%d)/"
    
    # Clean up the cloned repository
    rm -rf "$REPO"
done
