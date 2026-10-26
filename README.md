# Elsevier SRE interview lab

Public practice lab for an SRE interview exercise. Terraform will build a small AWS network: a custom VPC, a bastion, a private web tier behind an Application Load Balancer, an Auto Scaling Group, CloudWatch, and an alarm. GitHub Actions will format, validate, plan, and apply after a manual approval.

Nothing in this repository has been applied. There is no Terraform configuration yet.

## Deploy

Not available yet. Apply waits until the account and CIDR check is recorded and the configuration exists.

## Test

Not available yet. The pipeline check will request the load balancer URL and expect the Hello World page.

## Assumptions

- Region `us-east-1`.
- One public GitHub repository, this one, with no long-lived cloud keys in the repo.
- The instance security group will allow HTTP from the load balancer and the bastion, not from the whole internet.
- Package installs are planned through an S3 gateway endpoint, not a NAT gateway.
- The lab is destroyed the same day it is applied. A load balancer and a public IPv4 address bill by the hour.

## Cleanup

`terraform destroy` once the stack exists, then confirm the load balancer, public address, instances, and VPC are gone.
