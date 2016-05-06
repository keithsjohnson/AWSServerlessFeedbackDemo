resource "aws_api_gateway_rest_api" "FeedbackAPI3" {
  name = "FeedbackAPI3"
  description = "Feedback API 3 Demo Created using Terraform"
}

resource "aws_api_gateway_resource" "FeedbackAPI3" {
  rest_api_id = "${aws_api_gateway_rest_api.FeedbackAPI3.id}"
  parent_id = "${aws_api_gateway_rest_api.FeedbackAPI3.root_resource_id}"
  path_part = "FeedbackAPI3"
}

resource "aws_api_gateway_model" "FeedbackModel3" {
  rest_api_id = "${aws_api_gateway_rest_api.FeedbackAPI3.id}"
#  rest_api_id = "${aws_api_gateway_model.FeedbackModel3.id}"
  name = "FeedbackModel3"
  description = "FeedbackModel3 Request Schema"
  content_type = "application/json"
  schema = <<EOF
{
  "$schema": "http://json-schema.org/draft-04/schema#",
  "title": "FeedbackModel3",
  "type": "array",
  "items": {
    "type": "object",
    "properties": {
      "feedback": { "type": "integer", "minimum": 1, "maximum": 5 }
    }
  }
}
EOF
}

resource "aws_api_gateway_method" "FeedbackAPI3" {
  rest_api_id = "${aws_api_gateway_rest_api.FeedbackAPI3.id}"
  resource_id = "${aws_api_gateway_resource.FeedbackAPI3.id}"
  request_models = {"application/json" = "FeedbackModel3"}
  http_method = "POST"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "FeedbackAPI3" {
  rest_api_id = "${aws_api_gateway_rest_api.FeedbackAPI3.id}"
  resource_id = "${aws_api_gateway_resource.FeedbackAPI3.id}"
  http_method = "${aws_api_gateway_method.FeedbackAPI3.http_method}"
  type = "AWS"
  uri = "arn:aws:apigateway:eu-west-1:lambda:path/2015-03-31/functions/arn:${var.aggregates_lambda_function_arn}"
  integration_http_method = "POST"
  credentials = "${var.apigateway_role_arn}"
}

resource "aws_api_gateway_method_response" "200" {
  rest_api_id = "${aws_api_gateway_rest_api.FeedbackAPI3.id}"
  resource_id = "${aws_api_gateway_resource.FeedbackAPI3.id}"
  http_method = "${aws_api_gateway_method.FeedbackAPI3.http_method}"
  status_code = "200"
}

resource "aws_api_gateway_integration_response" "FeedbackAPI3IntegrationResponse" {
  rest_api_id = "${aws_api_gateway_rest_api.FeedbackAPI3.id}"
  resource_id = "${aws_api_gateway_resource.FeedbackAPI3.id}"
  http_method = "${aws_api_gateway_method.FeedbackAPI3.http_method}"
  status_code = "${aws_api_gateway_method_response.200.status_code}"
}

