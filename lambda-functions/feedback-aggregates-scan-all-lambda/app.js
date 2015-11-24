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
