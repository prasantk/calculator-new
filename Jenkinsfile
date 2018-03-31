pipeline {
    agent {
        label 'docker-agent'
    }
    environment {
        shortCommit = sh(returnStdout: true, script: "git log -n 1 --pretty=format:'%h'").trim()
        tag = "${env.BUILD_NUMBER}_${shortCommit}"
    }
    stages {
        
        stage('Compile') {
            agent {
                docker {
                    reuseNode true
                    image "gradle:4.6-jdk8-alpine"
                    args "-v /root/.gradle:/home/gradle/.gradle --network jenkins_default"
                }
            }
            steps{
                sh "./gradlew compileJava"
            }
        }
        
        stage('Unit test') {
            agent {
                docker {
                    reuseNode true
                    image "gradle:4.6-jdk8-alpine"
                    args "-v /root/.gradle:/home/gradle/.gradle --network jenkins_default"
                }
            }
            steps{
                sh "./gradlew test"
            }
        }
        
        // stage("Code coverage") {
        //     steps {
        //         sh "./gradlew jacocoTestReport"
        //         publishHTML (target: [
        //             reportDir: 'build/reports/jacoco/test/html',
        //             reportFiles: 'index.html',
        //             reportName: "JaCoCo Report" ])
        //         sh "./gradlew jacocoTestCoverageVerification"
        //     }
        // }

        // stage("Static code analysis") {
        //     steps {
        //         sh "./gradlew checkstyleMain"
        //         publishHTML (target: [
        //             reportDir: 'build/reports/checkstyle/',
        //             reportFiles: 'main.html',
        //             reportName: "Checkstyle Report"
        //         ])
        //     }
        // }

        stage('SonarQube analysis') {
            agent {
                docker {
                    reuseNode true
                    image "gradle:4.6-jdk8-alpine"
                    args "-v /root/.gradle:/home/gradle/.gradle --network jenkins_default"
                }
            }
            steps {
                withSonarQubeEnv('SonarQube') {
                    sh "./gradlew sonarqube -Dsonar.projectVersion=${env.BUILD_NUMBER}"
                }
            }
        }

        stage("Package") {
            agent {
                docker {
                    reuseNode true
                    image "gradle:4.6-jdk8-alpine"
                    args "-v /root/.gradle:/home/gradle/.gradle --network jenkins_default"
                }
            }
            steps {
                sh "./gradlew clean build"
            }
        }

        stage("Docker build") {
            steps {
                sh "docker build -t prasantk/calculator ."
            }
        }

        stage("Docker login") {
            steps {
                withCredentials([[$class: 'UsernamePasswordMultiBinding', credentialsId: 'dockerhub',
                                usernameVariable: 'USERNAME', passwordVariable: 'PASSWORD']]) {
                    sh "docker login --username $USERNAME --password $PASSWORD"
                }
            }
        }

        stage("Docker push") {
            steps {
                sh "docker push prasantk/calculator:${env.tag}"
            }
        }
    }
    
    post {
        success {
            slackSend (color: '#00FF00', message: "SUCCESSFUL: Job '${env.JOB_NAME} [${env.BUILD_NUMBER}]' (${env.BUILD_URL})")
        }

        failure {
            slackSend (color: '#FF0000', message: "FAILED: Job '${env.JOB_NAME} [${env.BUILD_NUMBER}]' (${env.BUILD_URL})")           
        }
    }
}