pipeline {
    agent {
        label 'jenkins-worker'
    }
    environment {
        IMAGE_NAME = "agrynov/step2:latest"
    }
    stages {
        stage('Checkout') {
            steps {
                git branch: 'main', credentialsId: 'github-creds', url: 'https://github.com/agrynov/step2'
            }
        }
        stage('Build Docker Image') {
            steps {
                script{
                docker.build('agrynov/step2:latest')
                }
            }
        }
        stage('Run Tests') {
            steps {
                script {
                    try {
                          sh "docker run --rm agrynov/step2:latest npm test"
                        } catch (Exception e) {
                          error("Test failed")
                     }
                }
            }
        }
        stage('Push to Docker Hub') {
            environment {
                DOCKER_HUB_CREDENTIALS = credentials('docker-hub')
            }
            steps {
                sh '''
                    echo "$DOCKER_HUB_CREDENTIALS_PSW" | docker login -u "$DOCKER_HUB_CREDENTIALS_USR" --password-stdin
                    docker push $IMAGE_NAME
                '''
            }
        }
    }
}
