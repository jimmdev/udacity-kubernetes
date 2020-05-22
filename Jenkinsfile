pipeline {
    agent any
    stages {
        stage ("lint dockerfile") {
            agent {
                docker {
                    image 'hadolint/hadolint:latest-debian'
                }
            }
            steps {
                sh 'hadolint Dockerfile'
            }
        }
        stage('build docker image') {
            steps {
                echo 'Starting to build docker image'
                script {
                    docker.withRegistry('https://119285437954.dkr.ecr.us-west-2.amazonaws.com', 'ecr:us-west-2:AWSCredentials') {
                        def customImage = docker.build("udacity:${env.BUILD_ID}")
                        customImage.push()
                    }
                }
            }
        }
    }
}