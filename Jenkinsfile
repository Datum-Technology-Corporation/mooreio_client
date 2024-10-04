#!/usr/bin/env groovy
// Copyright 2020-2024 Datum Technology Corporation
// All rights reserved.
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
pipeline {
    agent {
      label "linux"
    }

    stages {
        stage('Setup Virtual Environment') {
            steps {
                sh 'make venv'
            }
        }
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
                archiveArtifacts artifacts: 'docs/_build/html/**/*', allowEmptyArchive: true
            }
        }
    }
    post {
        always {
            junit 'reports/*.xml'
            cobertura autoUpdateHealth: false, autoUpdateStability: false, coberturaReportFile: 'reports/coverage.xml'
        }
    }
}