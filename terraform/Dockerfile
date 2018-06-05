FROM golang:1.9

RUN go get -u github.com/dgrijalva/jwt-go/cmd/jwt

RUN go get -u github.com/cloudflare/cfssl/cmd/...

FROM ubuntu:18.04

COPY --from=0 /go/bin/jwt /usr/bin/jwt
COPY --from=0 /go/bin/cfssl /usr/bin/cfssl
COPY --from=0 /go/bin/cfssljson /usr/bin/cfssljson

RUN apt-get update \
  && apt-get install -y curl apt-transport-https gnupg openssh-client build-essential \
  && echo "deb [arch=amd64] https://packages.microsoft.com/repos/azure-cli/ bionic main" \
  | tee /etc/apt/sources.list.d/azure-cli.list \
  && curl -L https://packages.microsoft.com/keys/microsoft.asc | apt-key add - \
  && apt-get update \
  && apt-get install -y unzip jq build-essential azure-cli \
  && rm -rf /var/lib/apt/lists/*

ENV TERRAFORM_VERSION=0.11.7
RUN curl -L -o tf.zip "https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip" \
  && unzip tf.zip \
  && rm tf.zip \
  && mv terraform /usr/bin/terraform

ENV KUBECTL_VERSION=1.10.3
RUN curl -Lo /usr/bin/kubectl "https://storage.googleapis.com/kubernetes-release/release/v${KUBECTL_VERSION}/bin/linux/amd64/kubectl" \
  && chmod +x /usr/bin/kubectl
