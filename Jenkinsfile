pipeline {
    agent any

    environment {
        DOCKER_USER = "sathyaseelans"
        DEV_REPO = "dev"
        PROD_REPO = "prod"
        IMAGE_NAME = "devops-build"

        EC2_USER = "ubuntu"
        EC2_IP   = "13.233.117.152"

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
                script {
                    BRANCH = env.BRANCH_NAME
                    IMAGE_TAG = (BRANCH == 'master') ? 'prod' : (BRANCH == 'dev') ? 'dev' : 'latest'
                }
                sh "docker build -t ${DOCKER_USER}/${IMAGE_NAME}:${IMAGE_TAG} ."
            }
        }

        stage('Docker Login & Push') {
            steps {
                withCredentials([usernamePassword(
                    credentialsId: 'sathya', 
                    usernameVariable: 'DOCKER_USERNAME', 
                    passwordVariable: 'DOCKER_PASSWORD'
                )]) {
                    sh "echo $DOCKER_PASSWORD | docker login -u $DOCKER_USERNAME --password-stdin"

                    script {
                        // Push based on branch
                        if (env.BRANCH_NAME == 'dev') {
                            sh """
                                docker tag ${DOCKER_USER}/${IMAGE_NAME}:${IMAGE_TAG} ${DOCKER_USER}/${DEV_REPO}:${IMAGE_TAG}
                                docker push ${DOCKER_USER}/${DEV_REPO}:${IMAGE_TAG}
                            """
                        } else if (env.BRANCH_NAME == 'master') {
                            sh """
                                docker tag ${DOCKER_USER}/${IMAGE_NAME}:${IMAGE_TAG} ${DOCKER_USER}/${PROD_REPO}:${IMAGE_TAG}
                                docker push ${DOCKER_USER}/${PROD_REPO}:${IMAGE_TAG}
                            """
                        }
                    }
                }
            }
        }

        stage('Deploy to EC2') {
            steps {
                // Use SSH credentials stored in Jenkins (SSH key)
                sshagent(['ubuntu']) { 
                    sh """
                    ssh -o StrictHostKeyChecking=no ${EC2_USER}@${EC2_IP} '
                        cd /home/${EC2_USER}
                        ./deploy.sh ${BRANCH}
                    '
                    """
                }
            }
        }
    }
}

