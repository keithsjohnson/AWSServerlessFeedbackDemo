@rem aws cloudformation delete-stack --stack-name demo-feedback-lambda

aws cloudformation create-stack --stack-name demo-feedback-lambda^
 --template-body file://demo-feedback-lambda.json --capabilities CAPABILITY_IAM
