pipeline {
    agent {
        docker {
            image "gradle:4.6-jdk8-alpine"
            label "docker-agent"
            args "-v ${env.HOME}/.gradle:/home/gradle/.gradle"
        }
    }
    stages {
        
        stage('Compile') {
            steps{
                sh "./gradlew compileJava"
            }
        }
        
        stage('Unit test') {
            steps{
                sh "./gradlew test"
            }
        }
        
        stage("Code coverage") {
            steps {
                sh "./gradlew jacocoTestReport"
                publishHTML (target: [
                    reportDir: 'build/reports/jacoco/test/html',
                    reportFiles: 'index.html',
                    reportName: "JaCoCo Report" ])
                sh "./gradlew jacocoTestCoverageVerification"
            }
        }

        stage("Static code analysis") {
            steps {
                sh "./gradlew checkstyleMain"
                publishHTML (target: [
                    reportDir: 'build/reports/checkstyle/',
                    reportFiles: 'main.html',
                    reportName: "Checkstyle Report"
                ])
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