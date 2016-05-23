resource "aws_dynamodb_table" "Feedback3" {
    name = "Feedback3"
    read_capacity = 5
    write_capacity = 5
    hash_key = "feedbackScore"
    attribute {
      name = "feedbackScore"
      type = "S"
    }
    stream_enabled = "true"
    stream_view_type = "NEW_AND_OLD_IMAGES"
}

resource "aws_dynamodb_table" "FeedbackAggregates3" {
    name = "FeedbackAggregates3"
    read_capacity = 5
    write_capacity = 5
    hash_key = "feedbackScore"
    attribute {
      name = "feedbackScore"
      type = "S"
    }
}
