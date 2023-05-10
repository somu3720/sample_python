pipeline {
  agent any

  environment {
	APP_NAME = "my-python-app"
    	APP_VERSION = "2.0.0"
	REMOTE_USER = "username"
	REMOTE_HOST = "ip"
	REMOTE_Pass = "pass"
//  	SONARQUBE_URL = "my-sonarqube-instance-url"
//  	SONARQUBE_TOKEN = credentials('sonarqube-token')
//    	SSH_PRIVATE_KEY = credentials('ssh-private-key')
//      SSH_KNOWN_HOSTS = sshKnownHosts(['example.com ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC...'])
	Destination = "/path/to/deploy/Destination-$(date+%y%m%d_%H%M%S)"
	Backup = "/path/to/backup/"
	Rollback = "/path/to/rollback/"	  
	STAGE_NAME = ""
  }

  stages {
  
  stage('Create backup folder') {  
      steps {
	    sh 'mkdir -p $Backup
        }
      }
    }


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
	sh "sshpass -p ${REMOTE_PASS} ssh -o StrictHostKeyChecking=no ${REMOTE_USER}@${REMOTE_HOST} 'mkdir -p ${Destination_folder} && test -d ${Destination_folder}'"
        sh "cd ${Destination_folder} && zip -r python_files.zip *.py"
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
                  tar czvf ${Backup_folder}/${ROLLBACK_FOLDER}.tar.gz ${Destination_folder} &&
                  rm -rf ${Destination_folder} &&
                  tar -xzvf ${Backup_folder}/backup-*.tar.gz &&
                  mv ${ROLLBACK_FOLDER} ${Destination_folder}
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
      mail to: 'admin@example.com', subject: "Pipeline Failed: ${currentBuild.fullDisplayName}", body: "The pipeline has failed at this ${STAGE_NAME} . Please check the logs for more information."
    }
    success {
      mail to: 'admin@example.com', subject: "Pipeline Succeeded: ${currentBuild.fullDisplayName}", body: "The pipeline has succeeded! The deployment was successful."
    }
  }


def error(message) {
    currentBuild.result = 'FAILURE'
    echo message
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
