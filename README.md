# AWSDynamoDB

**This library is a work in progress and does not yet work.**

To add this library to your model, add the following lines to the top of your agent code:

```
#require "AWSRequestV4.class.nut:1.0.2"
#require "AWSCloudWatchLogs.class.nut:1.0.0"
```

**Note: [AWSRequestV4](https://github.com/electricimp/AWSRequestV4/) must be loaded.**

This class can be used to perform actions on a DynamoDB table.

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
#require "AWSCloudWatchLogs.class.nut:1.0.0"

const AWS_CLOUD_WATCH_LOGS_ACCESS_KEY_ID = "YOUR_KEY_ID_HERE";
const AWS_CLOUD_WATCH_LOGS_SECRET_ACCESS_KEY = "YOUR_KEY_HERE";
const AWS_CLOUD_WATCH_LOGS_REGION = "YOUR_REGION_HERE";

logs <- AWSCloudWatchLogs(AWS_CLOUD_WATCH_LOGS_REGION, AWS_CLOUD_WATCH_LOGS_ACCESS_KEY_ID, AWS_CLOUD_WATCH_LOGS_SECRET_ACCESS_KEY);
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
logGroupName			| String			| Yes		| The name of the log group
logStreamName			| String			| Yes		| The name of the log stream

```squirrel
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
content-type		  | String		   | Content type e.g text/XML
date 				  | String		   | The date and time at which response was sent
content-length		  | String		   | the length of the content
x-amz-crc32			  | String		   | Checksum of the UTF-8 encoded bytes in the HTTP response





The AWSCloudWatchLogs library is licensed under the [MIT License](LICENSE).
