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
                    } else if (env.BRANCH_NAME == "dev") {
                        IMAGE_TAG = "dev"
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

                    sh "echo $DOCKER_PASSWORD | docker login -u $DOCKER_USERNAME --password-stdin"

                }
            }
        }

        stage('Push Dev Image') {
            when {
                branch 'dev'
            }
            steps {
                sh """
                docker tag ${IMAGE_NAME}:${IMAGE_TAG} ${DOCKER_USER}/${DEV_REPO}:${IMAGE_TAG}
                docker push ${DOCKER_USER}/${DEV_REPO}:${IMAGE_TAG}
                """
            }
        }

        stage('Push Prod Image') {
            when {
                branch 'master'
            }
            steps {
                sh """
                docker tag ${IMAGE_NAME}:${IMAGE_TAG} ${DOCKER_USER}/${PROD_REPO}:${IMAGE_TAG}
                docker push ${DOCKER_USER}/${PROD_REPO}:${IMAGE_TAG}
                """
            }
        }

        stage('Deploy to EC2') {
            steps {
                sshagent(['ubuntu']) {
                    sh """
                    ssh -o StrictHostKeyChecking=no ${EC2_USER}@${EC2_IP} '
                        cd /home/${EC2_USER}
                        chmod +x deploy.sh
                        ./deploy.sh ${IMAGE_TAG}
                    '
                    """
                }
            }
        }
    }
}
