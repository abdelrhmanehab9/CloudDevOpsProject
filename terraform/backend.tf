# ============================================
# File: terraform/backend.tf
# Purpose: S3 backend configuration for state management
# ============================================

terraform {
  backend "s3" {
    bucket         = "clouddevopsproject11"
    key            = "clouddevops/terraform.tfstate"
    region         = "us-east-1" 
    encrypt        = true
    dynamodb_table = "terraform-state-lock" # Optional: for state locking
  }
}

# ============================================
# IMPORTANT: Before using this backend:
# ============================================
# 
# 1. Create S3 bucket manually first:
#    aws s3api create-bucket \
#      --bucket clouddevops-terraform-state-YOUR_UNIQUE_ID \
#      --region us-east-1
# 
# 2. Enable versioning:
#    aws s3api put-bucket-versioning \
#      --bucket clouddevops-terraform-state-YOUR_UNIQUE_ID \
#      --versioning-configuration Status=Enabled
# 
# 3. Optional - Create DynamoDB table for state locking:
#    aws dynamodb create-table \
#      --table-name terraform-state-lock \
#      --attribute-definitions AttributeName=LockID,AttributeType=S \
#      --key-schema AttributeName=LockID,KeyType=HASH \
#      --billing-mode PAY_PER_REQUEST \
#      --region us-east-1
#
# 4. If you want to test WITHOUT backend first:
#    - Comment out this entire file
#    - Run terraform init, plan, apply
#    - Then uncomment and run: terraform init -migrate-state
# ============================================
