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
#    attribute {
#      name = "Scores"
#      type = "N"
#    }
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
#    attribute {
#      name = "Scores"
#      type = "N"
#    }
}

#resource "aws_lambda_event_source_mapping" "event_source_mapping" {
#    batch_size = 100
#    event_source_arn = "arn:aws:kinesis:REGION:123456789012:stream/stream_name"
#    enabled = true
#    function_name = "arn:aws:lambda:REGION:123456789012:function:function_name"
#    starting_position = "TRIM_HORIZON|LATEST"
#}

#resource "aws_dynamodb_table" "basic-dynamodb-table" {
#    name = "feedbackScore"
#    read_capacity = 5
#    write_capacity = 5
#    hash_key = "feedbackScore"
#    range_key = "GameTitle"
#    attribute {
#      name = "UserId"
#      type = "S"
#    }
#    attribute {
#      name = "GameTitle"
#      type = "S"
#    }
#    attribute {
#      name = "TopScore"
#      type = "N"
#    }
#    global_secondary_index {
#      name = "GameTitleIndex"
#      hash_key = "GameTitle"
#      range_key = "TopScore"
#      write_capacity = 10
#      read_capacity = 10
#      projection_type = "INCLUDE"
#      non_key_attributes = [ "UserId" ]
#    }
#}
