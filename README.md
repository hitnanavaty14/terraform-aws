# terraform-aws
Repo to hold terraform templates for aws

# This repo provisions an Amazon EKS cluster and deploys a web app behind a load balancer

# Prerequisites:
- Terraform cli
- Kubectl
- Aws cli
- Have an AWS account with secrets for access

# The folder consists of:
1. Terraform configuration files used for setting up:
 - Providers (providers.tf)
 - Security groups (security-groups.tf)
 - EKS Cluster (eks-cluster.tf)
 - VPC (vpc.tf)
 - Input Variables (variables.tf)
 - Outputs (outputs.tf to be used downstream and for display on the console)
2. YAML files
 - Hello-World.yml (deploys the web app using the image https://hub.docker.com/r/training/webapp)
 - hello-world-service.yml (deploys the hello world service with which the ingress commnicates)
 - ingress.yml (deploys the ingress and application load balancer)

The creation of resources uses terraform modules (for e.g terraform-aws-modules/eks/aws) to provision the eks cluster.
It also uses some yaml manifests for creating the load-balancer resources.
# Note: Ideally these should be provisioned using terraform, however I was unsuccessful in "describing the ingress" post provisioning. It keeps giving me 403: Unauthorized exception. Seems like it's related to role permissions but could not figure that out.

# Provisioning process:
1. Execute terraform commands
- terraform init
- terraform validate
- terraform plan
- terraform apply

2. Update kube config to interact with the newly created cluster. Use below command 
- aws eks --region $(terraform output -raw region) update-kubeconfig --name $(terraform output -raw cluster_name)

3. Run below command to deploy the application
- kubectl apply -f Hello-World.yml
4. Run below commands to deploy the ingress and services
- kubectl apply -f hello-world-service.yml
- kubectl apply -f ingress.yml

The application runs on the container port 5000. It's being fronted by a hello-world-service running on port 80 which in turn is being fronted by an ingress.

5. Run the below command to get the external-ip of the service.
- kubectl get svc
6. The external-ip should look something like this "a3e1beb7e7d68451aa9d7d40588bae98-848639453.us-west-1.elb.amazonaws.com". Wait for a couple of minutes and try accessing it in the browser. It should respond with "Hello World"

7. The EKS cluster uses "CloudWatch" for logging purposes with API and AUDIT logs enabled. Metrics(e.g CPU Utilization) can be viewed by going to the Metrics Explorer and filtering for "EC2 Instances by Type"
8. Autoscaling is also handled using worker groups.


