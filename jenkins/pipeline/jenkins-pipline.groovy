pipeline {
    agent any
    environment {
        AWS_REGION = 'us-east-1'
        AWS_ACCOUNT_ID = '129734005271'
        ECR_REPO_NAME = 'az3_app_chart'
        IMAGE_TAG = "${BUILD_NUMBER}"
        ECR_REGISTRY = "${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com"
        REPOSITORY_URI = "${ECR_REGISTRY}/${ECR_REPO_NAME}"
    }

    stages {
        stage('Checkout Code') {
            steps {
                git url: 'https://github.com/AbdElRhmanArafa/nodejs-app.git', branch: 'main'
            }
        }
             stage('Build Docker Image') {
            steps {
                container('dockerizer') {
                    sh """
                        docker build -t mybuild .
                    """
                }
            }
        }

        stage('Authenticate with ECR') {
            steps {
                container('dockerizer') {
                    sh """
                        aws ecr get-login-password --region $AWS_REGION | docker login --username AWS --password-stdin $ECR_REGISTRY
                    """
                }
            }
        }

   
        stage('Push to ECR') {
            steps {
                container('dockerizer') {
                    sh """
                        docker push $REPOSITORY_URI:$IMAGE_TAG
                    """
                }
            }
        }
    }
}