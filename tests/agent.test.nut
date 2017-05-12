// Your AWS keys here
// const AWS_CLOUD_WATCH_LOGS_ACCESS_KEY_ID = "YOUR_KEY_ID_HERE";
// const AWS_CLOUD_WATCH_LOGS_SECRET_ACCESS_KEY = "YOUR_KEY_HERE";
// const AWS_CLOUD_WATCH_LOGS_REGION = "YOUR_REGION_HERE";


// http status codes
const AWS_TEST_HTTP_RESPONSE_SUCCESS = 200;
const AWS_TEST_HTTP_RESPONSE_SUCCESS_UPPER_BOUND = 300;
const AWS_TEST_HTTP_RESPONSE_FORBIDDEN = 403;
const AWS_TEST_HTTP_RESPONSE_NOT_FOUND = 404;
const AWS_TEST_HTTP_RESPONSE_BAD_REQUEST = 400;

// error messages
const AWS_ERROR_EXISTING_LOG_GROUP = "The specified log group already exists";
const AWS_ERROR_EXISTING_LOG_STREAM = "The specified log stream already exists";
const AWS_ERROR_NO_LOG_GROUP = "The specified log group does not exist.";
const AWS_ERROR_NO_LOG_STREAM = "The specified log stream does not exist.";
const AWS_ERROR_OLD_TIMESTAMP = 1;


class CloudWatchLogsTest extends ImpTestCase {

    _logs = null;



    // initialise the class
    // creates a log group for future test usage
    function setUp() {
        _logs = AWSCloudWatchLogs(AWS_CLOUD_WATCH_LOGS_REGION, AWS_CLOUD_WATCH_LOGS_ACCESS_KEY_ID, AWS_CLOUD_WATCH_LOGS_SECRET_ACCESS_KEY);
        return Promise(function(resolve, reject) {

            _logs.CreateLogGroup({ "logGroupName": "testLogGroup" }, function(res) {
                if (res.statuscode == AWS_TEST_HTTP_RESPONSE_SUCCESS) {
                    resolve();
                } else {
                    reject();
                }

            }.bindenv(this));
        }.bindenv(this));
    }



    // check for a successfully created log group
    function testCreatelogGroup() {

        local groupParams = {
            "logGroupName": "testLogGroup1",
            "tags": {
                "Environment": "test"
            }
        }
        return Promise(function(resolve, reject) {

            _logs.CreateLogGroup(groupParams, function(res) {

                try {
                    this.assertTrue(res.statuscode == AWS_TEST_HTTP_RESPONSE_SUCCESS, res.statuscode)
                    resolve();
                } catch (e) {
                    reject(e);
                }
            }.bindenv(this));
        }.bindenv(this));
    }



    // create a log group then try to make another log group with the same name
    function testFailCreateLogGroup() {

        local groupParams = {
            "logGroupName": "testLogGroup2",
        }
        return Promise(function(resolve, reject) {

            // create the first log group
            _logs.CreateLogGroup(groupParams, function(res) {

                // check that the first group was successfully made
                if (res.statuscode == AWS_TEST_HTTP_RESPONSE_SUCCESS) {
                    // trys to create the second with the same name
                    _logs.CreateLogGroup(groupParams, function(res) {

                        try {
                            this.assertTrue(res.statuscode == AWS_TEST_HTTP_RESPONSE_BAD_REQUEST, res.statuscode);
                            this.assertTrue(http.jsondecode(res.body).message == AWS_ERROR_EXISTING_LOG_GROUP, http.jsondecode(res.body).message);
                            resolve();
                        } catch (e) {
                            reject(e);
                        }
                    }.bindenv(this));


                } else {
                    reject();
                }

            }.bindenv(this));
        }.bindenv(this));
    }



    // test CreateLogStream
    // use the log group from setup
    function testCreateLogStream() {

        local streamParams = {
            "logGroupName": "testLogGroup",
            "logStreamName": "testLogStream"
        }

        return Promise(function(resolve, reject) {

            // creates a log stream for the log group from *setup()*
            _logs.CreateLogStream(streamParams, function(res) {

                try {
                    this.assertTrue(res.statuscode == AWS_TEST_HTTP_RESPONSE_SUCCESS, res.statuscode);
                    resolve();
                } catch (e) {
                    reject(e);
                }
            }.bindenv(this));
        }.bindenv(this));

    }



