# Example Voting App

A simple distributed application running across multiple Docker containers.

## Getting started

This project used to develop application in Kubernetes. Terraform used to create infrastructure in EKS, Helm charts used to create deployment files for microservice based appplication, Githubaction used to create docker image and push it to ECR. 

![Git branching strategy for microservice - diagram](eks.drawio.png)

## Prepare EKS cluster 

0. Create AWS Account
1. Create S3 bucket and DynamoDB for saving terraform states  ![S3 and DynamoDB](https://hackernoon.com/
deploying-a-terraform-remote-state-backend-with-aws-s3-and-dynamodb) 

or run script in *terraform/s3_dynamodb* to create it

   ```python
    terraform init
    terraform fmt
    terraform validate
    terraform plan
    terraform apply
   
   ```


2. Change variables in terraform scripts:
    - network, region, version of kubernetes  in `terraform/terraform-aws-eks/environments/eks-dev/main.tf`
    - name of cluster `terraform/terraform-aws-eks/environments/eks-dev/variables.tf`
    - terraform states files for saving states `terraform/terraform-aws-eks/environments/eks-dev/versions.tf`
    - Node Autoscaling files in `terraform/terraform-aws-eks/environments/eks-dev/main.tf`

3. Run script for specific environment from directory `terraform/terraform-aws-eks/environments/eks-dev`

   ```python
    terraform init
    terraform fmt
    terraform validate
    terraform plan
    terraform apply
   
   ```

4. Install ingress controller any which you want

   - [nginx](https://docs.aws.amazon.com/AmazonCloudWatch/latest/monitoring/ContainerInsights-Prometheus-Sample-Workloads-nginx.html) 
   - [traefik](https://saturncloud.io/blog/getting-started-with-traefik-ingress-controller-for-kubernetes-aws-eks/)
   - [haproxy](https://www.haproxy.com/documentation/kubernetes/latest/community/install/aws/)


5. Create service account for GithubAction build and deployment to EKS and apply IAM policy to it
 

   [Create service acccount for github action CICD builds](https://ianbelcher.me/tech-blog/setup-github-actions-for-eks-deployments) 



## Architecture

![Architecture diagram](architecture.excalidraw.png)

* A front-end web app in [Python](/vote) which lets you vote between two options
* A [Redis](https://hub.docker.com/_/redis/) which collects new votes
* A [.NET](/worker/) worker which consumes votes and stores them in…
* A [Postgres](https://hub.docker.com/_/postgres/) database backed by a Docker volume
* A [Node.js](/result) web app which shows the results of the voting in real time


## ALB Ingress 


 -  [Vote](http://k8s-votingap-ingresss-21de9f41b1-1847880095.eu-central-1.elb.amazonaws.com/) 
 -  [Result](http://k8s-votingap-ingresss-b2576822bf-410632684.eu-central-1.elb.amazonaws.com/) 


My ALB was deployed by terraform script by default.


Manual install [ALB Ingress controller](https://github.com/kubernetes-sigs/aws-load-balancer-controller/tree/main/helm/aws-load-balancer-controller)



## Notes

The voting application only accepts one vote per client browser. It does not register additional votes if a vote has already been submitted from a client.



## Additional resources used


1. https://aws.amazon.com/blogs/containers/building-a-gitops-pipeline-with-amazon-eks/
2. https://ianbelcher.me/tech-blog/setup-github-actions-for-eks-deployments
3. https://blog.devops.dev/deploy-to-amazon-eks-using-github-actions-packages-easy-way-out-70b153f04e38
4. https://docs.aws.amazon.com/eks/latest/userguide/create-kubeconfig.html
5. https://medium.com/@jerome.decoster/kubernetes-eks-github-actions-a874321fb9b4
6. https://octopus.com/blog/deploying-amazon-eks-github-actions
7. https://www.weave.works/blog/gitops-with-github-actions-eks
8. https://terraformguru.com/terraform-real-world-on-aws-ec2/20-Remote-State-Storage-with-AWS-S3-and-DynamoDB/