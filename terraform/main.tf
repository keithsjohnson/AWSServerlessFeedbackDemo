provider "aws" {
	region = "${var.aws_region}"
}

resource "aws_iam_role" "feedback-role" {
    name = "feedback-role"
    assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_iam_policy_attachment" "feedback1" {
    name = "feedback-attachment"
    policy_arn = "arn:aws:iam::aws:policy/AWSLambdaFullAccess"
    roles = ["${aws_iam_role.feedback-role.name}"]
}

resource "aws_iam_policy_attachment" "feedback2" {
    name = "feedback-attachment"
    policy_arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
    roles = ["${aws_iam_role.feedback-role.name}"]
}

resource "aws_iam_policy_attachment" "feedback3" {
    name = "feedback-attachment"
    policy_arn = "arn:aws:iam::aws:policy/AmazonDynamoDBFullAccess"
    roles = ["${aws_iam_role.feedback-role.name}"]
}

resource "aws_iam_policy_attachment" "feedback4" {
    name = "feedback-attachment"
    policy_arn = "arn:aws:iam::aws:policy/AmazonSQSFullAccess"
    roles = ["${aws_iam_role.feedback-role.name}"]
}

resource "aws_iam_policy_attachment" "feedback5" {
    name = "feedback-attachment"
    policy_arn = "arn:aws:iam::aws:policy/AmazonSNSFullAccess"
    roles = ["${aws_iam_role.feedback-role.name}"]
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
