AWS Serverless Feedback Demo
----------------------------

Introduction
------------
AWS Demo using S3, API Gateway, NodeJS, Lambda and DynamoDB

This demo shows how to host a Dynamic Web Site on static AWS Simple Storage Service (S3) using jQuery .getJSON function to call API Gateway.
The API Gateway uses Lambda functions written on node.js to store feedback in DynamoDB.

Author
------ 
Keith Johnson

URL
---
http://demo-feedback.s3-website-eu-west-1.amazonaws.com/

Status
------
In Progress

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
Lambda function: arn:aws:lambda:eu-west-1:656423721434:function:FeedbackHandler

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

Future Updates - Still to do
----------------------------

Feedback Questionnaire
----------------------

DynamoDB Tables
---------------
---------------
FeedbackQuestionnaires
----------------------
Key: fbqn1
Description: Spring Boot SPN

FeedbackQuestions
Key: fbqn1.fb1
Question: What did you think of the Spring Boot SPN?
Key: fbqn1.fb2
Question: Would you attend another Spring related SPN?

FeedbackQuestionAnswers
-----------------------
Key: fbqn1.fb1.q1
Answer: Very Poor
Key: fbqn1.fb1.q2
Answer: Not Relevant
Key: fbqn1.fb1.q3
Answer: Average
Key: fbqn1.fb1.q4
Answer: Very Good
Key: fbqn1.fb1.q5
Answer: Excellent
Key: fbqn1.fb2.q1
Answer: Yes
Key: fbqn1.fb2.q2
Answer: No

FeedbackQuestionResults
-----------------------
Key: fbqn1.fb1.q<n>.<rnd>
Count: <Count>
Key: fbqn1.fb2.q<n>.<rnd>
Count: <Count>

FeedbackQuestionAggregateResults
--------------------------------
Key: fbqn1.fb1.q<n>
AggregateQuestionCount: <Count>
Key: fbqn1.fb2.q<n>
AggregateQuestionCount: <Count>

FeedbackCommentQuestions
------------------------
Key: fbqn1.c1
CommentQuestion: What did you think of the Spring Boot SPN?
Key: fbqn1.c2
CommentQuestion: How could the Spring Boot SPN be improved?

FeedbackComments
----------------
Key: fbqn1.c1
Comment: OK but a little long.
Key: fbqn1.c2
Comment: Make it shorter.

Lambdas
-------
-------
GetAllFeedbackQuestionairesLamda
--------------------------------

Request
-------
None

Response
--------
[{
"Key": "fbqn1",
"Description": "Spring Boot SPN"
}]

GetFeedbackQuestionsForQuestionnaireLambda
------------------------------------------
Request
-------
FeedbackQuestionaireKey="fbqn1"

Response
--------
[{
	"FeedbackQuestions":
	[	
		{
			"Key": "fbqn1.fb1",
			"Question": "What did you think of the Spring Boot SPN?",
			"Answers":[{
				"Key":"fbqn1.fb1.q1",
				"Answer":"Very Poor"
				},{
				"Key":"fbqn1.fb1.q2",
				"Answer":"Not Relevant"
				},{
				"Key":"fbqn1.fb1.q3",
				"Answer":"Average"
				},{
				"Key":"fbqn1.fb1.q4",
				"Answer":"Very Good"
				},{
				"Key":"fbqn1.fb1.q5",
				"Answer":"Excellent"
				}]
		},{
			"Key": "fbqn1.fb2"
			"Question": "Would you attend another Spring related SPN?"
			"Answers":[{
				"Key":"fbqn1.fb2.q1",
				"Answer":"Yes"
				},{
				"Key":"fbqn1.fb2.q2",
				"Answer":"No"
				}]
		}
	],
	"FeedbackCommentQuestions":
	[
		{
			"Key": "fbqn1.c1",
			"CommentQuestion": "What did you think of the Spring Boot SPN?"
		},{
			"Key": "fbqn1.c2"
			"CommentQuestion": "How could the Spring Boot SPN be improved?"
		}
	]
}]

PostFeedbackAnswersLambda
-------------------------
Request
-------
[{
	"FeedbackQuestions":
	[	
		{
			"Key": "fbqn1.fb1",
			"Answer":"fbqn1.fb1.q1"
		},{
			"Key": "fbqn1.fb2"
			"Answer":"fbqn1.fb2.q2"
		}
	],
	"FeedbackComments":
	[
		{
			"Key": "fbqn1.c1",
			"Comment": "OK but a little long."
		},{
			"Key": "fbqn1.c2"
			"Comment": "Make it shorter."
		}
	]
}]

Response
--------
Done

PostFeedbackAnswersAggregatorLambda
-----------------------------------
Request
-------
Trigger on FeedbackQuestionResults Table

Response
--------
Aggregate Results on FeedbackQuestionAggregateResults Table

GetFeedbackQuestionAggregateResultsLambda
-----------------------------------------
Request
-------
FeedbackQuestionaireKey="fbqn1"

Response
--------
[{
	"FeedbackQuestionAggregateResults":
	[
		{
			"Key": "fbqn1.fb1",
			"Question": "What did you think of the Spring Boot SPN?",
			[
				{
					"Key": "fbqn1.fb1.q1",
					"Answer":"Very Poor",
					"AggregateQuestionCount": 0
				},{
					"Key": "fbqn1.fb1.q2",
					"Answer":"Not Relevant",
					"AggregateQuestionCount": 2
				},{
					"Key": "fbqn1.fb1.q3",
					"Answer":"Average",
					"AggregateQuestionCount": 1
				},{
					"Key": "fbqn1.fb1.q4",
					"Answer":"Very Good",
					"AggregateQuestionCount": 4
				},{
					"Key": "fbqn1.fb1.q5",
					"Answer":"Excellent",
					"AggregateQuestionCount": 10
				}
			],
			"Key": "fbqn1.fb2",
			"Question": "Would you attend another Spring related SPN?",
			[
				{
					"Key": "fbqn1.fb2.q1",
					"Answer":"Yes",
					"AggregateQuestionCount": 2
				},{
					"Key": "fbqn1.fb2.q2",
					"Answer":"No",
					"AggregateQuestionCount": 0
				}
			]
		}
	],
	"FeedbackComments":
	[	
		{
			"Key": "fbqn1.c1"
			"CommentQuestion": "What did you think of the Spring Boot SPN?",
			[
				{
					"Comment": "OK but a little long."
				},{
					"Comment": "Liked it."
				}
			]
		},{
			Key: fbqn1.c2
			"CommentQuestion": "How could the Spring Boot SPN be improved?"
			[
				{
					"Comment": " Make it shorter."
				}
			]
		}
	]
}]

