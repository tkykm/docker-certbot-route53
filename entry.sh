#!/bin/bash

args_domain=""
args_email=""
FLAG_F_DOMAIN=true
domain() {
  args_domain="${args_domain} -d $1"
  if $FLAG_F_DOMAIN ; then
     FLAG_F_DOMAIN=false
     first_domain=`echo $1 | sed -e "s/\*\.//"`
  fi  
}
mail() {
  args_email="--email $1"
}

while getopts :m:d:h OPT
do
    case $OPT in
        m)  mail $OPTARG
            ;;
        d)  domain $OPTARG
            ;;
        h)  usage_exit
            ;;
        \?) usage_exit
            ;;
	:) echo "Option -$OPTARG requires an argument." >&2
	   exit 1
	   ;;
    esac
done
shift $((OPTIND - 1))

if [ "$args_domain" == "" ]; then
  echo "Option -d is required" >&2
  exit 1
fi

if [ "$args_email" == "" ]; then
  echo "Option -m is required" >&2
  exit 1
fi

certbot certonly --manual \
--agree-tos \
--preferred-challenges dns \
--manual-auth-hook /aws/auth.sh \
--manual-cleanup-hook /aws/clean.sh \
--server https://acme-v02.api.letsencrypt.org/directory \
$args_email $args_domain &> tmp_result

cat "/etc/letsencrypt/live/$first_domain/fullchain.pem" || cat tmp_result 
cat "/etc/letsencrypt/live/$first_domain/privkey.pem"


