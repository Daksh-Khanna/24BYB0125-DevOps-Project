pipeline {
    agent any

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
                bat 'docker build -t online-portfolio:latest .'
            }
        }

    }

    post {
        success {
            echo 'Docker image built successfully!'
        }

        failure {
            echo 'Pipeline failed.'
        }
    }
}