pipeline {
    environment {
        IMAGEN = "gonzalomarin/practica-jenkins"
        LOGIN = 'USER_DOCKERHUB'
    }
    agent none
    stages {
        stage("Testeos de Django") {
            agent {
                docker { image "python:3"
                args '-u root:root'
                }
            }
            stages {
                stage('Clone') {
                    steps {
                        git branch:'main',url:'https://github.com/gonzalomaring/jenkins-django.git'
                    }
                }
                stage('Install') {
                    steps {
                        sh 'pip install -r requirements.txt'
                    }
                }
                stage('Test')
                {
                    steps {
                        sh 'python3 manage.py test'
                    }
                }

            }
        }
        stage("Build y push") {
            agent any
            stages {
                stage('CloneAnfitrion') {
                    steps {
                        git branch:'main',url:'https://github.com/gonzalomaring/docker-django.git'
                    }
                }
                stage('BuildImage') {
                    steps {
                        script {
                            newApp = docker.build "$IMAGEN:latest"
                        }
                    }
                }
                stage('UploadImage') {
                    steps {
                        script {
                            docker.withRegistry( '', LOGIN ) {
                                newApp.push()
                            }
                        }
                    }
                }
                stage('RemoveImage') {
                    steps {
                        sh "docker rmi $IMAGEN:latest"
                    }
                }
                stage ('SSH') {
                    steps{
                        sshagent(credentials : ['SSH_GONZALO']) {
                            sh 'ssh -o StrictHostKeyChecking=no gonzalo@atreus.toluka.es wget https://raw.githubusercontent.com/gonzalomaring/docker-django/main/docker-compose.yaml -O docker-compose.yaml'
                            sh 'ssh -o StrictHostKeyChecking=no  gonzalo@atreus.toluka.es sudo docker-compose up -d --force-recreate'
        }
    }
}
            }
        }           
    }
    post {
        always {
            mail to: 'gonzalomaringomez@gmail.com',
            subject: "Status of pipeline: ${currentBuild.fullDisplayName}",
            body: "${env.BUILD_URL} has result ${currentBuild.result}"
        }
    }
}
