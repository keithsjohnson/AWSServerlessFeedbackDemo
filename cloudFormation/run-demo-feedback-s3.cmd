@rem aws cloudformation delete-stack --stack-name demo-feedback-s3

aws cloudformation create-stack --stack-name demo-feedback-s3^
 --template-body file://demo-feedback-s3.json

@rem aws cloudformation create-stack --stack-name demo-feedback^
@rem  --template-body file://demo-feedback.json^
@rem  --parameters ParameterKey=S3Bucket,ParameterValue=feedbackdemo2

