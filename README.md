# AWSCloudWatchLogs

To add this library to your model, add the following lines to the top of your agent code:

```
#require "AWSRequestV4.class.nut:1.0.2"
#require "AWSCloudWatchLogs.lib.nut:1.0.0"
```

**Note: [AWSRequestV4](https://github.com/electricimp/AWSRequestV4/) must be loaded.**

This class can be used to perform Cloud Watch log actions.

## Class Methods

### constructor(region, accessKeyId, secretAccessKey)
All parameters are strings. Access keys can be generated with IAM.

Parameter    		   |       Type     | Description
---------------------- | -------------- | -----------
**region** 			   | string         | AWS region
**accessKeyId** 	   | string	        | AWS access key id
**secretAccessKey**    | string         | AWS secret access key id

### Example

```squirrel
#require "AWSRequestV4.class.nut:1.0.2"
#require "AWSCloudWatchLogs.lib.nut:1.0.0"

const AWS_CLOUD_WATCH_LOGS_ACCESS_KEY_ID = "YOUR_KEY_ID_HERE";
const AWS_CLOUD_WATCH_LOGS_SECRET_ACCESS_KEY = "YOUR_KEY_HERE";
const AWS_CLOUD_WATCH_LOGS_REGION = "YOUR_REGION_HERE";

logs <- AWSCloudWatchLogs(AWS_CLOUD_WATCH_LOGS_REGION, AWS_CLOUD_WATCH_LOGS_ACCESS_KEY_ID, AWS_CLOUD_WATCH_LOGS_SECRET_ACCESS_KEY);
```



### CreateLogGroup(params, cb)
Creates a log group with the specified name. For more detail please see: http://docs.aws.amazon.com/AmazonCloudWatchLogs/latest/APIReference/API_CreateLogGroup.html

Parameter       	   |       Type     | Description
---------------------- | -------------- | -----------
**params** 			   | Table          | Table of parameters (See API Reference)
**cb**                 | Function       | Callback function that takes one parameter (a response table)

where `params` includes

Parameter      	 	    |       Type	    | Required	| Description
---------------------   | ----------------- | --------  | -----------
logGroupName			| String			| Yes		| The name of the log group you are creating
tags					| table				| No		| The key-value pairs to use for the tags

### Example

```squirrel
const HTTP_RESPONSE_SUCCESS = 200;
groupParams <- {
	"logGroupName": "testLogGroup",
	"tags": { "Environment" : "test"}
}
logs.CreateLogGroup(groupParams, function (res) {

	if(res.statuscode == HTTP_RESPONSE_SUCCESS) {
		server.log("Created a log group successfully");
	}
	else {
		server.log("Failed to create log group. error: " + http.jsondecode(res.body).message);
	}
});
```



### CreateLogStream(params, cb)
Creates a log stream for the specified log group. For more detail please see: http://docs.aws.amazon.com/AmazonCloudWatchLogs/latest/APIReference/API_CreateLogStream.html

Parameter       	   |       Type     | Description
---------------------- | -------------- | -----------
**params** 			   | Table          | Table of parameters (See API Reference)
**cb**                 | Function       | Callback function that takes one parameter (a response table)

where `params` includes

Parameter      	 	    |       Type	    | Required	| Description
---------------------   | ----------------- | --------  | -----------
logGroupName			| String			| Yes		| The name of the existing log group
logStreamName			| String			| Yes		| The name of the log stream you are creating

### Example

```squirrel
params <- {
	"logGroupName": "testLogGroup",
	"logStreamName": "testLogStream"
}
logs.CreateLogStream(params, function (res) {
	if(res.statuscode == HTTP_RESPONSE_SUCCESS) {
		server.log("Created a log stream successfully");
	}
	else {
		server.log("Failed to create log stream. error: " + http.jsondecode(res.body).message);
	}
});
```



### DeleteLogGroup(params, cb)
Creates a log group with the specified name. For more detail please see: http://docs.aws.amazon.com/AmazonCloudWatchLogs/latest/APIReference/API_DeleteLogGroup.html

Parameter       	   |       Type     | Description
---------------------- | -------------- | -----------
**params** 			   | Table          | Table of parameters (See API Reference)
**cb**                 | Function       | Callback function that takes one parameter (a response table)

where `params` includes

Parameter      	 	    |       Type	    | Required	| Description
---------------------   | ----------------- | --------  | -----------
logGroupName			| String			| Yes		| The name of the log group you want to delete

### Example

```squirrel
deleteParams <- {
	"logGroupName": "testLogGroup"
}
logs.DeleteLogGroup(deleteParams, function (res) {

	if(res.statuscode == HTTP_RESPONSE_SUCCESS) {
		server.log("Deleted log group successfully");
	}
	else {
		server.log("Failed to delete log group. error: " + http.jsondecode(res.body).message)
	}
});

```



### DeleteLogStream(params, cb)
Deletes the specified log stream and permanently deletes all the archived log events associated with the log stream. For more detail please see: http://docs.aws.amazon.com/AmazonCloudWatchLogs/latest/APIReference/API_DeleteLogStream.html

Parameter       	   |       Type     | Description
---------------------- | -------------- | -----------
**params** 			   | Table          | Table of parameters (See API Reference)
**cb**                 | Function       | Callback function that takes one parameter (a response table)

where `params` includes

Parameter      	 	    |       Type	    | Required	| Description
---------------------   | ----------------- | --------  | -----------
logGroupName			| String			| Yes		| The name of the log group
logStreamName			| String			| Yes		| The name of the log stream you are deleting from the log group

### Example

```squirrel
params <- {
	"logGroupName": "testLogGroup",
	"logStreamName": "testLogStream"
}
logs.DeleteLogStream(deleteParams, function (res) {

	if(res.statuscode == HTTP_RESPONSE_SUCCESS) {
		server.log("Deleted log stream successfully");
	}
	else {
		server.log("Failed to delete log stream. error: " + http.jsondecode(res.body).message)
	}
});
```


### PutLogEvents(params, cb)
Uploads a batch of log events to the specified log stream. For more detail please see: http://docs.aws.amazon.com/AmazonCloudWatchLogs/latest/APIReference/API_PutLogEvents.html

Parameter       	   |       Type     | Description
---------------------- | -------------- | -----------
**params** 			   | Table          | Table of parameters (See API Reference)
**cb**                 | Function       | Callback function that takes one parameter (a response table)

where `params` includes

Parameter      	 	    |       Type	    | Required	| Description
---------------------   | ----------------- | --------  | -----------
logEvents				| Array of Tables 	| Yes		| The log events. Each table must contain a message of type String and a timestamp of type String (milliseconds passed  Jan 1, 1970 00:00:00 UTC).
logGroupName			| String			| Yes		| The name of the log group
logStreamName			| String			| Yes		| The name of the log stream
sequenceToken			| No				| No		| The sequence token

### Example

```squirrel
d <- date(time());
msecStr <- format("%06d", d.usec).slice(0,3);
t <- format("%d%s", d.time, msecStr);


local putLogParams = {
	"logGroupName": "testLogGroup",
	"logStreamName": "testLogStream",
	"logEvents": [{
		"message": "log",
		"timestamp": t
	}]
}

logs.PutLogEvents(putLogParams, function(res) {

	if (res.statuscode) {
		server.log("successfully put a log in a stream");
	}
	else {
		server.log("failed to put a log in a stream");
	}
})
```



#### Response Table
The format of the response table general to all functions

Key		              |       Type     | Description
--------------------- | -------------- | -----------
body				  | String         | Cloud Watch Logs response in a function specific structure that is json encoded.
statuscode			  | Integer		   | http status code
headers				  | Table		   | see headers

where `headers` includes

Key		              |       Type     | Description
--------------------- | -------------- | -----------
x-amzn-requestid	  | String		   | Amazon request id
connection			  | String		   | Connection status
date 				  | String		   | The date and time at which response was sent
content-length		  | String		   | the length of the content





The AWSCloudWatchLogs library is licensed under the [MIT License](LICENSE).
