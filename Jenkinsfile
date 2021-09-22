pipeline {

    environment {
        JAVA_TOOL_OPTIONS = "-Duser.home=/var/maven"
        registry = "horaciocrespo/obo"
        dockerImage = ''
    }

    agent none

    stages {

        // is this stage necessary??
        // stage("Checkout Codebase") {
        //     steps {
        //         // ??
        //         cleanWS()
        //         checkout scm: [
        //             $class: "GitSCM",
        //             branches: [[name: '*/main']],
        //             userRemoteConfigs: [[credentialsId: 'github-ssh-key', url: 'git@github.com:horaciocrespo/JavaChallenge.git']]
        //         ]
        //     }
        // }

        stage("Build") {

            agent {
                docker {
                    image "maven:3.3.3"
                    // use local .m2 repo
                    args "-v /tmp/maven:/var/maven/.m2 -e  MAVEN_CONFIG=/var/maven/.m2"
                }
            }

            steps {
                sh "mvn clean compile"
            }
        }

        // stage("Unit Tests") {
        //     steps {
        //         sh "mvn test"
        //     }

        //     // publish report
        //     post {
        //         always {
        //             junit "**/target/surefire-reports/TEST-*.xml"
        //         }
        //     }
        // }

        stage("Build docker image") {

            agent any

            steps {
                script {
                    dockerImage = docker.build registry + ":$BUILD_NUMBER" 
                }
            }
        }

        stage("Push image to Docker Hub") {

            environment {
                DOCKER_HUB_LOGIN = credentials('docker-hub')
            }

            agent any
            
            steps {
                // sh 'docker login --username=$DOCKER_HUB_LOGIN_USR --password=$DOCKER_HUB_LOGIN_PSW'
                script {
                    docker.withRegistry('', 'docker-hub') {
                        dockerImage.push()
                    }
                }
            }
        }

        stage("Run container on EC2") {
            steps {
                echo "Deploying to EC2..."
            }
        }

        stage("Clean up") {
            steps {
                sh "docker rmi $registry:$BUILD_NUMBER"
            }
        }
    }

    post {
        always {
            cleanWs()
        }
    }
}
