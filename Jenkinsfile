pipeline {
  agent any

  environment {
	APP_NAME = "my-python-app"
    APP_VERSION = "2.0.0"
	REMOTE_USER = "username"
	REMOTE_HOST = "ip"
	REMOTE_Pass = "pass"
//  SONARQUBE_URL = "my-sonarqube-instance-url"
//  SONARQUBE_TOKEN = credentials('sonarqube-token')
    SSH_PRIVATE_KEY = credentials('ssh-private-key')
    SSH_KNOWN_HOSTS = sshKnownHosts(['example.com ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC...'])
	Destination = "/path/to/deploy/Destination-$(date+%y%m%d_%H%M%S)"
	Backup = "/path/to/backup/"
	STAGE_NAME = ""
  }

  stages {
  
  stage('Create backup folder') {  
      steps {
	    sh 'mkdir -p $Backup
		sh 'mkdir -p $Destination
        }
      }
    }


stage('SAST') {  
      steps {
        withSonarQubeEnv('sonarqube') {
          script {
            sh "sonar-scanner -Dsonar.projectKey=${APP_NAME} -Dsonar.sources=. -Dsonar.host.url=${SONARQUBE_URL} -Dsonar.login=${SONARQUBE_TOKEN}"
          }
        }
      }
    }
	
	
	stage('pre-deployment') {  
      steps {
        sh 'ssh -o StrictHostKeyChecking=no $REMOTE_USER@REMOTE_HOST exit'          //and need a non root user with 700 permission for destination folder
		sh 'test -d $Destination'  //  check folder already exist
		sh 'cd $Destination && zip -r python_files.zip *.py'
	

        }
      }
    }



    stage('Deploy') {   
      steps {
        retry(3) {
          timeout(time: 10, unit: 'MINUTES') {
            script {
              try {
                sshagent(['ssh-private-key']) {
                  sh '''
					
                    scp -o StrictHostKeyChecking=yes -o UserKnownHostsFile=$SSH_KNOWN_HOSTS . ${SSH_USER}@${SSH_HOST}:${Destination_folder}
					sh 'check weather requirements.txt is present or not in destination folder'
					ssh -o StrictHostKeyChecking=yes -o UserKnownHostsFile=$SSH_KNOWN_HOSTS user@example.com 'pip3 install -r requirements.txt'
					
                  '''
                }
                success("Deployment succeeded!")
              } catch (err) {
                error("Deploy failed with error: ${err}")
				echo "rollback started"
						ssh -o StrictHostKeyChecking=yes -o UserKnownHostsFile=$SSH_KNOWN_HOSTS user@example.com tar czvf ${Destination_folder} ${ROLLBACK_FOLDER} '
						ssh -o StrictHostKeyChecking=yes -o UserKnownHostsFile=$SSH_KNOWN_HOSTS user@example.com tar -xzvf ${BACKUP_FOLDER}  ${Destination_folder}'
				echo 'rollback ended'	

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
    mail to: 'admin@example.com', subject: "Pipeline Failed: ${currentBuild.fullDisplayName}", body: message
    currentBuild.result = 'FAILURE'
    echo message
  }

  def success(message) {
    mail to: 'admin@example.com', subject: "Pipeline Succeeded: ${currentBuild.fullDisplayName}", body: message
    echo message
  }
}

// Exit with status code 0
sh 'exit 0'
