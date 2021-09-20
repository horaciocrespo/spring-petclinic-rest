pipeline {

    environment {
        JAVA_TOOL_OPTIONS = "-Duser.home=/var/maven"
    }

    agent {
        docker {
            image "maven:3.3.3"
            // use local .m2 repo
            args "-v /tmp/maven:/var/maven/.m2 -e  MAVEN_CONFIG=/var/maven/.m2"
        }
    }

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
            steps {
                sh "mvn clean compile"
            }
        }

        stage("Unit Tests") {
            steps {
                sh "mvn test"
            }

            // publish report
            post {
                always {
                    junit "**/target/surefire-reports/TEST-*.xml"
                }
            }
        }

        stage("Create docker image") {
            steps {
                echo "create docker image..."
            }
        }

        stage("Deploy image to artifactory, nexus or Docker Hub") {
            steps {
                echo "Deploying to artifactory, nexus or Docker Hub"
            }
        }

        stage("Run container on EC2") {
            steps {
                echo "Deploying to EC2..."
            }
        }
    }

    post {
        always {
            cleanWs()
        }
    }
}
