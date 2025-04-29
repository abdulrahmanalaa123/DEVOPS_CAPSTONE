resource "aws_ecr_repository" "repos" {
    for_each = aws_kms_key.keys
    name = each.value.tags_all.name
    image_tag_mutability = "IMMUTABLE"
    image_scanning_configuration {
      scan_on_push = true
    }
    encryption_configuration {
      encryption_type = "KMS"
      kms_key = each.value.arn
    }
}

