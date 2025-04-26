resource "aws_kms_key" "app_key" {
    description = "KMS key for the application"
    deletion_window_in_days = 7
    enable_key_rotation = true
}
resource "aws_kms_alias" "app_alias" {
    name = "alias/node_app"
    target_key_id = aws_kms_key.app_key.key_id
}
resource "aws_kms_key" "jenkins_key" {
    description = "KMS key for the jenkins chart"
    deletion_window_in_days = 7
    enable_key_rotation = true
}
resource "aws_kms_alias" "jenkins_alias" {
    name = "alias/jenkins_chart"
    target_key_id = aws_kms_key.jenkins_key.key_id
}
resource "aws_kms_key" "argo_key" {
    description = "KMS key for the argo chart"
    deletion_window_in_days = 7
    enable_key_rotation = true
}
resource "aws_kms_alias" "argo_alias" {
    name = "alias/argo_chart"
    target_key_id = aws_kms_key.argo_key.key_id
}
resource "aws_kms_key" "app_chart" {
    description = "KMS key for the application's chart"
    deletion_window_in_days = 7
    enable_key_rotation = true
}
resource "aws_kms_alias" "app_chart_alias" {
    name = "alias/node_chart"
    target_key_id = aws_kms_key.app_chart.key_id
}

#everyone who has access should be able to decrypt 
# the helm provider
# argo cd watcher
# git ci cd
# kubernetes clusters (PROPer IAM roles)
# will the secrets manager contain the keys and does it require access