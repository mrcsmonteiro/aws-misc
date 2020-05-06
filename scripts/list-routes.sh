#!/bin/bash

# Author: Marcos Monteiro de Souza, <mrcsmonteiro@gmail.com>

AWS_ACCTS="../files/aws-accounts"

echo "AWS_ACCOUNT_ALIAS,ROUTE_TABLE_ID,ROUTE_DESTINATION,ROUTE_TARGET"

for ACCT in $( cat ${AWS_ACCTS} );
  do
    export AWS_PROFILE=${ACCT}

    for RTB_ID in $( aws ec2 describe-route-tables --query 'RouteTables[].RouteTableId[]' --output text );
      do
	aws ec2 describe-route-tables --filters "Name=route-table-id,Values=${RTB_ID}" --query 'RouteTables[].Routes[]' --output text | grep -v tgw | awk -v RTB=${RTB_ID} -v AWS=${ACCT} '{ print AWS","RTB","$1","$2 }'
	aws ec2 describe-route-tables --filters "Name=route-table-id,Values=${RTB_ID}" --query 'RouteTables[].Routes[]' --output text | grep tgw | awk -v RTB=${RTB_ID} -v AWS=${ACCT} '{ print AWS","RTB","$1","$4 }'
      done
  done
