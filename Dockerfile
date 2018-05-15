FROM certbot/certbot:latest
RUN \
  mkdir -p /aws && \
  apk -Uuv add groff less && \
  pip install awscli && \
  rm /var/cache/apk/*

RUN apk -Uuv add bash

COPY auth.sh /aws/
COPY clean.sh /aws/
COPY entry.sh /aws/

WORKDIR /aws

ENTRYPOINT ["/aws/entry.sh"]
