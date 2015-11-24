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
