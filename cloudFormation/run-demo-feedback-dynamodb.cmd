@rem aws cloudformation delete-stack --stack-name demo-feedback-dynamodb

aws cloudformation create-stack --stack-name demo-feedback-dynamodb^
 --template-body file://demo-feedback-dynamodb.json
