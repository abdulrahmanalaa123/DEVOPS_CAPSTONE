resource "aws_ecr_repository" "image_repo" {
    name = "application"
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
  name = "application"
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
  name = "application"
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
  name = "application"
    image_tag_mutability = "IMMUTABLE"
    image_scanning_configuration {
      scan_on_push = true
    }
    encryption_configuration {
      encryption_type = "KMS"
      kms_key = aws_kms_key.app_chart.arn
    }
}