pipeline {
  agent any
  environment {
    ACR_NAME = 'myACR' // reemplazar
    REGISTRY = "${env.ACR_NAME}.azurecr.io"
    IMAGE = "${REGISTRY}/optimized-app:${env.BUILD_NUMBER}"
  }
  stages {
    stage('Checkout') {
      steps { checkout scm }
    }
    stage('Build') {
      steps {
        sh 'docker build -t $IMAGE .'
      }
    }
    stage('Unit Tests') {
      steps {
        sh 'echo "Ejecutando tests unitarios..."'
        sh 'pytest -q || true' // ajustar según el proyecto
      }
      post {
        always { junit 'reports/*.xml' }
      }
    }
    stage('Push ACR') {
      steps {
        withCredentials([usernamePassword(credentialsId: 'ACR_CREDENTIALS', passwordVariable: 'PASS', usernameVariable: 'USER')]) {
          sh '''
            echo $PASS | docker login ${REGISTRY} -u $USER --password-stdin
            docker push $IMAGE
          '''
        }
      }
    }
    stage('Deploy to AKS') {
      steps {
        sh '''
          az aks get-credentials --resource-group myResourceGroup --name myAKS
          kubectl set image deployment/optimized-app optimized-app=${IMAGE} --record
        '''
      }
      steps {
        sh '''
          az aks get-credentials --resource-group myResourceGroup --name myAKS
          kubectl set image deployment/optimized-app optimized-app=${IMAGE} --record
        '''
      }
    }
  }
  post {
    success { echo 'Pipeline finalizado correctamente' }
    failure { 
      echo 'Pipeline failed — executing rollback script'
      sh './scripts/rollback_k8s.sh optimized-app staging || echo "Rollback script reported error"'
      mail to: 'team@example.com', subject: "Build failed: ${env.JOB_NAME} #${env.BUILD_NUMBER}", body: "Revisar Jenkins"
    }
    failure { mail to: 'team@example.com', subject: "Build failed: ${env.JOB_NAME} #${env.BUILD_NUMBER}", body: "Revisar Jenkins" }
  }
}
