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

Notes (Still to be written up)
------------------------------

AWS Feedback Site

Create Lambda
-------------
Name: FeedbackLambda
Runtime: NodeJS
Handler: feedback.handler
Role: lambda_basic_execution
Description: 
Code:
console.log('Loading function');
var AWS = require('aws-sdk');
var dynamodb = new AWS.DynamoDB();

exports.handler = function(event, context) {
    //var now = moment();

    //var dateTime = now.format("D MMM YYYY HH:mm");
    //console.log('STARTED at: '+ dateTime);
    
    console.log('feedback =', event.feedback);
    console.log('score =', event.score);
    console.log('event =', event);
    var dynamodb = new AWS.DynamoDB({apiVersion: '2012-08-10', region: 'eu-west-1'});
    
    var feedback = (event.feedback === undefined ? 'No-Feedback' : event.feedback);
    var score = (event.score === undefined ? 0 : parseInt(event.score));
    var scoreDescription;
    if (score==1) {
        scoreDescription = "ugly";
    } else if (score==2) {
        scoreDescription = "bad";
    } else if (score==3) {
        scoreDescription = "ok";
    } else if (score==4) {
        scoreDescription = "good";
    } else if (score==5) {
        scoreDescription = "excellent";
    } else {
        scoreDescription = "none";
    }
    
    var feedbackScoreHash = scoreDescription  + "." + Math.floor((Math.random() * 10) + 1).toString();
    
    var tableName = 'Feedback';
    var errorDescription;
    var outputDescription = "";
    dynamodb.updateItem({
      'TableName': tableName,
      'Key': { 'feedbackScore' : { 'S': feedbackScoreHash }},
      'UpdateExpression': 'add #score :x',
      'ExpressionAttributeNames': {'#score' : 'Scores'},
      'ExpressionAttributeValues': { ':x' : { "N" : "1" } }
    }, function(err, data) {
      if (err) {
        console.log(err);
        context.fail(err);
      } else {
        console.log("Feedback received for %s", scoreDescription);
        outputDescription = "Feedback received for " + scoreDescription;
    
    
        var json = {"score": score, "feedback": feedback, "scoreDescription": scoreDescription, "feedbackScoreHash": feedbackScoreHash, "outputDescription": outputDescription, "errorDescription": errorDescription };
    
        console.log(json);
        context.succeed(json);
      }
    });
};

{
  "score": 1,
  "feedback": "Fab"
}

API Gateway

New API
-------
API Name: FeedbackAPI
Description Feedback API

Model
-----
Model Name: FeedbackModel
Content Type: application/json
Description: Feedback Model
Model Schema: 
{
  "$schema": "http://json-schema.org/draft-04/schema#",
  "title": "FeedbackModel",
  "type": "array",
  "items": {
    "type": "object",
    "properties": {
      "feedback": { "type": "integer", "minimum": 1, "maximum": 5 }
    }
  }
}

Stage
-----
Stage: feedback
Invoke URL: 
https://eajybqsd7b.execute-api.eu-west-1.amazonaws.com/feedback/?score=1&feedback=Hello

GET
---
Resources: Integration Request
Content Type: application/json

Input Mapping:
{ 
    "feedback": "$input.params('feedback')",
    "score": "$input.params('score')"
}

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
console.log('Loading event');
var AWS = require('aws-sdk');
var dynamodb = new AWS.DynamoDB();

