output "repos_links" {
  value = [ for repo in aws_ecr_repository.repos: repo.repository_url ]
}