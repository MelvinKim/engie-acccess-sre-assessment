pipeline {
    agent any

    parameters {
        choice(
            name: 'Service',
            choices: ['api-server', 'background-workers', 'messaging-workers', 'payment-workers']
        )
    }

    environment {
        DOCKER_HUB_USERNAME = credentials('<docker-hub-username-credentials-id>')
        DOCKER_HUB_PASSWORD = credentials('<docker-hub-password-credentials-id>')
        DOCKER_IMAGE = "melvinkimathi/koko-sre-assessment:${env.BUILD_NUMBER}"
    }

    stages {
        stage('Checkout repository') {
            steps {
               checkout scmGit(branches: [[name: '*/main']], extensions: [], userRemoteConfigs: [[url: 'https://github.com/MelvinKim/engie-acccess-sre-assessment.git']])
            }
        }
        stage('Run tests') {
            steps {
                sh 'python3 test_app.py'
            }
        }
        stage('Build docker image') {
            steps {
                sh "docker build --platform=linux/amd64 -t ${env.DOCKER_IMAGE} ."
            }
        }
        stage('Push docker image to docker image to docker hub') {
            steps {
                sh "docker login -username ${env.DOCKER_HUB_USERNAME} --password ${env.DOCKER_HUB_PASSWORD}"
                sh "docker push ${env.DOCKER_IMAGE} ."
            }
        }
        // make sure to configure your jenkins server with AWS credentials that have access to the EKS Cluster
        stage('Deploy app to Kubernetes cluster') {
            steps {
                script {
                    def serviceDirectory = "manifests/charts/${params.Service}"

                    dir(serviceDirectory) {
                        sh """
                            export AWS_PROFILE=<aws-profile-containing-kubernetes-cluster>
                            aws eks update-kubeconfig --name <k8s-cluster-name>
                            helm upgrade --install ${params.Service} .
                        """
                    }
                }
            }
        }
    }
}