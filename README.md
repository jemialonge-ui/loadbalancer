This is a project to generate an AWS infrastructure system.
This infrastructure system consists of three environments (dev, qa and prod)
In each environment, two EC2 instances are created and they are supported by a VPC and an application load balancer.
The VPCs is initially set up to have two availability zones.
Each availability zone has a private subnet and a public subnet.
Each availability zone has a NAT gateway to connect the devices on the private subnet in that availability zone to the internet
There is also an S3 bucket created for each environment.
Some databases will soon be added as the project continues
It is also worth noting that https is not yet enables (the EC2 instances are connected by http for now)
Each of the EC2 instances has an internal root_block_device and an external ECS volume attached to it
Also the EC2 instances are on a public network because I wanted to be able to ssh into them, under normal conditions this should not be so as the EC2 instances must be on private subnets.

There is also a file "environ/$ENV/cost_without_DBS.txt" (for example -- environ/qa/cost_without_DBS.txt) that shows the estimated monthly cost of running the infrastructure system when it is setup.

We still do not have the databases yet.

To run,
clone this repository
cd environ/$environment ##where $environment could be dev, qa or prod
run the terraform commands (terraform init, terraform plan or terraform apply)
When the whole system has been set up, please remember to take a look at the loadbalancer
Have fun
