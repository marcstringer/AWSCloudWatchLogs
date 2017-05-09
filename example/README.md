# Demo Instructions

This example shows you how to create a AWS Cloud Watch log group and create a log stream for it. Then the log group is deleted.

As the sample code includes the private key verbatim in the source, it should be treated carefully, and not checked into version control!


Please ensure your AWS keys have AWS Cloud Watch logs access.

The names used align with the *sample.agent.nut* code.

## Setting up Agent Code

Here is some agent [code](sample.agent.nut).

Set the example code configuration parameters Enter your aws keys and your AWS region.

Parameter             			 		| Description
--------------------------------------- | -----------
AWS_CLOUD_WATCH_LOGS_ACCESS_KEY_ID		| IAM Access Key ID
AWS_CLOUD_WATCH_LOGS_SECRET_ACCESS_KEY	| IAM Secret Access Key
AWS_CLOUD_WATCH_LOGS_REGION				| AWS region

Run the example code and it should create a log group and create a log stream viewable in the AWS console CloudWatch -> Log Groups (provided you remove the DeleteLogGroup function at the end of sample.agent.nut )
