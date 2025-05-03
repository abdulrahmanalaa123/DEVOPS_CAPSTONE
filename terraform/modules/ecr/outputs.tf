output "registries_urls" {
  value = [ for repository in aws_ecr_repository.repos : repository.repository_url ]
}