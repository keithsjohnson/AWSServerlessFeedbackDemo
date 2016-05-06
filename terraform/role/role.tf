resource "aws_iam_role" "feedback-lambda-role" {
    name = "feedback-lambda-role"
    assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": ["apigateway.amazonaws.com",
                    "lambda.amazonaws.com"]
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_iam_role" "feedback-apigateway-role" {
    name = "feedback-apigateway-role"
    assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": ["apigateway.amazonaws.com",
                    "lambda.amazonaws.com"]
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_iam_policy_attachment" "feedback-lambda-1" {
    name = "feedback-attachment-lambda-1"
    policy_arn = "arn:aws:iam::aws:policy/AWSLambdaFullAccess"
    roles = ["${aws_iam_role.feedback-lambda-role.name}"]
}

resource "aws_iam_policy_attachment" "feedback-lambda-2" {
    name = "feedback-attachment-lambda-2"
    policy_arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
    roles = ["${aws_iam_role.feedback-lambda-role.name}"]
}

resource "aws_iam_policy_attachment" "feedback-lambda-3" {
    name = "feedback-attachment-lambda-3"
    policy_arn = "arn:aws:iam::aws:policy/AmazonDynamoDBFullAccess"
    roles = ["${aws_iam_role.feedback-lambda-role.name}"]
}

resource "aws_iam_policy_attachment" "feedback-lambda-4" {
    name = "feedback-attachment-lambda-4"
    policy_arn = "arn:aws:iam::aws:policy/AmazonSQSFullAccess"
    roles = ["${aws_iam_role.feedback-lambda-role.name}"]
}

resource "aws_iam_policy_attachment" "feedback-lambda-5" {
    name = "feedback-attachment-lambda-5"
    policy_arn = "arn:aws:iam::aws:policy/AmazonSNSFullAccess"
    roles = ["${aws_iam_role.feedback-lambda-role.name}"]
}

resource "aws_iam_policy_attachment" "feedback-lambda-6" {
    name = "feedback-attachment-lambda-6"
    policy_arn = "arn:aws:iam::aws:policy/AmazonAPIGatewayInvokeFullAccess"
    roles = ["${aws_iam_role.feedback-lambda-role.name}"]
}


resource "aws_iam_policy_attachment" "feedback-apigateway-1" {
    name = "feedback-attachment-apigateway-1"
    policy_arn = "arn:aws:iam::aws:policy/AWSLambdaFullAccess"
    roles = ["${aws_iam_role.feedback-apigateway-role.name}"]
}

resource "aws_iam_policy_attachment" "feedback-apigateway-2" {
    name = "feedback-attachment-apigateway-2"
    policy_arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
    roles = ["${aws_iam_role.feedback-apigateway-role.name}"]
}

resource "aws_iam_policy_attachment" "feedback-apigateway-3" {
    name = "feedback-attachment-apigateway-3"
    policy_arn = "arn:aws:iam::aws:policy/AmazonDynamoDBFullAccess"
    roles = ["${aws_iam_role.feedback-apigateway-role.name}"]
}

resource "aws_iam_policy_attachment" "feedback-apigateway-4" {
    name = "feedback-attachment-apigateway-4"
    policy_arn = "arn:aws:iam::aws:policy/AmazonSQSFullAccess"
    roles = ["${aws_iam_role.feedback-apigateway-role.name}"]
}

resource "aws_iam_policy_attachment" "feedback-apigateway-5" {
    name = "feedback-attachment-apigateway-5"
    policy_arn = "arn:aws:iam::aws:policy/AmazonSNSFullAccess"
    roles = ["${aws_iam_role.feedback-apigateway-role.name}"]
}

resource "aws_iam_policy_attachment" "feedback-apigateway-6" {
    name = "feedback-attachment-apigateway-6"
    policy_arn = "arn:aws:iam::aws:policy/AmazonAPIGatewayInvokeFullAccess"
    roles = ["${aws_iam_role.feedback-apigateway-role.name}"]
}




#resource "aws_iam_policy" "foo" {
#    name = "example-policy"
#    description = "An example policy"
#    policy = <<EOF
#{
#  "Version": "2012-10-17",
#  "Statement": [
#    {
#      "Action": [
#        "ec2:*"
#      ],
#      "Effect": "Allow",
#      "Resource": "*"
#    }
#  ]
#}
#EOF
#}

#resource "aws_iam_policy_attachment" "foo" {
#    name = "example-attachment"
#    policy_arn = "${aws_iam_policy.foo.arn}"
#    roles = ["${aws_iam_role.foo.name}"]
#}

#resource "aws_iam_role" "test_role" {
#    name = "test_role"
#    assume_role_policy = <<EOF
#{
#  "Version": "2012-10-17",
#  "Statement": [
#    {
#      "Action": "sts:AssumeRole",
#      "Principal": {
#        "Service": "ec2.amazonaws.com"
#      },
#      "Effect": "Allow",
#      "Sid": ""
#    }
#  ]
#}
#EOF
#}

#resource "aws_iam_policy" "policy" {
#    name = "a_test_policy"
#    path = "/"
#    description = "My test policy"
#    policy = <<EOF
#{
#  "Version": "2012-10-17",
#  "Statement": [
#    {
#      "Action": [
#        "ec2:Describe*"
#      ],
#      "Effect": "Allow",
#      "Resource": "*"
#    }
#  ]
#}
#EOF
#}

#resource "aws_iam_role" "test_role2" {
#    name = "test_role2"
#    assume_role_policy = "${aws_iam_policy.policy.name}"
#}

#resource "aws_iam_role" "foo" {
#    name = "example-role"
#    assume_role_policy = "${aws_iam_policy.policy.name}"
#}

#resource "aws_iam_policy" "foo" {
#    name = "example-policy"
#    description = "An example policy"
#    policy = "a_test_policy"
#}

#resource "aws_iam_policy_attachment" "foo" {
#    name = "example-attachment"
#    policy_arn = "${aws_iam_policy.foo.arn}"
#    roles = ["${aws_iam_role.foo.name}"]
#}

#resource "aws_iam_role_policy" "policy" {
#    name = "test_role_policy"
#    role = "iam_for_lambda"
#    policy = "test_policy"
#}


#resource "aws_iam_role" "iam_for_lambda" {
#    name = "iam_for_lambda"
#    assume_role_policy = <<EOF
#{
#  "Version": "2012-10-17",
#  "Statement": [
#    {
#      "Action": [
#      	"sts:AssumeRole"
#      ],
#      "Principal": {
#        "Service": "lambda.amazonaws.com"
#      },
#      "Effect": "Allow",
#      "Sid": ""
#    }
#  ]
#}
#EOF
#}


#resource "aws_iam_role_policy" "policy" {
#    name = "test_role_policy"
#    role = "iam_for_lambda"
#    policy = <<EOF
#{
#  "Version": "2012-10-17",
#  "Statement": [
#    {
#      "Action": [
#        "sts:Describe*"
#      ],
#      "Effect": "Allow",
#      "Resource": "*"
#    }
#  ]
#}
#EOF
#}


#resource "aws_lambda_function" "test_lambda" {
#    filename = "lambda_function_payload.zip"
#    function_name = "lambda_function_name"
#    role = "${aws_iam_role.iam_for_lambda.arn}"
#    handler = "exports.test"
#    source_code_hash = "${base64sha256(file("lambda_function_payload.zip"))}"
#}
