// This is a Jenkinsfile for the Roboshop project, which defines the pipeline for building and deploying the application.
// This covers the CI Pipeline.
pipeline {
    agent any

    stages {
        stage('Lint Checks') {
            steps {
                sh "npm run lint"
                sh "lint check completed successfully"
                 }
        }
                stage('Sonar Checks') {
            steps {
                sh "Sonar check completed successfully"
                 }
        }
        stage ('Parallel Stage') {
            parallel {
                stage('Unit Testing') {
            steps {
                sh "Unit Testing completed successfully"
                 }
        }
                stage('Integration Testing') {
            steps {
                sh "Integration Testing completed successfully"
                 }
        }
                stage('Functional Testing') {
            steps {
                sh "Functional Testing completed successfully"
                 }
        } 
      }
   }
        stage('Building the Artefact') {
            steps {
                sh "Building the Artefact completed successfully"
                 }
        }
        stage('Tag the Version') {
            steps {
                sh "Tagging version completed successfully"
                 }
        }
        stage('Check Version availability on Nexus') {
            steps {
                sh "Checking version availability on Nexus completed successfully"
                sh "Version is available on Nexus, then proceed to next stage"
                 }
        }
    }
}