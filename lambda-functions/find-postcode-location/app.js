console.log('Loading find-postcode-location function');
var AWS = require('aws-sdk');
var ddb = new AWS.DynamoDB({apiVersion: '2012-08-10', region: 'eu-west-1'});

exports.handler = function(event, context) {

    console.log('postcode =', event.postcode);
    
    var postcode = (event.postcode === undefined ? 'No-Postcode' : event.postcode);
    
    var params = {
      AttributesToGet: ["Latitude", "Longitude", "Households", "Population"],
      TableName : 'PostcodeLocationDetails',
      Key : { "Postcode" : {"S" : postcode} }
    }

    ddb.getItem(params, function(err, data) {
      if (err) {
        console.log(err);
      } else {
        console.log(data);
        context.succeed(data);
      }
    });
};
