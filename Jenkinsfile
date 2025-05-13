pipeline {
    agent any
     tools {
        jdk 'jdk17'
        nodejs 'node16'
    }
    environment {
        // Define your environment variables here
        DOCKERHUB_CREDENTIALS = credentials('dockerhub-credentials')
        DOCKER_IMAGE = 'ninjaadevops/python-calculator'
        DOCKER_TAG = 'latest'
    }
    
    stages {
        stage('Checkout') {
            steps {
                // Checkout code from your repository
                git branch: 'main', url: 'https://github.com/ninjaadevops/python-calculator.git'
            }
        }
        
        stage('Build Docker Image') {
            steps {
                script {
                    // Build the Docker image
                    docker.build("${env.DOCKER_IMAGE}:${env.DOCKER_TAG}")
                    
                }
            }
        }
        
        stage('Push to DockerHub') {
            steps {
                script {
                    // Authenticate and push to DockerHub
                    withCredentials([usernamePassword(credentialsId: 'dockerhub-credentials', passwordVariable: 'DOCKERHUB_PASSWORD', usernameVariable: 'DOCKERHUB_USERNAME')]) {
                        sh "docker login -u ${env.DOCKERHUB_USERNAME} -p ${env.DOCKERHUB_PASSWORD}"
                        sh "docker push ${env.DOCKER_IMAGE}:${env.DOCKER_TAG}"
                        sh "docker push ${env.DOCKER_IMAGE}:${env.GIT_COMMIT_SHORT}"
                    }
                }
            }
        }
        
        stage('Cleanup') {
            steps {
                script {
                    // Clean up Docker images to save space
                    sh 'docker system prune -f'
                }
            }
        }
    }
    
    post {
        always {
            // Clean workspace after build
            cleanWs()
        }
        success {
            echo 'Docker image built and pushed to DockerHub successfully!'
        }
        failure {
            echo 'Build failed! Check the logs for details.'
        }
    }
}
