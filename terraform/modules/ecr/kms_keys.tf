resource "aws_kms_key" "keys" {
    for_each = {for repo in var.repo_list : repo => repo}
    tags = {"name": "${each.value}"}
    description = "KMS key for the ${each.value}"
    deletion_window_in_days = 7
    enable_key_rotation = true
}
resource "aws_kms_alias" "app_alias" {
    for_each = aws_kms_key.keys
    name = "alias/${each.value.tags_all.name}"
    target_key_id = each.value.key_id
}


# #everyone who has access should be able to decrypt 
# # the helm provider
# # argo cd watcher
# # git ci cd
# # kubernetes clusters (PROPer IAM roles)
# # will the secrets manager contain the keys and does it require access