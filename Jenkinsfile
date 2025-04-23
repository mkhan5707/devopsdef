pipeline {
    agent any

    environment {
        IMAGE_NAME = 'thenfr932/servlet-app'
        KUBE_CONFIG = credentials('kubeconfig-id') // Assuming secret text or file
    }

    stages {
        stage('Checkout') {
            steps {
                git 'https://github.com/mkhan5707/devopsdef.git'
            }
        }

        stage('Build WAR') {
            steps {
                bat 'mvn clean package'
            }
        }

        stage('Build Docker Image') {
            steps {
                bat "docker build -t %IMAGE_NAME%:%BUILD_NUMBER% ."
            }
        }

        stage('Push Docker Image') {
            steps {
                withDockerRegistry([ credentialsId: 'docker-hub-creds', url: '' ]) {
                    bat "docker push %IMAGE_NAME%:%BUILD_NUMBER%"
                }
            }
        }

        stage('Deploy to Kubernetes') {
            steps {
                withCredentials([file(credentialsId: 'kubeconfig-id', variable: 'KUBECONFIG_FILE')]) {
                    bat """
                        set KUBECONFIG=%KUBECONFIG_FILE%
                        powershell -Command "(Get-Content k8s/deployment-template.yaml) -replace 'IMAGE_TAG', '%IMAGE_NAME%:%BUILD_NUMBER%' | Set-Content k8s/deployment.yaml"
                        kubectl apply -f k8s/deployment.yaml
                    """
                }
            }
        }
    }
}
