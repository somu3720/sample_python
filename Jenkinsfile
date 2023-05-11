pipeline {
  agent any

  environment {
    APP_NAME = "my-python-app"
    APP_VERSION = "2.0.0"
    REMOTE_USER = "azureuser"
    REMOTE_HOST = "20.55.79.184"
    DESTINATION_FOLDER = "/home/azureuser/dest/"
    BACKUP_FOLDER = "/home/azureuser/bkp/"
    ROLLBACK_FOLDER = "/home/azureuser/rlbk/"
    STAGE_NAME = ""
  }

  stages {
    stage('Pre-deployment') {
      steps {
        script {
          sh """
          //  mkdir -p ${DESTINATION_FOLDER} && test -d ${DESTINATION_FOLDER}
          //  cp . ${DESTINATION_FOLDER}
         //   cd ${DESTINATION_FOLDER} && tar -czvf python_files.tar.gz .
	 //   scp ${DESTINATION_FOLDER} ${REMOTE_USER}@${REMOTE_HOST}:${DESTINATION_FOLDER}
	 
	sudo mkdir -p /home/azureuser/dest && test -d /home/azureuser/dest
	sudo cp . /home/azureuser/dest
	sudo tar -czvf dest.tar.gz .
	sudo scp /home/azureuser/dest azureuser@20.55.79.184:/home/azureuser/
	 
	 
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
         //       
         //       ssh ${REMOTE_USER}@${REMOTE_HOST} "
        //          cd ${DESTINATION_FOLDER}
        //          tar -xzvf ./install_python.sh
        //          test -f ${DESTINATION_FOLDER}/requirements.txt &&
        //          pip3 install -r ${DESTINATION_FOLDER}/requirements.txt	
	//    copy dest_folder to bkp folder
	
		 ssh azureuser@20.55.79.184
		 mkdir -p /home/azureuser/bkp
		 cd /home/azureuser/
		 pwd
		 cp dest.tar.gz /home/azureuser/bkp
		 tar -xzvf dest.tar.gz
		 cd dest
		 ./install_python.sh
		 test -f /home/azureuser/dest/requirements.txt
		 pip3 install -r /home/azureuser/dest/requirements.txt
		 
		 	
	
                "
              """
            }
          }
        }
      }
    }
    stage('Rollback') {
      steps {
        script {
          sh """
   //         ssh ${REMOTE_USER}@${REMOTE_HOST} "
   // 	      mv dest to roll
  //          remove dest as well dest.tar.gz
  	
	      ssh azureuser@20.55.79.184
	      mkdir -p /home/azureuser/rlbk/
	      cd /home/azureuser/
	      mv dest.tar.gz /home/azureuser/rlbk
	      rm -rf dest.tar.gz /home/azureuser/dest
	    

            "
          """
        }
      }
    }
  }

/*  post {
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