    // test DeleteLogStream
    // input a log stream into the log group set up in the setup
    // then deletes it checking for appropriate http response
    function testDeleteLogStream() {

        local streamParams = {
            "logGroupName": "testLogGroup",
            "logStreamName": "testDeleteLogStream"
        }
        return Promise(function(resolve, reject) {

            _logs.CreateLogStream(streamParams, function(res) {

                // checks that the log stream created correctly
                if (res.statuscode == AWS_TEST_HTTP_RESPONSE_SUCCESS) {
                    _logs.DeleteLogStream(streamParams, function(res) {

                        try {
                            this.assertTrue(res.statuscode == AWS_TEST_HTTP_RESPONSE_SUCCESS, res.statuscode);
                            resolve();
                        } catch (e) {
                            reject(e);
                        }
                    }.bindenv(this));
                } else {
                    reject();
                }

            }.bindenv(this));
        }.bindenv(this));

    }



    // create a log group then delete it
    // checks the http response code to confirm a successful deletion
    function testDeleteLogGroup() {

        local groupParams = {
            "logGroupName": "testLogGroup3",
        }
        return Promise(function(resolve, reject) {

            _logs.CreateLogGroup(groupParams, function(res) {

                // checking for a successful creation
                if (res.statuscode == AWS_TEST_HTTP_RESPONSE_SUCCESS) {
                    _logs.DeleteLogGroup(groupParams, function(res) {

                        try {
                            this.assertTrue(res.statuscode == AWS_TEST_HTTP_RESPONSE_SUCCESS, res.statuscode)
                            resolve();
                        } catch (e) {
                            reject(e);
                        }
                    }.bindenv(this));

                } else {
                    reject();
                }

            }.bindenv(this));
        }.bindenv(this));
    }



    // test fail CreateLogStream
    // creating a log stream with the name of an existing log stream in the
    // the same log group. which will return an error
    function testFailCreateLogStream() {

        local streamParams = {
            "logGroupName": "testLogGroup",
            "logStreamName": "testLogStream"
        }

        return Promise(function(resolve, reject) {

            _logs.CreateLogStream(streamParams, function(res) {

                try {
                    this.assertTrue(res.statuscode == AWS_TEST_HTTP_RESPONSE_BAD_REQUEST, res.statuscode);
                    this.assertTrue(http.jsondecode(res.body).message == AWS_ERROR_EXISTING_LOG_STREAM, http.jsondecode(res.body).message);
                    resolve();
                } catch (e) {
                    reject(e);
                }
            }.bindenv(this));
        }.bindenv(this));

    }



    // test fail CreateLogStream
    // test that appropriate error message is responded when you try to create a
    // stream for a non existent log group
    function testFailCreateLogStream2() {

        local streamParams = {
            "logGroupName": "nonExistent",
            "logStreamName": "testLogStream"
        }

        return Promise(function(resolve, reject) {

            _logs.CreateLogStream(streamParams, function(res) {

                try {
                    this.assertTrue(res.statuscode == AWS_TEST_HTTP_RESPONSE_BAD_REQUEST, res.statuscode);
                    this.assertTrue(http.jsondecode(res.body).message == AWS_ERROR_NO_LOG_GROUP, http.jsondecode(res.body).message);
                    resolve();
                } catch (e) {
                    reject(e);
                }
            }.bindenv(this));
        }.bindenv(this));

    }



    // tests deleting a non existent log group
    function testFailDeleteLogGroup() {

        local deleteParams = {
            "logGroupName": "nonExistent",
        }

        return Promise(function(resolve, reject) {

            _logs.DeleteLogGroup(deleteParams, function(res) {

                try {
                    this.assertTrue(res.statuscode == AWS_TEST_HTTP_RESPONSE_BAD_REQUEST, res.statuscode);
                    this.assertTrue(http.jsondecode(res.body).message == AWS_ERROR_NO_LOG_GROUP, http.jsondecode(res.body).message);
                    resolve();
                } catch (e) {
                    reject(e);
                }
            }.bindenv(this));
        }.bindenv(this));

    }



    // tests deleting a non existent log stream
    function testFailDeleteLogStream() {

        local deleteParams = {
            "logGroupName": "testLogGroup",
            "logStreamName": "nonExistent"
        }
        return Promise(function(resolve, reject) {

            _logs.DeleteLogStream(deleteParams, function(res) {

                try {
                    this.assertTrue(res.statuscode == AWS_TEST_HTTP_RESPONSE_BAD_REQUEST, res.statuscode);
                    this.assertTrue(http.jsondecode(res.body).message == AWS_ERROR_NO_LOG_STREAM, http.jsondecode(res.body).message);
                    resolve();
                } catch (e) {
                    reject(e);
                }
            }.bindenv(this));
        }.bindenv(this));

    }



