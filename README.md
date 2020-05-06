# README #

This README explains the necessary steps to run the MISC scripts.

### What is this repository for? ###

This MISC repository stores custom scripts to facilitate AWS administration by automating tasks such as:

* Data collection across AWS accounts
* Report generation
* Key Metrics extraction for analysis
* etc.

### How do I get set up? ###

1. Clone the repository into your local machine
2. Configure AWS access via CLI
3. Run script and check its output

There are 3 main directories in this repository:

1. files: stores files with auxiliar data for scripts, e.g. list of AWS profiles available in the ~/.aws/credentials file
2. scripts: this is where you can find the MISC scripts
3. tmp: directory for temporary files used during data processing

### list-rtb-subnet.sh ###

Objective: List subnets and associated route tables for AWS accounts

Input: AWS accounts in the /files/aws-accounts file (must match with the profile name(s) defined in ~/.aws/credentials)

Output: csv rows (stdout) with the following information:

AWS_ACCOUNT_ALIAS,VPC_ID,VPC_TAG,ROUTE_TABLE_ID,ROUTE_TABLE_TAG,SUBNET_ID,SUBNET_TAG

How to run: clone the repository, launch your shell session, go to scripts and execute './list-rtb-subnet.sh'

Alternatively, you can use 'list-rtb-subnet-param.sh' to retrieve data from one specific AWS account. Example, to retrieve data from 'poc' profile:

./list-rtb-subnet-param.sh poc

TIP: You can redirect the output to a text file and use it on Excel or any other data visualization program to apply filters, create charts, etc.

### list-routes.sh ###

Objective: List routes table ID, destination and target for AWS accounts

Input: AWS accounts in the /files/aws-accounts file (must match with the profile name(s) defined in ~/.aws/credentials)

Output: csv rows (stdout) with the following information:

AWS_ACCOUNT_ALIAS,ROUTE_TABLE_ID,ROUTE_DESTINATION,ROUTE_TARGET

How to run: clone the repository, launch your shell session, go to scripts and execute './list-routes.sh'

Alternatively, you can use 'list-routes-param.sh' to retrieve data from one specific AWS account. Example, to retrieve data from 'poc' profile:

./list-routes-param.sh poc

TIP: You can redirect the output to a text file and use it on Excel or any other data visualization program to apply filters, create charts, etc.

### blackhole-lookup.sh ###

Objective: Lookup route table IDs and respective destinations in 'blackhole' status, for all AWS accounts

Input: AWS accounts in the /files/aws-accounts file (must match with the profile name(s) defined in ~/.aws/credentials)

Output: csv rows (stdout) with the following information:

AWS_ACCOUNT_ALIAS,ROUTE_TABLE_ID,ROUTE_DESTINATION,STATUS

How to run: clone the repository, launch your shell session, go to scripts and execute './blackhole-lookup.sh'

TIP: You can redirect the output to a text file and use it on Excel or any other data visualization program to apply filters, create charts, etc.

### list-alarms.sh ###

Objective: List CloudWatch Alarms, which SNS topics are being used for each possible action, and alarm state for AWS accounts

Input: AWS accounts in the /files/aws-accounts file (must match with the profile name(s) defined in ~/.aws/credentials)

Output: csv rows (stdout) with the following information:

AWS_ACCOUNT_ALIAS,ALARM_NAME,OK_TOPIC,ALARM_TOPIC,INSUFFICIENT_DATA_TOPIC,STATE_VALUE,TIMESTAMP

How to run: clone the repository, launch your shell session, go to scripts and execute './list-alarms.sh'

Alternatively, you can use 'list-alarms.sh' to retrieve data from one specific AWS account. Example, to retrieve data from 'poc' profile:

./list-alarms-param.sh poc

TIP: You can redirect the output to a text file and use it on Excel or any other data visualization program to apply filters, create charts, etc.
