output "feedback_lambda_role_arn" {
    value = "${aws_iam_role.feedback-lambda-role.arn}"
}

output "feedback_apigateway_role_arn" {
    value = "${aws_iam_role.feedback-apigateway-role.arn}"
}

