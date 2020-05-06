#!/bin/bash

# Author: Marcos Monteiro de Souza, <mrcsmonteiro@gmail.com>

AWS_ACCTS="../files/aws-accounts"

echo "AWS_ACCOUNT_ALIAS,ROUTE_TABLE_ID,ROUTE_TABLE_TAG,VPC_ID,VPC_TAG"

for ACCT in $( cat ${AWS_ACCTS} );
  do
    export AWS_PROFILE=${ACCT}

    for RTB_ID in $( aws ec2 describe-route-tables --query "RouteTables[].RouteTableId[]" --output text );
      do
        RTB_TAG=$( aws ec2 describe-route-tables --filters "Name=route-table-id,Values=${RTB_ID}" --query 'RouteTables[].Tags[?Key==`Name`].Value[]' --output text )
	[[ -z ${RTB_TAG} ]] && RTB_TAG="UNTAGGED"
        VPC_ID=$( aws ec2 describe-route-tables --filters "Name=route-table-id,Values=${RTB_ID}" --query 'RouteTables[].VpcId[]' --output text )
	VPC_TAG=$( aws ec2 describe-vpcs --filters "Name=vpc-id,Values=${VPC_ID}" --query 'Vpcs[].Tags[?Key==`Name`].Value[]' --output text )
	[[ -z ${VPC_TAG} ]] && VPC_TAG="UNTAGGED"
        echo "${ACCT},${RTB_ID},${RTB_TAG},${VPC_ID},${VPC_TAG}"
      done
  done