    // test that a single log event can be successfully put into a stream
    // use the log group from setup and create a specific log stream for the test
    function testPutLogEvent() {

        local d = date(time());
        local msecStr = format("%06d", d.usec).slice(0,3);
        local t = format("%d%s", d.time, msecStr);

        local streamParams = {
            "logGroupName": "testLogGroup",
            "logStreamName": "testPutLogStream"
        }

        local putLogParams = {
            "logGroupName": "testLogGroup",
            "logStreamName": "testPutLogStream",
            "logEvents": [{
                "message": "stringasdfasdf",
                "timestamp": t
            }]
        }

        return Promise(function(resolve, reject) {

            // creates a log stream for the log group from *setup()*
            _logs.CreateLogStream(streamParams, function(res) {

                if (res.statuscode == AWS_TEST_HTTP_RESPONSE_SUCCESS) {
                    _logs.PutLogEvents(putLogParams, function(res) {

                        try {
                            this.assertTrue(res.statuscode == AWS_TEST_HTTP_RESPONSE_SUCCESS, res.statuscode);
                            resolve();
                        } catch (e) {
                            reject(e);
                        }

                    }.bindenv(this));
                } else {
                    reject();
                }

            }.bindenv(this));
        }.bindenv(this));
    }



    // test that a single log event will fail if we input it as seconds and not miliseconds
    // use the log group from setup and create a specific log stream for the test
    function testFailPutLogEvent() {

        local d = date(time());
        local t = format("%d", d.time);

        local streamParams = {
            "logGroupName": "testLogGroup",
            "logStreamName": "testFailLogStream"
        }

        local putLogParams = {
            "logGroupName": "testLogGroup",
            "logStreamName": "testFailLogStream",
            "logEvents": [{
                "message": "stringasdfasdf",
                "timestamp": t
            }]
        }

        return Promise(function(resolve, reject) {

            // creates a log stream for the log group from *setup()*
            _logs.CreateLogStream(streamParams, function(res) {

                if (res.statuscode == AWS_TEST_HTTP_RESPONSE_SUCCESS) {
                    _logs.PutLogEvents(putLogParams, function(res) {

                        try {
                            this.assertTrue(res.statuscode == AWS_TEST_HTTP_RESPONSE_SUCCESS, res.statuscode);
                            this.assertTrue(http.jsondecode(res.body).rejectedLogEventsInfo.tooOldLogEventEndIndex == AWS_ERROR_OLD_TIMESTAMP, http.jsondecode(res.body).rejectedLogEventsInfo.tooOldLogEventEndIndex);
                            resolve();
                        } catch (e) {
                            reject(e);
                        }

                    }.bindenv(this));
                } else {
                    reject();
                }

            }.bindenv(this));
        }.bindenv(this));
    }



    // test that a single log event can be successfully put into a stream
    // use the log group from setup and create a specific log stream for the test
    function testPutLogEventMultiple() {

        local d = date(time());
        local msecStr = format("%06d", d.usec).slice(0,3);
        local t = format("%d%s", d.time, msecStr);

        local streamParams = {
            "logGroupName": "testLogGroup",
            "logStreamName": "testPutLogMultStream"
        }

        local putLogParams = {
            "logGroupName": "testLogGroup",
            "logStreamName": "testPutLogMultStream",
            "logEvents": [{
                "message": "string1asdfasdf",
                "timestamp": t
            }, {
                "message": "stringasfasf2",
                "timestamp": t
            }]
        }

        return Promise(function(resolve, reject) {

            // creates a log stream for the log group from *setup()*
            _logs.CreateLogStream(streamParams, function(res) {

                if (res.statuscode == AWS_TEST_HTTP_RESPONSE_SUCCESS) {
                    _logs.PutLogEvents(putLogParams, function(res) {

                        try {
                            this.assertTrue(res.statuscode == AWS_TEST_HTTP_RESPONSE_SUCCESS, res.statuscode);
                            resolve();
                        } catch (e) {
                            reject(e);
                        }

                    }.bindenv(this));
                } else {
                    reject();
                }

            }.bindenv(this));
        }.bindenv(this));
    }



    // clean up after tests by deleting the made log Groups
    function tearDown() {

        local deleteParams1 = {
            "logGroupName": "testLogGroup1",
        }
        local deleteParams2 = {
            "logGroupName": "testLogGroup2",
        }
        local deleteParams3 = {
            "logGroupName": "testLogGroup",
        }

        return deleteParam(deleteParams1)
            .then(function(x) {

                return deleteParam(deleteParams2)
            }.bindenv(this))
            .then(function(x) {

                return deleteParam(deleteParams3)
            }.bindenv(this))
            .then(function(x) {

                return;
            }.bindenv(this))

    }



    // to be called by tear down
    function deleteParam(param) {
        return Promise(function(resolve, reject) {

            _logs.DeleteLogGroup(param, function(res) {

                if (res.statuscode == AWS_TEST_HTTP_RESPONSE_SUCCESS) {
                    resolve();

                } else {
                    reject("failed to delete: " + params.logGroupName);
                }
            }.bindenv(this));
        }.bindenv(this));
    }
}