exports.handler = function(event, context) {
    console.log(JSON.stringify(event, null, 2));
    console.log("Record Length: " + event.Records.length + " records.");
    var totalUgly = 0;
    var totalBad = 0;
    var totalOk = 0;
    var totalGood = 0;
    var totalExcellent = 0;
    var totalNone = 0;
    event.Records.forEach(function(record) {
        console.log(JSON.stringify(record, null, 2));
        var feedbackScore = record.dynamodb.NewImage.feedbackScore.S;
        var numScores = record.dynamodb.NewImage.Scores.N;
        console.log('record.dynamodb.NewImage.feedbackScore.S: ' + feedbackScore);
        console.log('record.dynamodb.NewImage.Scores.N: ' + numScores);
        // Determine the color on which to add the vote
        if (feedbackScore.indexOf("ugly") > -1) {
            scoreFor = "ugly";
            totalUgly += 1;
        } else if (feedbackScore.indexOf("bad") > -1) {
            scoreFor = "bad";
            totalBad +=  1;
        } else if (feedbackScore.indexOf("ok") > -1) {
            scoreFor = "ok";
            totalOk += 1;
        } else if (feedbackScore.indexOf("good") > -1) {
            scoreFor = "good";
            totalGood += 1;
        } else if (feedbackScore.indexOf("excellent") > -1) {
            scoreFor = "excellent";
            totalExcellent += 1;
        } else {
            scoreFor = "none";
            totalNone += 1;
        }
    }); 
    console.log('totalUgly:' + totalUgly);
    console.log('totalBad:' + totalBad);
    console.log('totalOk:' + totalOk);
    console.log('totalGood:' + totalGood);
    console.log('totalExcellent:' + totalExcellent);
    console.log('totalNone:' + totalNone);

    // Update the aggregation table with the total of RED, GREEN, and BLUE 
    // votes received from this series of updates    
    var aggregatesTable = 'FeedbackAggregates';
    
    if (totalUgly > 0) updateAggregateForScore("ugly", totalUgly);
    if (totalBad > 0) updateAggregateForScore("bad", totalBad);
    if (totalOk > 0) updateAggregateForScore("ok", totalOk);   
    if (totalGood > 0) updateAggregateForScore("good", totalGood);
    if (totalExcellent > 0) updateAggregateForScore("excellent", totalExcellent);
    if (totalNone > 0) updateAggregateForScore("none", totalNone);   
    
    function updateAggregateForScore(scoreFor, numScores) {
        dynamodb.updateItem({
            'TableName': aggregatesTable,
            'Key': { 'feedbackScore' : { 'S': scoreFor }},
            'UpdateExpression': 'add #score :x',
            'ExpressionAttributeNames': {'#score' : 'Scores'},
            'ExpressionAttributeValues': { ':x' : { "N" : numScores.toString() }}        
        }, function(err, data) {
            if (err) {
                console.log(err);
                context.fail("Error updating Aggregates table: ", err);
            } else {
                console.log("Score received for %s", scoreFor);
                context.succeed("Successfully processed " + event.Records.length + " records.");
            }
        });    
    }
};


DynamoDB
---------
Feedback feedbackScore
FeedbackAggregates feedbackScore


DynamoDB Scan Example
Name: FeedbackAggregatesScanAllLambda
console.log('Loading event');
var AWS = require('aws-sdk');
var dynamodb = new AWS.DynamoDB();
exports.handler = function(event, context) {
    var dynamodb = new AWS.DynamoDB({apiVersion: '2012-08-10', region: 'eu-west-1'});
    var tableName = 'FeedbackAggregates';
    dynamodb.scan({
        TableName : tableName,
        Limit : 6
    }, function(err, data) {
        if (err) { console.log(err); return; }
        console.log(data);
        context.succeed(data.Items);
    });
};
https://eajybqsd7b.execute-api.eu-west-1.amazonaws.com/feedback/totals
http://demo-feedback.s3-website-eu-west-1.amazonaws.com/

