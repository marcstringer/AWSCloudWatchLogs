#require "AWSRequestV4.class.nut:1.0.2"
#require "AWSCloudWatchLogs.class.nut:1.0.0"




const AWS_CLOUD_WATCH_LOGS_ACCESS_KEY_ID = "YOUR_KEY_ID_HERE";
const AWS_CLOUD_WATCH_LOGS_SECRET_ACCESS_KEY = "YOUR_KEY_HERE";
const AWS_CLOUD_WATCH_LOGS_REGION = "YOUR_REGION_HERE";

// http status codes
const HTTP_RESPONSE_SUCCESS = 200;


// initialise the class
logs <- AWSCloudWatchLogs(AWS_CLOUD_WATCH_LOGS_REGION, AWS_CLOUD_WATCH_LOGS_ACCESS_KEY_ID, AWS_CLOUD_WATCH_LOGS_SECRET_ACCESS_KEY);

// Create Log Stream params
params <- {
	"logGroupName": "testLogGroup",
	"logStreamName": "testLogStream"
}

// Create log group params
groupParams <- {
	"logGroupName": "testLogGroup",
	"tags": {
      "Environment" : "test"
   	}
}

// Delete log group params
deleteParams <- {
	"logGroupName": "testLogGroup"
}

// run time code

// create a log group
logs.CreateLogGroup(groupParams, function(res) {

	if(res.statuscode == HTTP_RESPONSE_SUCCESS) {
		server.log("Created a log group successfully");
		// create a log stream
		logs.CreateLogStream(params, function(res) {

			if(res.statuscode == HTTP_RESPONSE_SUCCESS) {
				server.log("Created a log stream successfully");
				// deletes a log group
				logs.DeleteLogGroup(deleteParams, function(res) {

					if(res.statuscode == HTTP_RESPONSE_SUCCESS) {
						server.log("Deleted log group successfully");
					}
					else {
						server.log("Failed to delete log group. error: " + http.jsondecode(res.body).message)
					}
				});
			}
			else {
				server.log("Failed to create log stream. error: " + http.jsondecode(res.body).message);
			}
		});

	} else {
		server.log("Failed to create log group. error: " + http.jsondecode(res.body).message);
	}

});
