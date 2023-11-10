pipeline {
    agent any
    environment {
        DOCKERHUB_CREDENTIALS = credentials('jenkins-token1')
    }
    stages {
        stage('Clone repository') {
            steps {
                git 'https://github.com/SixCosti/JenkinsPipelineTask2'
            }
        }
        stage('Build Docker Images') {
            steps {
                dir('db') {
                    sh 'docker build -t my-mysql-image .'
                }
                dir('flask-app') {
                    sh 'docker build -t my-flask-app-image .'
                }
            }
        }
        stage('Deploy') {
            steps {
                sh 'chmod +x deploy.sh'
                sh './deploy.sh'
            }
        }
        stage('Push to Docker Hub') {
            steps {

                sh "echo \$DOCKERHUB_CREDENTIALS_PSW | docker login -u \$DOCKERHUB_CREDENTIALS_USR --password-stdin"

                sh 'docker tag my-mysql-image costii/my-mysql-image'
                sh 'docker push costii/my-mysql-image'
                sh 'docker tag my-flask-app-image costii/my-flask-app-image'
                sh 'docker push costii/my-flask-app-image'
                }
            }       
        }
    post {
        always {
            sh 'docker-compose down'
            sh 'docker logout'
        }
    }
}
