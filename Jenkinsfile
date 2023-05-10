pipeline {
  agent any

  environment {
	APP_NAME = "my-python-app"
    	APP_VERSION = "2.0.0"
	REMOTE_USER = "azureuser"
	REMOTE_HOST = "20.55.79.184"
	REMOTE_PASS = "Jenkins@1234"
//  	SONARQUBE_URL = "my-sonarqube-instance-url"
//  	SONARQUBE_TOKEN = credentials('sonarqube-token')
//    	SSH_PRIVATE_KEY = credentials('ssh-private-key')
//      SSH_KNOWN_HOSTS = sshKnownHosts(['example.com ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC...'])
	  Destination_folder = "/home/azureuser/deploy/Destination-${date+%y%m%d_%H%M%S}"
	Backup_folder = "/home/azureuser/backup/"
	Rollback_folder = "/home/azureuser/rollback/"	  
	STAGE_NAME = ""
  }

  stages {
  
  


/* stage('SAST') {  
      steps {
        withSonarQubeEnv('sonarqube') {
          script {
            sh "sonar-scanner -Dsonar.projectKey=${APP_NAME} -Dsonar.sources=. -Dsonar.host.url=${SONARQUBE_URL} -Dsonar.login=${SONARQUBE_TOKEN}"
          }
        }
      }
    } 
     scp -o StrictHostKeyChecking=yes -o UserKnownHostsFile=$SSH_KNOWN_HOSTS . ${SSH_USER}@${SSH_HOST}:${Destination_folder}
					sh 'check weather requirements.txt is present or not in destination folder'
					ssh -o StrictHostKeyChecking=yes -o UserKnownHostsFile=$SSH_KNOWN_HOSTS user@example.com 'pip3 install -r requirements.txt'
    
    
    */
	
	
	stage('pre-deployment') {  
      steps {
                 //test ssh and need a non root user with 700 permission for destination folder
		                                          //  & check folder already exist
	sh "mkdir -p ${Destination_folder} && test -d ${Destination_folder}"
	sh "cp . ${Destination_folder}"   
        sh "cd ${Destination_folder} && tar -czvf python_files.tar.gz ."
	      

        }
      }
    }



    stage('Deploy') {   
  steps {
    retry(3) {
      timeout(time: 10, unit: 'MINUTES') {
        script {
          try {
            sh '''
              sshpass -p ${REMOTE_PASS} scp -o StrictHostKeyChecking=yes . ${REMOTE_USER}@${REMOTE_HOST}:${Destination_folder} &&
              sshpass -p ${REMOTE_PASS} ssh -o StrictHostKeyChecking=yes ${REMOTE_USER}@${REMOTE_HOST} 
                    "
		      cd .
		      tar -xzvf 
                      ./install_python.sh
                      test -f ${Destination_folder}/requirements.txt &&
                      pip3 install -r ${Destination_folder}/requirements.txt	
                    "
            '''
          }
                success("Deployment succeeded!")
              } catch (err) {
                error("Deploy failed with error: ${err}")
                echo "Rollback started"
                sshpass -p ${REMOTE_PASS} ssh -o StrictHostKeyChecking=yes ${REMOTE_USER}@${REMOTE_HOST} "
                  tar czvf ${Backup_folder}/${Rollback_folder}.tar.gz ${Destination_folder} &&
                  rm -rf ${Destination_folder} &&
                  tar -xzvf ${Backup_folder}/backup-*.tar.gz &&
                  mv ${Rollback_folder} ${Destination_folder}
                "
                echo "Rollback completed"
              }
            }
          }
        }
      }
    }
  }


post {
    failure {
      mail to: 'somu3720@gmail.com', subject: "Pipeline Failed: ${currentBuild.fullDisplayName}", body: "The pipeline has failed at this ${STAGE_NAME} . Please check the logs for more information."
    }
    success {
      mail to: 'somu3720@gmail.com', subject: "Pipeline Succeeded: ${currentBuild.fullDisplayName}", body: "The pipeline has succeeded! The deployment was successful."
    }
  }


  def success(message) {
    currentBuild.result = 'SUCCESS'
    echo 'succeeded in the above step'
  }
}

def error(message) {
    currentBuild.result = 'FAILURE'
    echo 'failed in the above step'
}


// Exit with status code 0
sh 'exit 0'
