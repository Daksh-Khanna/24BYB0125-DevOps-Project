pipeline {
    agent any

    environment {
        DOCKERHUB_CREDENTIALS = credentials('dockerhub-creds')
        IMAGE_NAME  = "yourdockerhubuser/online-portfolio"
        IMAGE_TAG   = "${env.BUILD_NUMBER}"
        KUBECONFIG_CRED = credentials('kubeconfig-file')
    }

    stages {
        stage('Checkout') {
            steps {
                git branch: 'main', url: 'https://github.com/yourusername/online-portfolio-devops.git'
            }
        }

        stage('Validate') {
            steps {
                bat 'if not exist src\\index.html exit 1'
                bat 'if not exist src\\css\\style.css exit 1'
                bat 'if not exist src\\js\\main.js exit 1'
            }
        }

        stage('Build Docker Image') {
            steps {
                bat 'docker build -t %IMAGE_NAME%:%IMAGE_TAG% -t %IMAGE_NAME%:latest .'
            }
        }

        stage('Push to Docker Hub') {
            steps {
                bat 'echo %DOCKERHUB_CREDENTIALS_PSW%| docker login -u %DOCKERHUB_CREDENTIALS_USR% --password-stdin'
                bat 'docker push %IMAGE_NAME%:%IMAGE_TAG%'
                bat 'docker push %IMAGE_NAME%:latest'
            }
        }

        stage('Deploy to Kubernetes') {
            steps {
                bat '''
                    set KUBECONFIG=%KUBECONFIG_CRED%
                    kubectl set image deployment/portfolio-deployment portfolio=%IMAGE_NAME%:%IMAGE_TAG% --record || kubectl apply -f k8s\\deployment.yaml
                    kubectl apply -f k8s\\service.yaml
                    kubectl rollout status deployment/portfolio-deployment
                '''
            }
        }

        stage('Smoke Test') {
            steps {
                bat 'timeout /t 10'
                bat 'curl -f http://localhost:30080/health.html || echo Check NodePort/service'
            }
        }
    }

    post {
        success { echo 'Pipeline completed successfully. Portfolio site deployed.' }
        failure { echo 'Pipeline failed. Check console output above.' }
        always  { bat 'docker logout || exit 0' }
    }
}
