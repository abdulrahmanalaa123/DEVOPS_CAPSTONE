# Infrastructure Initialization
- First init the terraform state using 
```
terraform init 
```
- make sure your default aws configured profile has access to the state bucket to initialize the state or create the state bucket on your own account
- or simply add the `profile` option to the `backend` block 
```
terraform {
	backend "s3" {
		profile = 'profile_name_with_access'
	}
}
```
- assign your own values by creating `x.tfvars` and use it inside your plans using the option `-var-file=x.tfvars`
```
terraform apply -var-file=x.tfvars
```

## Modules

### Backend 
- Initially a backend state bucket `capstone-3az-backend` is initialized first which isn't managed by terraform just to have a shared state file between users sharing the code
- Make sure to have the bucket with the same name of simply rename the backend state file editing the region and the bucket name

### Networking
- It's the base infrastructure that initializes everything currently configured to intialize a vpc given cidr with the `x.tfvars` configuration file or simply use the default 
- Configured to create 3 private subnets and 3 public subnets across 3 AZS 
- creating 3 NATS inside each public subnets to enable outside access for the nodes to be created connected to the IGW

### EKS
- Provisioning the EKS cluster alongside its nodes with proper roles and access credentials
- Setting UP the EKS as an OIDC provider using its certificate to enable assigning roles to created service accounts and pods to assume specific Roles
- The variables requried to initiate the cluster are simply the `cluster_name` and the private subnets you want to allocate the nodes inside with `private_subnet_ids`

### Helm
- The helm provider depends on the EKS module running first to be able to deploy selected charts on your eks server configuring it with the cluster's endpoint and authorization to the cluster
- The helm module is responsible for provisioning hlem charts that should be managed by terraform which in our case are `argocd` and the `argocd_image_updater` 
- The other charts are managed by argo to enable the CD cycle for argo to manage, watch, and initiate the application's chart as well as jenkins.
- This was done using the the null resource inside the main terraform entrypoint `main.tf`
```
resource "null_resource" "apply_argocd_root_application" {
  depends_on = [
    module.helm.argocd
  ]
  provisioner "local-exec" {
    command = <<-EOT
      aws eks update-kubeconfig --name ${module.eks.cluster_name} --region ${var.aws_region}
      kubectl apply -f ../argo-cd/argocd-manifests/argocd.yaml
    EOT
  }
} 
```

### Iam Role issuer
- A Module configured with the EKS OIDC provider that provides roles to service accounts applying the concept of least privilege giving certain pods only the needed permissions to perform their role inside our infrastructure [reference link](https://docs.aws.amazon.com/eks/latest/userguide/iam-roles-for-service-accounts.html)

### ECR
- The ECR module initializes rqeuired repositories given simply the repository name initializing required KMS key for encryption of the repository at rest
- As well as giving the EKS the required policy for accessing the repository inside the module to enable modularity and assigning permissions when needed 

## Exepected Architecture after initialization

