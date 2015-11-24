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
