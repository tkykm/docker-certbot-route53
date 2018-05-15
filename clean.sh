#!/bin/sh

CREATE_DOMAIN="_acme-challenge.$CERTBOT_DOMAIN"
record="
{'Comment': 'clean record for update of lets ecnrypt',
  'Changes': [
    {
      'Action': 'DELETE',
      'ResourceRecordSet': {
        'ResourceRecords': [
          {
            'Value': '\\\"${CERTBOT_VALIDATION}\\\"'
          }
        ],
        'Type': 'TXT',
        'Name': '${CREATE_DOMAIN}',
        'TTL': 300
      }
    }
  ]
}"
echo "${record//\'/\"}" > tmp
aws route53 change-resource-record-sets --hosted-zone-id $AWS_ROUTE53_HOSTED_ZONE_ID --change-batch file://tmp
rm -f tmp
