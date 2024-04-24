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
        DOCKER_IMAGE = " melvinkimathi/engie-access-africa-sre-assessment:${env.BUILD_NUMBER}"
    }

    stages {
        stage('Checkout repository') {
            steps {
               checkout scmGit(branches: [[name: '*/main']], extensions: [], userRemoteConfigs: [[url: 'https://github.com/MelvinKim/engie-acccess-sre-assessment.git']])
            }
        }

        // Ensure python is installed on your jenkins server
        stage('Run tests') {
            dir('sre_challenge') {
                steps {
                    sh """
                        echo 'running application tests'
                    """
                }
            }
        }

        // ensure the docker plugin is installed
        stage('Build docker image') {
            steps {
                sh "docker image build --platform=linux/amd64 -t ${env.DOCKER_IMAGE} ."
            }
        }
        stage('Push docker image to docker image to docker hub') {
            steps {
                sh "docker login -username ${env.DOCKER_HUB_USERNAME} --password ${env.DOCKER_HUB_PASSWORD}"
                sh "docker image push ${env.DOCKER_IMAGE}"
            }
        }

        // make sure to configure your jenkins server with AWS credentials that have access to the EKS Cluster
        // make sure aws cli and helm are installed
        stage('Deploy app to Kubernetes cluster') {
            steps {
                script {
                    def serviceDirectory = "manifests/charts/${params.Service}"

                    dir(serviceDirectory) {
                        sh """
                            export AWS_PROFILE=<aws-profile-containing-kubernetes-cluster>
                            aws eks update-kubeconfig --name <k8s-cluster-name>
                            helm dependency build
                            helm upgrade --install ${params.Service} .
                        """
                    }
                }
            }
        }
    }
}
