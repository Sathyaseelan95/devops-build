pipeline {
    agent any

    environment {
        DOCKER_USER = "sathyaseelans"
        DEV_REPO = "dev"
        PROD_REPO = "prod"
        IMAGE_NAME = "devops-build"

        EC2_USER = "ubuntu"
        EC2_IP   = "13.204.79.117"

        GIT_REPO = "https://github.com/Sathyaseelan95/devops-build.git"
    }

    stages {

        stage('Checkout Code') {
            steps {
                checkout scm
            }
        }

        stage('Build Docker Image') {
            steps {
                sh "docker build -t ${IMAGE_NAME}:${BUILD_NUMBER} ."
            }
        }

        stage('Push Dev Image') {
            when {
                branch 'dev'
            }
            steps {
                sh """
                docker tag ${IMAGE_NAME}:${BUILD_NUMBER} ${DOCKER_USER}/${DEV_REPO}:${BUILD_NUMBER}
                docker push ${DOCKER_USER}/${DEV_REPO}:${BUILD_NUMBER}
                """
            }
        }

        stage('Push Prod Image') {
            when {
                branch 'master'
            }
            steps {
                sh """
                docker tag ${IMAGE_NAME}:${BUILD_NUMBER} ${DOCKER_USER}/${PROD_REPO}:${BUILD_NUMBER}
                docker push ${DOCKER_USER}/${PROD_REPO}:${BUILD_NUMBER}
                """
            }
        }

        stage('Deploy to EC2') {
            steps {

                sh """
                ssh -o StrictHostKeyChecking=no ${EC2_USER}@${EC2_IP} '
                    cd /home/${EC2_USER}

                    rm -rf deploy-temp

                    git clone -b ${BRANCH_NAME} ${GIT_REPO} deploy-temp

                    cd deploy-temp

                    chmod +x deploy.sh

                    ./deploy.sh
                '
                """
            }
        }

    }
}
