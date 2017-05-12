// MIT License
//
// Copyright 2017 Mystic Pants PTY LTD
//
// SPDX-License-Identifier: MIT
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be
// included in all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
// EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
// MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO
// EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES
// OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE,
// ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
// OTHER DEALINGS IN THE SOFTWARE.


#require "AWSRequestV4.class.nut:1.0.2"
#require "AWSCloudWatchLogs.lib.nut:1.0.0"

// const AWS_CLOUD_WATCH_LOGS_ACCESS_KEY_ID = "YOUR_KEY_ID_HERE";
// const AWS_CLOUD_WATCH_LOGS_SECRET_ACCESS_KEY = "YOUR_KEY_HERE";
// const AWS_CLOUD_WATCH_LOGS_REGION = "YOUR_REGION_HERE";


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
        "Environment": "test"
    }
}

// Delete log group params
deleteParams <- {
    "logGroupName": "testLogGroup"
}

d <- date(time());
msecStr <- format("%06d", d.usec).slice(0,3);
timestamp <- format("%d%s", d.time, msecStr);

putLogParams <- {
    "logGroupName": "testLogGroup",
    "logStreamName": "testLogStream",
    "logEvents": [{
        "message": "log",
        "timestamp": timestamp
    }]
}

// run time code

// create a log group
logs.CreateLogGroup(groupParams, function(res) {

    if (res.statuscode == HTTP_RESPONSE_SUCCESS) {
        server.log("Created a log group successfully");

        // create a log stream
        logs.CreateLogStream(params, function(res) {

            if (res.statuscode == HTTP_RESPONSE_SUCCESS) {
                server.log("Created a log stream successfully");

                // puts a log event onto the stream
                logs.PutLogEvents(putLogParams, function(res) {

                    if (res.statuscode == HTTP_RESPONSE_SUCCESS) {
                        server.log("Put a log  successfully");

                        logs.DeleteLogGroup(putLogParams, function(res) {

                            if (res.statuscode == HTTP_RESPONSE_SUCCESS) {
                                server.log("Deleted log group successfully");
                            } else {
                                server.log("Failed to delete a log group. error: " + http.jsondecode(res.body).message)
                            }
                        })
                    } else {
                        server.log("Failed to put a log. error: " + http.jsondecode(res.body).message);
                    }
                });
            } else {
                server.log("Failed to create log stream. error: " + http.jsondecode(res.body).message);
            }
        });

    } else {
        server.log("Failed to create log group. error: " + http.jsondecode(res.body).message);
    }

});
