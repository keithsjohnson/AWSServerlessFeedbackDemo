resource "aws_iam_role" "feedback-lambda-role" {
    name = "feedback-lambda-role"
    assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": ["lambda.amazonaws.com"]
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
        "Service": ["apigateway.amazonaws.com"]
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "feedback-lambda-role-inline-policy" {
    name = "feedback-lambda-role-inline-policy"
    role = "${aws_iam_role.feedback-lambda-role.id}"
    policy = <<EOF
{
  "Version":"2012-10-17",
  "Statement":[
    {"Resource": ["arn:aws:logs:*:*:*"],
     "Action": ["logs:*"],
     "Effect": "Allow"
    },
    {"Resource":"*",
     "Action":["lambda:*", "dynamodb:*", "cloudwatch:*"],
     "Effect":"Allow"
    }
   ]
}
EOF
}

resource "aws_iam_role_policy" "feedback-apigateway-role-inline-policy" {
    name = "feedback-apigateway-role-inline-policy"
    role = "${aws_iam_role.feedback-apigateway-role.id}"
    policy = <<EOF
{
  "Version":"2012-10-17",
  "Statement":[
    {"Resource": ["arn:aws:logs:*:*:*"],
     "Action": ["logs:*"],
     "Effect": "Allow"
    },
    {"Resource":"*",
     "Action":["lambda:*", "dynamodb:*", "cloudwatch:*"],
     "Effect":"Allow"
    }
   ]
}
EOF
}
