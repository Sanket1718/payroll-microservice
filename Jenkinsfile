pipeline {
    agent any
    environment {
        DOCKERHUB_CREDENTIALS = 'docker-hub-creds' 
        IMAGE_NAME = "sanket1718/payroll-app:${BUILD_NUMBER}"
    }
    stages {
        stage('Checkout') {
            steps {
                git branch: 'main', url: 'https://github.com/Sanket1718/payroll-microservice.git'
            }
        }
        stage('Docker Build & Push') {
            steps {
                script {
                    // This pulls your credentials from the Jenkins secret store
                    withCredentials([usernamePassword(credentialsId: "${DOCKERHUB_CREDENTIALS}", passwordVariable: 'PASS', usernameVariable: 'USER')]) {
                        sh "docker build -t ${IMAGE_NAME} ."
                        sh "echo ${PASS} | docker login -u ${USER} --password-stdin"
                        sh "docker push ${IMAGE_NAME}"
                    }
                }
            }
        }
        stage('Deploy to K8s') {
            steps {
                script {
                    // Dynamically update the image tag in your YAML and apply
                    sh "sed -i 's|\${IMAGE_NAME}|${IMAGE_NAME}|g' k8s/deployment.yaml"
                    sh "kubectl apply -f k8s/deployment.yaml"
                }
            }
        }
    }
}
