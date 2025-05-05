pipeline {
    agent any

    environment {
        DOCKERHUB_USERNAME = credentials('dockerhub-username')
        DOCKERHUB_PASSWORD = credentials('dockerhub-password')
    }

    stages {
        stage('Clone Repo') {
            steps {
                git 'https://github.com/your-username/web-calculator.git'
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    docker.build("web-calculator:latest")
                }
            }
        }

        stage('Push Docker Image') {
            steps {
                script {
                    docker.withRegistry('https://index.docker.io/v1/', 'dockerhub-credentials-id') {
                        docker.image("web-calculator:latest").push("latest")
                    }
                }
            }
        }

        stage('Deploy with Terraform') {
            steps {
                dir('terraform') {
                    sh 'terraform init'
                    sh 'terraform apply -auto-approve -var="key_name=your-key-name" -var="public_key_path=~/.ssh/your-key.pem"'
                }
            }
        }
    }
}
