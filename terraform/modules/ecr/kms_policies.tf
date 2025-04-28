data "aws_iam_policy_document" "key_policies" {
  statement {
    effect = "Allow"
    actions = [
        "kms:*"
    ]
    resources = ["*"]
    principals {
      type = "AWS"
      # giving the kms key access to the root account and all the worker nodes and the control plane
      identifiers = [local.principal_root_arn]
    }
  }
  statement {
    effect = "Allow"
    actions = [
                "kms:Encrypt",
                "kms:Decrypt",
                "kms:ReEncrypt*",
                "kms:GenerateDataKey*",
                "kms:DescribeKey"
    ]
    resources = ["*"]
    principals {
      type = "AWS"
      #allwo usage of the key for the cluster role and the worker role
      identifiers = [
        "arn:aws:iam:${local.current_account_id}:role/${var.cluster_role_name}",
      "arn:aws:iam:${local.current_account_id}:role/${var.worker_role_name}"
      ]
    }
  }
}

resource "aws_kms_key_policy" "image_key_policy" {
    key_id = aws_kms_key.app_key.key_id 
    policy = data.aws_iam_policy_document.key_policies
}
resource "aws_kms_key_policy" "image_chart_key_policy" {
    key_id = aws_kms_key.app_chart.key_id 
    policy = data.aws_iam_policy_document.key_policies
}
resource "aws_kms_key_policy" "jenkins_chart_key_policy" {
    key_id = aws_kms_key.jenkins_key.key_id 
    policy = data.aws_iam_policy_document.key_policies
}
resource "aws_kms_key_policy" "argo_chart_key_policy" {
    key_id = aws_kms_key.argo_key.key_id 
    policy = data.aws_iam_policy_document.key_policies
}