provider "aws" {
	region = "${var.aws_region}"
}

# Create Role and Policies
module "role" {
	source = "./role"
}

# Create DynamoDB Tables
module "dynamodb" {
	source = "./dynamodb"
}

# Create Lambda Functions
module "lambda" {
	source = "./lambda"
	lambda_role_arn = "${module.role.feedback_lambda_role_arn}"
}

