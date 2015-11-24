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

