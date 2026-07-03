pipeline {
    agent any

    environment {
        IMAGE_NAME = "dakshkhanna/online-portfolio"
    }

    stages {

        stage('Validate') {
            steps {
                bat 'if not exist src\\index.html exit 1'
                bat 'if not exist Dockerfile exit 1'
                bat 'if not exist nginx.conf exit 1'
            }
        }

        stage('Build Docker Image') {
            steps {
                bat 'docker build -t %IMAGE_NAME%:latest .'
            }
        }

        stage('Push to Docker Hub') {
            steps {
                withCredentials([usernamePassword(
                    credentialsId: 'dockerhub-creds',
                    usernameVariable: 'DOCKER_USER',
                    passwordVariable: 'DOCKER_PASS'
                )]) {
                    bat '''
                    echo %DOCKER_PASS% | docker login -u %DOCKER_USER% --password-stdin
                    docker push %IMAGE_NAME%:latest
                    docker logout
                    '''
                }
            }
        }
    }

    post {
        success {
            echo 'Docker image built and pushed successfully!'
        }

        failure {
            echo 'Pipeline failed.'
        }
    }
}