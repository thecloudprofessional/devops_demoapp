pipeline {
  agent any
  
  environment {
    BACKEND_PROJECT_NAME="node-devops_demoapp_backend"
  }

  stages {
    stage('Prebuild') {
      steps {
        withAWS(credentials: 'devops_jenkins') {
          sh label: 'TerraformInit', script: 'terraform -chdir=./terraform/prebuild init' 
          sh label: 'CreateECRRepository', script: 'terraform -chdir=./ci/prebuild apply --auto-approve -var backend_project_name=${BACKEND_PROJECT_NAME}'
        }
      }
    }
    stage('Build') {
      steps {
        withAWS(credentials: 'devops_jenkins', region: 'ca-central-1') {
          script {
            def accountId = sh(script: "aws sts get-caller-identity | grep \"Account\" | sed 's/\"Account\": \"\\(.*\\)\",/\\1/'", returnStdout: true).trim()
            sh "docker build ./backend -t ${BACKEND_PROJECT_NAME}"
            sh "aws ecr get-login-password | docker login --username AWS --password-stdin ${accountId}.dkr.ecr.ca-central-1.amazonaws.com"
            sh "docker tag ${BACKEND_PROJECT_NAME}:latest ${accountId}.dkr.ecr.ca-central-1.amazonaws.com/${BACKEND_PROJECT_NAME}:latest"
            sh "docker push ${accountId}.dkr.ecr.ca-central-1.amazonaws.com/${BACKEND_PROJECT_NAME}:latest"
          }
        }
      }
    }
    stage('Destroy') {
      input{
        message "Do you want to destroy the application?"
      }
      steps {
        withAWS(credentials: 'devops_jenkins') {
          sh label: 'DeleteECRRepository', script: 'terraform -chdir=./ci/prebuild destroy --auto-approve -var backend_project_name=${BACKEND_PROJECT_NAME}'
        }
      }
    }
  }
}