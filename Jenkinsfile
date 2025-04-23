pipeline {
    agent any

    environment {
        IMAGE_NAME = 'thenfr932/servlet-app'
        KUBE_CONFIG = credentials('kubeconfig-id') // Jenkins credentials: secret text
    }

    stages {
        stage('Checkout') {
            steps {
                git 'https://github.com/mkhan5707/devopsdef.git'
            }
        }

        stage('Build WAR') {
            steps {
                sh 'mvn clean package'
            }
        }

        stage('Build Docker Image') {
            steps {
                sh 'docker build -t $IMAGE_NAME:$BUILD_NUMBER .'
            }
        }

        stage('Push Docker Image') {
            steps {
                withDockerRegistry([ credentialsId: 'docker-hub-creds', url: '' ]) {
                    sh 'docker push $IMAGE_NAME:$BUILD_NUMBER'
                }
            }
        }

        stage('Deploy to Kubernetes') {
            steps {
                withCredentials([file(credentialsId: 'kubeconfig-id', variable: 'KUBECONFIG_FILE')]) {
                    sh '''
                        export KUBECONFIG=$KUBECONFIG_FILE
                        sed "s|IMAGE_TAG|$IMAGE_NAME:$BUILD_NUMBER|" k8s/deployment-template.yaml > k8s/deployment.yaml
                        kubectl apply -f k8s/deployment.yaml
                    '''
                }
            }
        }
    }
}
