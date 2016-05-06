output "feedback_aggregates_table_arn" {
    value = "${aws_dynamodb_table.Feedback3.arn}"
}
output "feedback_aggregates_table_stream_arn" {
    value = "${aws_dynamodb_table.Feedback3.stream_arn}"
}
