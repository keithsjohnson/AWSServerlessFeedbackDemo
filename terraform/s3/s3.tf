
resource "aws_s3_bucket" "feedback3-bucket" {
    bucket = "demo-feedback3"
    acl = "public-read"
    policy = <<EOF
{
	"Version": "2012-10-17",
	"Statement": [
		{
			"Sid": "PublicReadGetObject",
			"Effect": "Allow",
			"Principal": "*",
			"Action": "s3:GetObject",
			"Resource": "arn:aws:s3:::demo-feedback3/index.html"
		}
	]
}
EOF
    website {
        index_document = "index.html"
    }
}

resource "aws_s3_bucket_object" "feedback3-index-html" {
  key        = "index.html"
  bucket     = "${aws_s3_bucket.feedback3-bucket.bucket}"
  source     = "./s3/index.html"
  content_type = "text/html"
  etag = "${base64sha256(file("./s3/index.html"))}"
#  source     = "../html/index.html"
#  kms_key_id = "${aws_kms_key.examplekms.arn}"
}
