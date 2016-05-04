resource "aws_lambda_function" "test_lambda" {
    filename = "./lambda/feedback-lambda.zip"
    function_name = "FeedbackLambda3"
    role = "${var.lambda_role_arn}"
    handler = "exports.handler"
    description = "Feedback Lambda 3"
    source_code_hash = "${base64sha256(file("./lambda/feedback-lambda.zip"))}"
}
