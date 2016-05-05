resource "aws_lambda_function" "feedback-lambda" {
    filename = "../lambda-functions/feedback-lambda.zip"
    function_name = "FeedbackLambda3"
    role = "${var.lambda_role_arn}"
    handler = "feedback-lambda.handler"
    description = "Feedback Lambda 3"
    source_code_hash = "${base64sha256(file("../lambda-functions/feedback-lambda.zip"))}"
}

resource "aws_lambda_function" "feedback-aggregates-lambda" {
    filename = "../lambda-functions/feedback-aggregates-lambda.zip"
    function_name = "FeedbackAggregatesLambda3"
    role = "${var.lambda_role_arn}"
    handler = "feedback-aggregates-lambda.handler"
    description = "Feedback Aggregates Lambda 3"
    source_code_hash = "${base64sha256(file("../lambda-functions/feedback-aggregates-lambda.zip"))}"
}

resource "aws_lambda_function" "feedback-aggregates-scan-all-lambda" {
    filename = "../lambda-functions/feedback-aggregates-scan-all-lambda.zip"
    function_name = "FeedbackAggregatesScanAllLambda3"
    role = "${var.lambda_role_arn}"
    handler = "feedback-aggregates-scan-all-lambda.handler"
    description = "Feedback Aggregates Scan All Lambda 3"
    source_code_hash = "${base64sha256(file("../lambda-functions/feedback-aggregates-scan-all-lambda.zip"))}"
}

#arn:aws:lambda:)?([a-z]{2}-[a-z]+-\d{1}:)?(\d{12}:)?(function:)?([a-zA-Z0-9-_]+)(:(\$LATEST|[a-zA-Z0-9-_]+))?
#arn:aws:dynamodb:eu-west-1:656423721434:table/Feedback/stream/2015-11-15T23:42:28.652
#arn:aws:dynamodb:eu-west-1:656423721434:table/Feedback3

resource "aws_lambda_event_source_mapping" "event_source_mapping" {
    batch_size = 50
#    event_source_arn = "${var.aggregates_table_arn}/stream/LATEST"
    event_source_arn = "arn:aws:dynamodb:eu-west-1:656423721434:table/Feedback3/stream/2016-05-05T23:19:04.094"
    enabled = true
    function_name = "arn:aws:lambda:eu-west-1:656423721434:function:FeedbackAggregatesLambda3"
#    function_name = "${aws_lambda_function.feedback-aggregates-lambda.arn}"
#    function_name = "${aws_lambda_function.feedback-aggregates-lambda.arn}:LATEST"
    starting_position = "LATEST"
}
