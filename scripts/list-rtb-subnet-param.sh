#!/bin/bash

# Author: Marcos Monteiro de Souza, <mrcsmonteiro@gmail.com>

SUBNET_ASSOC_TXT="../tmp/subnet_assoc.txt"
SUBNET_MAIN_TXT="../tmp/subnet_main.txt"
> ${SUBNET_ASSOC_TXT}
> ${SUBNET_MAIN_TXT}

echo "AWS_ACCOUNT_ALIAS,VPC_ID,VPC_TAG,ROUTE_TABLE_ID,ROUTE_TABLE_TAG,SUBNET_ID,SUBNET_TAG"

for ACCT in $1;
  do
    export AWS_PROFILE=${ACCT}

    for RTB in $( aws ec2 describe-route-tables --query "RouteTables[].RouteTableId[]" --output text );
      do
	for SUBNET in $( aws ec2 describe-route-tables --filters "Name=route-table-id,Values=${RTB}" --query 'RouteTables[].Associations[].SubnetId[]' --output text );
          do
            echo ${SUBNET} >> ${SUBNET_ASSOC_TXT}
	    VPC=$( aws ec2 describe-subnets --filters "Name=subnet-id,Values=${SUBNET}" --query 'Subnets[].VpcId[]' --output text )
	    VPC_TAG=$( aws ec2 describe-vpcs --filters "Name=vpc-id,Values=${VPC}" --query 'Vpcs[].Tags[?Key==`Name`].Value[]' --output text )
	    RTB_ID=${RTB}
	    RTB_TAG=$( aws ec2 describe-route-tables --filters "Name=route-table-id,Values=${RTB}" --query 'RouteTables[].Tags[?Key==`Name`].Value[]' --output text )
	    SUBNET_ID=${SUBNET}
	    SUBNET_TAG=$( aws ec2 describe-subnets --filters "Name=subnet-id,Values=${SUBNET}" --query 'Subnets[].Tags[?Key==`Name`].Value[]' --output text )
            echo "${ACCT},${VPC},${VPC_TAG},${RTB_ID},${RTB_TAG},${SUBNET_ID},${SUBNET_TAG}"
	  done
      done

    for SUBNET_ALL in $( aws ec2 describe-subnets --query 'Subnets[].SubnetId[]' --output text );
      do
	grep ${SUBNET_ALL} ${SUBNET_ASSOC_TXT} > /dev/null 2>&1
	RC=$?
	[[ $RC -eq 1 ]] && echo ${SUBNET_ALL} >> ${SUBNET_MAIN_TXT}
      done

    > ${SUBNET_ASSOC_TXT}

    for SUBNET_MAIN in $( cat ${SUBNET_MAIN_TXT} );
      do
        VPC=$( aws ec2 describe-subnets --filters "Name=subnet-id,Values=${SUBNET_MAIN}" --query 'Subnets[].VpcId[]' --output text )
        VPC_TAG=$( aws ec2 describe-vpcs --filters "Name=vpc-id,Values=${VPC}" --query 'Vpcs[].Tags[?Key==`Name`].Value[]' --output text )
	RTB_ID=$( aws ec2 describe-route-tables --filters "Name=association.subnet-id,Values=${SUBNET_MAIN}" --query 'RouteTables[].Associations[].RouteTableId[]' --output text | cut -f1 )
	[[ -z ${RTB_ID} ]] && RTB_ID=$( aws ec2 describe-route-tables --filters "Name=association.main,Values=true" --query 'RouteTables[].Associations[].RouteTableId[]' --output text )
	RTB_TAG=$( aws ec2 describe-route-tables --filters "Name=association.subnet-id,Values=${SUBNET_MAIN}" --query 'RouteTables[].Tags[?Key==`Name`].Value[]' --output text )
        SUBNET_ID=${SUBNET_MAIN}
        SUBNET_TAG=$( aws ec2 describe-subnets --filters "Name=subnet-id,Values=${SUBNET_MAIN}" --query 'Subnets[].Tags[?Key==`Name`].Value[]' --output text )
        echo "${ACCT},${VPC},${VPC_TAG},${RTB_ID},${RTB_TAG},${SUBNET_ID},${SUBNET_TAG}"
      done
    > ${SUBNET_MAIN_TXT}
  done
