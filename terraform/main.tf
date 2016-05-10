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
	aggregates_table_arn = "${module.dynamodb.feedback_aggregates_table_arn}"
	aggregates_table_stream_arn = "${module.dynamodb.feedback_aggregates_table_stream_arn}"
}

# Create API Gateway
module "apigateway" {
	source = "./apigateway"
	aggregates_lambda_function_arn = "${module.lambda.feedback_aggregates_lambda_function_arn}"
	aggregates_scan_all_lambda_function_arn = "${module.lambda.feedback_aggregates_scan_all_lambda_function_arn}"
	lambda_role_arn = "${module.role.feedback_lambda_role_arn}"
	apigateway_role_arn = "${module.role.feedback_apigateway_role_arn}"
}

# Create S3
module "s3" {
	source = "./s3"
}
