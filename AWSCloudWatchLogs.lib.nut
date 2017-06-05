// MIT License
//
// Copyright 2017 Electric Imp
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


class AWSCloudWatchLogs {

    static VERSION = "1.0.0";
    static SERVICE = "logs";
    static TARGET_PREFIX = "Logs_20140328";

    _awsRequest = null;




        // 	Parameters:
        //	 region				AWS region
        //   accessKeyId		AWS access key Id
        //   secretAccessKey    AWS secret access key
    constructor(region, accessKeyId, secretAccessKey) {
        if ("AWSRequestV4" in getroottable()) {
            _awsRequest = AWSRequestV4(SERVICE, region, accessKeyId, secretAccessKey);
        } else {
            throw ("This class requires AWSRequestV4 - please make sure it is loaded.");
        }
    }




    //	Creates a log stream for the specified log group
    //
    // 	Parameters:
    //    params				table of parameters to be sent as part of the request
    //    cb                    callback function to be called when response received
    //						from aws
    function CreateLogStream(params, cb) {

        local headers = {
            "X-Amz-Target": format("%s.CreateLogStream", TARGET_PREFIX)
            "Content-Type": "application/x-amz-json-1.1"
        };
        _awsRequest.post("/", headers, http.jsonencode(params), cb);
    }




    //  Creates a log group with the specified name
    //
    // 	Parameters:
    //    params				table of parameters to be sent as part of the request
    //    cb                    callback function to be called when response received
    //						from aws
    function CreateLogGroup(params, cb) {

        local headers = {
            "X-Amz-Target": format("%s.CreateLogGroup", TARGET_PREFIX)
            "Content-Type": "application/x-amz-json-1.1"
        };
        _awsRequest.post("/", headers, http.jsonencode(params), cb);
    }




    //	Deletes a log group with the specified name
    //
    // 	Parameters:
    //    params				table of parameters to be sent as part of the request
    //    cb                    callback function to be called when response received
    //						from aws
    function DeleteLogGroup(params, cb) {

        local headers = {
            "X-Amz-Target": format("%s.DeleteLogGroup", TARGET_PREFIX)
            "Content-Type": "application/x-amz-json-1.1"
        };
        _awsRequest.post("/", headers, http.jsonencode(params), cb);
    }




    //  Deletes the specified log stream and permanently deletes all the
    //   archived log events associated with the log stream
    //
    // 	Parameters:
    //    params				table of parameters to be sent as part of the request
    //    cb                    callback function to be called when response received
    //						from aws
    function DeleteLogStream(params, cb) {

        local headers = {
            "X-Amz-Target": format("%s.DeleteLogStream", TARGET_PREFIX)
            "Content-Type": "application/x-amz-json-1.1"
        };
        _awsRequest.post("/", headers, http.jsonencode(params), cb);
    }




    //	Uploads a batch of log events to the specified log stream
    //
    // 	Parameters:
    //    params				table of parameters to be sent as part of the request
    //    cb                    callback function to be called when response received
    //						from aws
    function PutLogEvents(params, cb) {

        local locLogEvents = params.logEvents;
        local newParams = "{ \"logStreamName\": " + http.jsonencode(params.logStreamName) + ", \"logEvents\": [";

        for (local i = 0; i < locLogEvents.len(); i++) {
            newParams += " { " + "\"message\": " + http.jsonencode(locLogEvents[i].message) + ", ";
            newParams += "\"timestamp\": " + locLogEvents[i].timestamp + "}";

            if (i != locLogEvents.len() - 1) {
                newParams += ", ";
            }
        }
        newParams += "] , \"logGroupName\": " + http.jsonencode(params.logGroupName) + " }";

        local headers = {
            "X-Amz-Target": format("%s.PutLogEvents", TARGET_PREFIX)
            "Content-Type": "application/x-amz-json-1.1"
        };


        _awsRequest.post("/", headers, newParams, cb);
    }
}
