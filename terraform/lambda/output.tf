output "feedback_aggregates_lambda_function_arn" {
    value = "${aws_lambda_function.feedback-lambda.arn}"
}
output "feedback_aggregates_scan_all_lambda_function_arn" {
    value = "${aws_lambda_function.feedback-aggregates-scan-all-lambda.arn}"
}
