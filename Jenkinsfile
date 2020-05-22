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
                        customImage.push('latest')
                    }
                }
            }
        }
        stage ("Deploying") {
            steps {
                withAWS(region:'us-west-2',credentials:'AWSCredentials') {
                    sh 'aws eks update-kubeconfig --name Udacity-K8s-Cluster'
                    sh 'kubectl version'
                    sh 'sed -i "s|REPLACETAG|${env.BUILD_ID}|g" deploy/deployment.yaml'
                    sh 'kubectl apply -R -f deploy/'
                }
            }
        }
    }
}