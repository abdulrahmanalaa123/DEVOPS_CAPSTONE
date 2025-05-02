pipeline {
    agent {
        kubernetes {
            yaml '''
                apiVersion: v1
                kind: Pod
                metadata:
                  labels:
                    jenkins: slave
                spec:
                  containers:
                  - name: docker
                    image: docker:dind
                    securityContext:
                      privileged: true
                    tty: true
                    command:
                    - dockerd
                    - --host=unix:///var/run/docker.sock
                    - --host=tcp://0.0.0.0:2375
                    - --tls=false
                  - name: aws
                    image: amazon/aws-cli:latest
                    command:
                    - cat
                    tty: true
                  volumes:
                  - name: docker-sock
                    emptyDir: {}
            '''
        }
    }
        
    environment {
        AWS_ACCESS_KEY_ID     = credentials('AWS_ACCESS_KEY_ID')
        AWS_SECRET_ACCESS_KEY = credentials('AWS_SECRET_ACCESS_KEY')
        AWS_DEFAULT_REGION    = 'us-east-1'
        DOCKER_IMAGE_TAG      = params.Release
        ECR_REPO_NAME        = 'az3_app'
        DOCKER_HOST          = 'tcp://localhost:2375'
    }

    options {
        skipDefaultCheckout(false)
        timeout(time: 30, unit: 'MINUTES')
        buildDiscarder(logRotator(numToKeepStr: '10'))
    }

    stages {
        stage('Checkout') {
            steps {
                git url: 'https://github.com/AbdElRhmanArafa/nodejs-app.git', branch: 'main'
            }
        }

        stage('Verify Tools') {
            steps {
                container('docker') {
                    sh '''
                        sleep 20 # Wait for Docker daemon to start
                        docker --version
                        docker info
                    '''
                }
                container('aws') {
                    sh 'aws --version'
                }
            }
        }

        stage('AWS Configure') {
            steps {
                container('aws') {
                    sh '''
                        aws configure set aws_access_key_id "$AWS_ACCESS_KEY_ID"
                        aws configure set aws_secret_access_key "$AWS_SECRET_ACCESS_KEY"
                        aws configure set region $AWS_DEFAULT_REGION
                        aws sts get-caller-identity
                    '''
                }
            }
        }

        stage('Get ECR Info') {
            steps {
                container('aws') {
                    script {
                        // Get AWS account ID for the ECR registry URL
                        env.AWS_ACCOUNT_ID = sh(
                            script: 'aws sts get-caller-identity --query "Account" --output text',
                            returnStdout: true
                        ).trim()
                        
                        // Use ECR_REPO_NAME variable directly
                        env.REGISTRY = "${env.AWS_ACCOUNT_ID}.dkr.ecr.${AWS_DEFAULT_REGION}.amazonaws.com"
                        env.REPOSITORY = "${ECR_REPO_NAME}"
                        
                        echo "REGISTRY=${env.REGISTRY}"
                        echo "REPOSITORY=${env.REPOSITORY}"
                        
                        // Get ECR login password and store it
                        env.ECR_PASSWORD = sh(
                            script: "aws ecr get-login-password --region ${AWS_DEFAULT_REGION}",
                            returnStdout: true
                        ).trim()
                    }
                }
            }
        }

        stage('Build & Push Docker Image') {
            steps {
                container('docker') {
                    dir('nodeapp') {
                        script {
                            sh """  
                                ls -l 
                                echo '${env.ECR_PASSWORD}' | docker login --username AWS --password-stdin ${env.REGISTRY}
                            """
                            sh """
                                docker build -t ${env.REGISTRY}/${env.REPOSITORY}:${DOCKER_IMAGE_TAG} .
                                docker push ${env.REGISTRY}/${env.REPOSITORY}:${DOCKER_IMAGE_TAG}
                            """
                        }
                    }
                }
            }
        }
    }
}