index.html
----------
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01//EN">
<html>
    <head>
        <meta name="generator" content="HTML Tidy, see www.w3.org">
        <title>AWS Serverless Code: Feedback Demo</title>
	    <link rel="stylesheet" href="https://code.jquery.com/mobile/1.4.5/jquery.mobile-1.4.5.css" >
        <script type="text/javascript" src= "https://code.jquery.com/jquery-2.1.4.js" ></script>
        <script type="text/javascript" src= "https://code.jquery.com/mobile/1.4.5/jquery.mobile-1.4.5.js" ></script>
		<script src="https://cdnjs.cloudflare.com/ajax/libs/Chart.js/1.0.2/Chart.min.js"></script>

	    <link rel="shortcut icon" href="https://code.jquery.com/favicon.ico">
	    <link rel="stylesheet" href="https://fonts.googleapis.com/css?family=Open+Sans:300,400,700">
	    <link rel="stylesheet" href="https://code.jquery.com/mobile/1.4.5/jquery.mobile-1.4.5.min.css">

        <script type="text/javascript">
            function getPieData(){
				var pieData = [
					{
						value: 10,
						color:"#F7464A",
						highlight: "#FF5A5E",
						label: "excellent"
					},
					{
						value: 20,
						color: "#46BFBD",
						highlight: "#5AD3D1",
						label: "good"
					},
					{
						value: 30,
						color: "#FDB45C",
						highlight: "#FFC870",
						label: "ok"
					},
					{
						value: 40,
						color: "#949FB1",
						highlight: "#A8B3C5",
						label: "bad"
					},
					{
						value: 50,
						color: "#4D5360",
						highlight: "#616774",
						label: "ugly"
					}
	
				];
				return pieData;
            };

            $(function(){
            	feedbackTotals();
            });
            
            function feedback(score, feedback){
            	var url = "https://eajybqsd7b.execute-api.eu-west-1.amazonaws.com/feedback?score="+score+"&feedback="+feedback;
                $.getJSON(url,
                    function(data){
                	$(data).each(function(idx, obj){
                    	});
                	});
                
                setTimeout(function(){
	                clearAndUpdateFeedbackTotalsAfterUpdateAfterTimeout();
            	}, 3000);	
           	};

			function clearAndUpdateFeedbackTotalsAfterUpdateAfterTimeout() {
	                deleteRow("feedbackHeader");
	        		deleteRow("none");
	            	deleteRow("excellent");
	            	deleteRow("good");
	            	deleteRow("ok");
	            	deleteRow("bad");
	            	deleteRow("ugly");
	            	
	            	var feedbackHeaderRow = "<tr><th>Feedback</th><th>Score</th></tr>";
	                document.getElementById("feedbackScoresTable").insertRow(-1).innerHTML = feedbackHeaderRow;
	               	feedbackTotals();
			};
            
            function feedbackTotals() {
				var pieDataReturn = getPieData();
                $.getJSON("https://eajybqsd7b.execute-api.eu-west-1.amazonaws.com/feedback/totals", 
                        function(data){
                    	$(data).each(function(idx, obj){ 
                            $(obj).each(function(key, value){
                            	var scores = '<tr id="' + value.feedbackScore.S + '"><th> ' + value.feedbackScore.S
    							+ ' </th> <td> ' + value.Scores.N
    							+ ' </td></tr>';
    							document.getElementById("feedbackScoresTable").insertRow(-1).innerHTML = scores;
    							console.log(scores);
								for(var i = 0; i < pieDataReturn.length; i++) {
									var label = pieDataReturn[i].label;
									if (label === value.feedbackScore.S) {
										var score = Number(value.Scores.N);
										pieDataReturn[i].value = score;
									};
								};
                            });
                        });
                        if ( typeof query !== 'undefined' && query ) {
            				window.myPie.destroy();
                        }
        				var ctx = document.getElementById("chart-area").getContext("2d");
        				window.myPie = new Chart(ctx).Pie(pieDataReturn);
                    }); 
                
            }
            
        	function deleteRow(rowid) {   
        	    console.log("deleteRow: " + rowid);
        	    document.getElementById("feedbackScoresTable").deleteRow(rowid);
        	}
        	
		</script>
        <meta name="viewport" content="width=device-width, initial-scale=1">
        
    </head>
    <body>
    <H1>AWS Serverless Code: Feedback Demo</H1>
    <H2>Using AWS Services: S3, API Gateway, Node.js, Lambda, DynamoDB</H2>
	<form>
    	<fieldset data-role="controlgroup" data-type="horizontal">
        	<legend>Select Feedback:</legend>
        	<input type="radio" name="radio-choice-h-2" id="radio-choice-h-2a" value="5" onClick = "feedback('5', 'excellent');">
        	<label for="radio-choice-h-2a">excellent</label>
        	<input type="radio" name="radio-choice-h-2" id="radio-choice-h-2b" value="4" onClick = "feedback('4', 'good');">
        	<label for="radio-choice-h-2b">good</label>
        	<input type="radio" name="radio-choice-h-2" id="radio-choice-h-2c" value="3" onClick = "feedback('3', 'ok');">
        	<label for="radio-choice-h-2c">ok</label>
        	<input type="radio" name="radio-choice-h-2" id="radio-choice-h-2d" value="2" onClick = "feedback('2', 'bad');">
        	<label for="radio-choice-h-2d">bad</label>
        	<input type="radio" name="radio-choice-h-2" id="radio-choice-h-2e" value="1" onClick = "feedback('1', 'ugly');">
        	<label for="radio-choice-h-2e">ugly</label>
    	</fieldset>
	</form>

	<table data-role="table" id="feedbackScoresTable" data-mode="column" data-column-btn-theme="b" class="table-stroke">
    	<thead>
        	<tr id="feedbackHeader">
            	<th>Feedback</th>
            	<th>Score</th>
        	</tr>
    	</thead>
    	<tbody>
    	</tbody>
	</table>
	<br />
		<div id="canvas-holder">
			<canvas id="chart-area" width="300" height="300"/>
		</div>
    </body>
</html>


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

