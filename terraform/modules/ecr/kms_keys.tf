resource "aws_kms_key" "app_key" {
    
}
resource "aws_kms_alias" "app_alias" {
    target_key_id = aws_kms_key.app_key.key_id
}
resource "aws_kms_key" "jenkins_key" {
    
}
resource "aws_kms_alias" "jenkins_alias" {
    target_key_id = aws_kms_key.jenkins_key.key_id
}
resource "aws_kms_key" "argo_key" {
    
}
resource "aws_kms_alias" "argo_alias" {
    target_key_id = aws_kms_key.argo_key.key_id
}
resource "aws_kms_key" "app_chart" {
    
}
resource "aws_kms_alias" "app_chart_alias" {
    target_key_id = aws_kms_key.app_chart.key_id
}

#everyone who has access should be able to decrypt 
# the helm provider
# argo cd watcher
# git ci cd
# kubernetes clusters (PROPer IAM roles)
# will the secrets manager contain the keys and does it require access