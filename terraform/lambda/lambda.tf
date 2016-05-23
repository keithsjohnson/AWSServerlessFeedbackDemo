resource "aws_lambda_function" "feedback-lambda" {
    filename = "../lambda-functions/feedback-lambda.zip"
    function_name = "FeedbackLambda3"
    role = "${var.lambda_role_arn}"
    runtime = "${var.lambda_node_runtime}"
    handler = "feedback-lambda.handler"
    description = "Feedback Lambda 3"
    source_code_hash = "${base64sha256(file("../lambda-functions/feedback-lambda.zip"))}"
}

resource "aws_lambda_function" "feedback-aggregates-lambda" {
    filename = "../lambda-functions/feedback-aggregates-lambda.zip"
    function_name = "FeedbackAggregatesLambda3"
    role = "${var.lambda_role_arn}"
    runtime = "${var.lambda_node_runtime}"
    handler = "feedback-aggregates-lambda.handler"
    description = "Feedback Aggregates Lambda 3"
    source_code_hash = "${base64sha256(file("../lambda-functions/feedback-aggregates-lambda.zip"))}"
}

resource "aws_lambda_function" "feedback-aggregates-scan-all-lambda" {
    filename = "../lambda-functions/feedback-aggregates-scan-all-lambda.zip"
    function_name = "FeedbackAggregatesScanAllLambda3"
    role = "${var.lambda_role_arn}"
    runtime = "${var.lambda_node_runtime}"
    handler = "feedback-aggregates-scan-all-lambda.handler"
    description = "Feedback Aggregates Scan All Lambda 3"
    source_code_hash = "${base64sha256(file("../lambda-functions/feedback-aggregates-scan-all-lambda.zip"))}"
}

resource "aws_lambda_event_source_mapping" "event_source_mapping" {
    batch_size = 50
    event_source_arn = "${var.aggregates_table_stream_arn}"
    enabled = true
    function_name = "${aws_lambda_function.feedback-aggregates-lambda.arn}"
    starting_position = "LATEST"
}
