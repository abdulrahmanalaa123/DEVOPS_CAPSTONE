pipeline {
    agent {
        label 'nodejs'
    }

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

        stage('Authenticate with ECR') {
            steps {
                script {
                    sh """
                        aws ecr get-login-password --region $AWS_REGION | docker login --username AWS --password-stdin $ECR_REGISTRY
                    """
                }
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    sh """
                        docker build -t $ECR_REPO_NAME:$IMAGE_TAG .
                        docker tag $ECR_REPO_NAME:$IMAGE_TAG $REPOSITORY_URI:$IMAGE_TAG
                    """
                }
            }
        }

        stage('Push to ECR') {
            steps {
                script {
                    sh "docker push $REPOSITORY_URI:$IMAGE_TAG"
                }
            }
        }
    }
}