pipeline {
    agent any
    
    tools {
        jdk 'jdk17'
        nodejs 'node16'
    }

    environment {
        DOCKER_IMAGE = 'ninjaadevops/python-calculator'
        DOCKER_TAG = 'latest'
    }

    stages {
        stage('Checkout') {
            steps {
                git branch: 'main', url: 'https://github.com/ninjaadevops/python-calculator.git'
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    docker.build("${DOCKER_IMAGE}:${DOCKER_TAG}")
                }
            }
        }

        stage('Push to DockerHub') {
            steps {
                script {
                    // Get the short commit hash
                    COMMIT_SHORT = sh(script: 'git rev-parse --short HEAD', returnStdout: true).trim()

                    withCredentials([usernamePassword(
                        credentialsId: 'dockerhub-credentials',
                        usernameVariable: 'DOCKERHUB_USERNAME',
                        passwordVariable: 'DOCKERHUB_PASSWORD'
                    )]) {
                        // Secure login
                        sh '''
                            echo "$DOCKERHUB_PASSWORD" | docker login -u "$DOCKERHUB_USERNAME" --password-stdin
                        '''
                        
                        // Push both 'latest' and short-commit-tagged images
                        sh """
                            docker tag ${DOCKER_IMAGE}:${DOCKER_TAG} ${DOCKER_IMAGE}:${COMMIT_SHORT}
                            docker push ${DOCKER_IMAGE}:${DOCKER_TAG}
                            docker push ${DOCKER_IMAGE}:${COMMIT_SHORT}
                        """
                    }
                }
            }
        }
        
        stage('Deploy to EKS') {
            steps {
             withCredentials([[
                 $class: 'AmazonWebServicesCredentialsBinding',
                  credentialsId: 'aws-eks-creds'
        ]]) {
            sh '''
                aws eks update-kubeconfig --region us-east-1 --name your-eks-cluster-name

                sed "s|IMAGE_PLACEHOLDER|${DOCKER_IMAGE}:${IMAGE_VERSION}|" k8s/deployment.yaml > k8s/deployment-temp.yaml

                kubectl apply -f k8s/deployment-temp.yaml
            '''
            }
        }
    }

        stage('Cleanup') {
            steps {
                sh 'docker system prune -f'
            }
        }
    }

    post {
        always {
            cleanWs()
        }
        success {
            echo '✅ Docker image built and pushed to DockerHub successfully!'
        }
        failure {
            echo '❌ Build failed. Please check the logs above for more info.'
        }
    }
}
