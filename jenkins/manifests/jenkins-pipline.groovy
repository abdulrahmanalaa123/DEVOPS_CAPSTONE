pipeline {
    agent any

    environment {
        ECR_REPO = 'your-ecr-name'
        AWS_REGION = 'region'  
        IMAGE_TAG = "${env.BUILD_ID}"
    }

    stages {
        stage('Checkout') {
            steps {
                git clone  'repo url'
            }
        }

        stage('Build and Push Docker Image') {
            steps {
                script {
                    def appImage = docker.build("${ECR_REPO}:${IMAGE_TAG}")
                    docker.withRegistry("https://${ECR_REPO}.dkr.ecr.${AWS_REGION}.amazonaws.com", 'ecr:aws-credentials') {
                        appImage.push()
                    }
                }
            }
        }

        stage('Run Terraform') {
            steps {
                script {
                    sh 'terraform init'
                    sh 'terraform apply -auto-approve'
                }
            }
        }
    }
}
