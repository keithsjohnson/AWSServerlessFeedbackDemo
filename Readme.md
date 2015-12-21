AWS Serverless Feedback Demo
----------------------------

Introduction
------------
AWS Demo using S3, API Gateway, NodeJS, Lambda and DynamoDB

This demo shows how to host a Dynamic Web Site on static AWS Simple Storage Service (S3) using jQuery .getJSON function to call API Gateway.
The API Gateway uses Lambda functions written on node.js to store feedback in DynamoDB.

- No Servers to build
- No Build or Build Pipeline

Author
------ 
Keith Johnson

URL
---
http://demo-feedback.s3-website-eu-west-1.amazonaws.com/

Status
------
In Progress

To Do
-----
1. Create AWS CloudFormation template to create and deploy application automatically.

2. Write up project from Notes below but using CloudFormation instead of AWS Console.

Notes (Below are Notes still to be written up)
----------------------------------------------

AWS Feedback Site

Create Lambda
-------------
Name: FeedbackLambda
Runtime: NodeJS
Handler: feedback.handler
Role: lambda_basic_execution
Description: 
Code: /lambda-functions/feedback-lambda/app.js

Test JSON
{
  "score": 5,
  "feedback": "excellent"
}

API Gateway
-----------

New API
-------
API Name: FeedbackAPI
Description Feedback API

Model
-----
Model Name: FeedbackModel
Content Type: application/json
Description: Feedback Model
Model Schema: /api-gateway/feedback-model.txt


Stage
-----
Stage: feedback
Invoke URL: 
https://eajybqsd7b.execute-api.eu-west-1.amazonaws.com/feedback/?score=1&feedback=Hello

GET
---
Resources: Integration Request
Content Type: application/json
Input Mapping: /api-gateway/input-mapping.txt


Chrome Postman
Post: https://eajybqsd7b.execute-api.eu-west-1.amazonaws.com/feedback
Body: raw
JSON(application/json)

POST Setup
----------
Integration Type: Lambda Function
Lambda Region: eu-west-1
Lambda function: FeedbackHandler

POST - Method Request
-------------------
Request Models:
Add Model:
ContentType: application/json
ModelName: FeedbackModel


Aggregate Lambda
Name: FeedbackAggregatesLambda
Code: /lambda-functions/feedback-aggregates-lambda/app.js

DynamoDB
---------
Feedback feedbackScore
FeedbackAggregates feedbackScore


DynamoDB Scan Example
Name: FeedbackAggregatesScanAllLambda
Code: /lambda-functions/feedback-aggregates-scan-all-lambda/app.js

https://eajybqsd7b.execute-api.eu-west-1.amazonaws.com/feedback/totals
http://demo-feedback.s3-website-eu-west-1.amazonaws.com/

S3 Files
--------
/html/index.html

Reference
---------
AWS Labs Project
https://github.com/keithsjohnson/lambda-refarch-webapp

https://github.com/awslabs/lambda-apigateway-twilio-tutorial

https://github.com/awslabs/lambda-refarch-fileprocessing

