#!/bin/bash

# Author: Marcos Monteiro de Souza, <mrcsmonteiro@gmail.com>

echo "AWS_ACCOUNT_ALIAS,ALARM_NAME,OK_TOPIC,ALARM_TOPIC,INSUFFICIENT_DATA_TOPIC,STATE_VALUE,TIMESTAMP"

for ACCT in $1;
  do
    export AWS_PROFILE=${ACCT}

    aws cloudwatch describe-alarms --query 'MetricAlarms[].AlarmName[]' | tr -d "," | sed 1d | sed \$d | sed -e 's/^[ \t]*//' | while read ALARM_NAME;
      do
	OK_TOPIC=$( eval "aws cloudwatch describe-alarms --alarm-names ${ALARM_NAME} --query 'MetricAlarms[].OKActions[]' --output text | grep "arn:aws:sns" | cut -f1 | cut -d":" -f6" ) && [[ -z ${OK_TOPIC} ]] && OK_TOPIC="NULL"
	ALARM_TOPIC=$( eval "aws cloudwatch describe-alarms --alarm-names ${ALARM_NAME} --query 'MetricAlarms[].AlarmActions[]' --output text | grep "arn:aws:sns" | cut -f1 | cut -d":" -f6" ) && [[ -z ${ALARM_TOPIC} ]] && ALARM_TOPIC="NULL"
	INSUFFICIENT_DATA_TOPIC=$( eval "aws cloudwatch describe-alarms --alarm-names ${ALARM_NAME} --query 'MetricAlarms[].InsufficientDataActions[]' --output text | grep "arn:aws:sns" | cut -f1 | cut -d":" -f6" ) && [[ -z ${INSUFFICIENT_DATA_TOPIC} ]] && INSUFFICIENT_DATA_TOPIC="NULL"
	STATE_VALUE=$( eval "aws cloudwatch describe-alarms --alarm-names ${ALARM_NAME} --query 'MetricAlarms[].StateValue[]' --output text" )
	echo "${ACCT},${ALARM_NAME},${OK_TOPIC},${ALARM_TOPIC},${INSUFFICIENT_DATA_TOPIC},${STATE_VALUE},$(date +%F_%T)" | tr -d '"'
      done
  done
