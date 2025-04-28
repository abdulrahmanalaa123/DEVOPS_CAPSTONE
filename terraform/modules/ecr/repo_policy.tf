#EKS cluster gets with all the kms and secrets management role and ECR
#EKS OIDC gives the roles specifically for each pod (access to SMS and KMS)
#GIVING KMS decrypt to jenkins, argo alongside ECR READ AND EDIT to jenkins
#GIVING SMS to vault and connecting it
#application gets the secrets from vault
#if adding teh private CA authority giving the permission to the EKS
#and finally giving the CA authority to the nginx controller

# this should be attached to the eks
resource "aws_iam_policy" "ecr_access" {
    name = "ecr_access_policy"
    description = "Policy to allow acess to the ECR with the specific keys"
    policy = jsonencode({
        "Version": "2012-10-17",
        "Statement": [{
            "Effect": "Allow",
            "Action": [
                "ecr:*",
            ],
            "Resource" = "arn:aws:ecr:${var.region}:${locals.current_account_id}:repository/*"
        },
        {
            "Effect" = "Allow"
            "Action" = [
                "kms:Decrypt"
            ]
            "Resource" = "arn:aws:kms:${var.region}:${locals.current_account_id}:key/*"
        }
        ]
    })
}

resource "aws_iam_role_policy_attachment" "add_cluster_ecr_access" {
  role       = var.cluster_role_name
  policy_arn = aws_iam_policy.ecr_access.arn
}

resource "aws_iam_role_policy_attachment" "add_worker_ecr_access" {
  role       = var.worker_role_name
  policy_arn = aws_iam_policy.ecr_access.arn
}