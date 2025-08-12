#!/usr/bin/env groovy
// Copyright 2020-2025 Datum Technology Corporation
// All rights reserved.
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

pipeline {
    agent {
      label "linux"
    }

    stages {
        stage('Run Tests') {
            steps {
                sh 'make test'
            }
        }
        stage('Lint') {
            steps {
                sh 'make lint'
            }
        }
        stage('Build Documentation') {
            steps {
                sh 'make docs'
            }
        }
        stage('Archive Docs') {
            steps {
                archiveArtifacts artifacts: 'docs/build/**/*', allowEmptyArchive: true
            }
        }
        stage('Build Package') {
            steps {
                sh 'make build'
            }
        }
    }
    post {
        always {
            junit 'reports/report.xml'
            cobertura autoUpdateHealth: false, autoUpdateStability: false, coberturaReportFile: 'reports/coverage.xml'
        }
    }
}