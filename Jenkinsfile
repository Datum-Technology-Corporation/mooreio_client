#!/usr/bin/env groovy
// Copyright 2020-2024 Datum Technology Corporation
// All rights reserved.
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
pipeline {
    agent {
      label "linux"
    }

    stages {
        stage('Lint') {
            steps {
                sh 'make lint'
            }
        }
        stage('Run Tests') {
            steps {
                sh 'make test'
            }
        }
        stage('Build Package') {
            steps {
                sh 'make build'
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
    }
    post {
        always {
            junit 'reports/report.xml'
            cobertura autoUpdateHealth: false, autoUpdateStability: false, coberturaReportFile: 'reports/coverage.xml'
        }
    }
}