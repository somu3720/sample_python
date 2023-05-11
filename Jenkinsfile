pipeline {
  agent any

  environment {
    APP_NAME = "my-python-app"
    APP_VERSION = "2.0.0"
    REMOTE_USER = "azureuser"
    REMOTE_HOST = "20.55.79.184"
    DESTINATION_FOLDER = "/home/azureuser/deploy/Destination"
    BACKUP_FOLDER = "/home/azureuser/backup/"
    ROLLBACK_FOLDER = "/home/azureuser/rollback/"
    STAGE_NAME = ""
  }

  stages {
    stage('Pre-deployment') {
      steps {
        script {
          sh """
            mkdir -p ${DESTINATION_FOLDER} && test -d ${DESTINATION_FOLDER}
            cp . ${DESTINATION_FOLDER}
            cd ${DESTINATION_FOLDER} && tar -czvf python_files.tar.gz .
          """
        }
      }
    }
    stage('Deployment') {
      steps {
        retry(3) {
          timeout(time: 10, unit: 'MINUTES') {
            script {
              sh """
                scp ${DESTINATION_FOLDER} ${REMOTE_USER}@${REMOTE_HOST}:${DESTINATION_FOLDER}
                ssh ${REMOTE_USER}@${REMOTE_HOST} "
                  cd ${DESTINATION_FOLDER}
                  tar -xzvf ./install_python.sh
                  test -f ${DESTINATION_FOLDER}/requirements.txt &&
                  pip3 install -r ${DESTINATION_FOLDER}/requirements.txt	
                "
              """
            }
          }
        }
      }
    }
  }

 */ post {
    failure {
      script {
        STAGE_NAME = env.STAGE_NAME ?: "unknown stage"
        mail to: 'somu3720@gmail.com', subject: "Pipeline Failed: ${currentBuild.fullDisplayName}", body: "The pipeline has failed at stage '${STAGE_NAME}'. Please check the logs for more information."
      }
    }
    success {
      mail to: 'somu3720@gmail.com', subject: "Pipeline Succeeded: ${currentBuild.fullDisplayName}", body: "The pipeline has succeeded! The deployment was successful."
    }
  } */
}
