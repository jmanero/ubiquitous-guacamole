ubiquitous-guacamole
====================

Implement a [Dynamic DNS](https://aws.amazon.com/blogs/startups/how-to-build-a-serverless-dynamic-dns-system-with-aws/) service using Amazon Route53, Lambda, and API Gateway

## Container Images

This repository pushes images to an [ECR Public Repository](https://gallery.ecr.aws/r2g9b1i0/functions/ubiquitous-guacamole) for use with AWS Lambda.

## Terraform

The [terraform](./terraform/) direcotry contains modules to configure AWS build and application resources for the project. The [app](./terraform/modules/app/) module can be reused to configure APIGW, Lambda, and associated resources for your own AWS account and Route53 zone using images build by this repository.
