resource "aws_ecr_repository" "image_repo" {
    name = "az3_app"
    image_tag_mutability = "IMMUTABLE"
    image_scanning_configuration {
      scan_on_push = true
    }
    encryption_configuration {
      encryption_type = "KMS"
      kms_key = aws_kms_key.app_key.arn
    }
}
resource "aws_ecr_repository" "jenkins_chart_repo" {
  name = "az3_jenkins"
    image_tag_mutability = "IMMUTABLE"
    image_scanning_configuration {
      scan_on_push = true
    }
    encryption_configuration     {
      encryption_type = "KMS"
      kms_key = aws_kms_key.jenkins_key.arn
    }
}
resource "aws_ecr_repository" "argo_chart_repo" {
  name = "az3_argo"
    image_tag_mutability = "IMMUTABLE"
    image_scanning_configuration {
      scan_on_push = true
    }
    encryption_configuration {
      encryption_type = "KMS"
      kms_key = aws_kms_key.argo_key.arn
    }
}
resource "aws_ecr_repository" "image_chart" {
  name = "az3_app_chart"
    image_tag_mutability = "IMMUTABLE"
    image_scanning_configuration {
      scan_on_push = true
    }
    encryption_configuration {
      encryption_type = "KMS"
      kms_key = aws_kms_key.app_chart.arn
    }
}

