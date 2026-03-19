pipeline {
    agent any

    environment {
        DOCKER_USER = "sathyaseelans"

        DEV_REPO  = "dev"
        PROD_REPO = "prod"

        IMAGE_NAME = "devops-build"

        EC2_USER = "ubuntu"
        EC2_IP   = "35.154.36.55"
    }

    stages {

        stage('Checkout Code') {
            steps {
                checkout scm
            }
        }

        stage('Set Image Tag') {
            steps {
                script {
                    if (env.BRANCH_NAME == "master") {
                        IMAGE_TAG = "prod"
                        REPO_NAME = PROD_REPO
                    } else if (env.BRANCH_NAME == "dev") {
                        IMAGE_TAG = "dev"
                        REPO_NAME = DEV_REPO
                    } else {
                        IMAGE_TAG = "dev"
                        REPO_NAME = DEV_REPO
                    }
                }
            }
        }

        stage('Build Docker Image') {
            steps {
                sh "docker build -t ${IMAGE_NAME}:${IMAGE_TAG} ."
            }
        }

        stage('Docker Login') {
            steps {
                withCredentials([usernamePassword(
                    credentialsId: 'sathya',
                    usernameVariable: 'DOCKER_USERNAME',
                    passwordVariable: 'DOCKER_PASSWORD'
                )]) {
                    sh "echo \$DOCKER_PASSWORD | docker login -u \$DOCKER_USERNAME --password-stdin"
                }
            }
        }

        stage('Push Docker Image') {
            steps {
                sh """
                docker tag ${IMAGE_NAME}:${IMAGE_TAG} ${DOCKER_USER}/${REPO_NAME}:${IMAGE_TAG}
                docker push ${DOCKER_USER}/${REPO_NAME}:${IMAGE_TAG}
                """
            }
        }

        stage('Deploy to EC2') {
            steps {
                sshagent(['ubuntu']) {
                    withCredentials([usernamePassword(
                        credentialsId: 'sathya',
                        usernameVariable: 'DOCKER_USER',
                        passwordVariable: 'DOCKER_PASSWORD'
                    )]) {
                        sh """
                        ssh -o StrictHostKeyChecking=no ${EC2_USER}@${EC2_IP} "
                            export DOCKER_USER=${DOCKER_USER}
                            export DOCKER_PASSWORD=${DOCKER_PASSWORD}
                            cd /home/${EC2_USER}
                            chmod +x deploy.sh
                            ./deploy.sh ${IMAGE_TAG}
                        "
                        """
                    }
                }
            }
        }
    }
}
