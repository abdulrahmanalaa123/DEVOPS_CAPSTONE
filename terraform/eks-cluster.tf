module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "19.17.2"

  cluster_name = "myapp-eks-cluster"
  cluster_version = "1.27"


  vpc_id = module.myapp-vpc.vpc_id 
  subnet_ids = module.myapp-vpc.private_subnets
  cluster_endpoint_public_access =  true
  cluster_endpoint_private_access = true


  
  tags = {
    Environment = "dev"
    application = "myapp"
  }


  eks_managed_node_groups = {
    dev = {

      min_size     = 1
      max_size     = 3
      desired_size = 3

      instance_type = "t2.small"
 

      tags = {
        Name = "myapp-eks-nodes"
        Environment = "dev"
      }
    }

  }


}





