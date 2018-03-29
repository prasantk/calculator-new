pipeline {
    agent {
        docker {
            image "gradle:4.6-jdk8-alpine"
            label "docker-agent"
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
    }
}