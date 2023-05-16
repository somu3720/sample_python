pipeline {
  agent any

  environment {
    APP_NAME = "my-python-app"
    APP_VERSION = "2.0.0"
    REMOTE_USER = "azureuser"
    REMOTE_HOST = "20.55.79.184"
    DESTINATION_FOLDER = "/test/dest/"
    BACKUP_FOLDER = "/test/bkp/"
    ROLLBACK_FOLDER = "/test/rlbk/"
    STAGE_NAME = ""
  }

  stages {
	  // need ssh2 easy plugin
	 // pre-dep
	 //  mkdir -p ${DESTINATION_FOLDER} && test -d ${DESTINATION_FOLDER}
          //  cp . ${DESTINATION_FOLDER}
         //   cd ${DESTINATION_FOLDER} && tar -czvf python_files.tar.gz .
	 //   scp ${DESTINATION_FOLDER} ${REMOTE_USER}@${REMOTE_HOST}:${DESTINATION_FOLDER}
	  //echo userBPassword | sudo -S -u userB whoami  
	  
	  
	  // dep
	  //       ssh ${REMOTE_USER}@${REMOTE_HOST} "
        //          cd ${DESTINATION_FOLDER}
        //          tar -xzvf ./install_python.sh
        //          test -f ${DESTINATION_FOLDER}/requirements.txt &&
        //          pip3 install -r ${DESTINATION_FOLDER}/requirements.txt	
	//    copy dest_folder to bkp folder
	
	  
	  //rlbk
	  //         ssh ${REMOTE_USER}@${REMOTE_HOST} "
   // 	      mv dest to roll
  //          remove dest as well dest.tar.gz
	  
    stage('Pre-deployment') {
      steps {
        script {
          sh """
	
	whoami
	mkdir -p /test/dest && test -d /test/dest
	zip MQDL.zip *
	cp -r /var/lib/jenkins/workspace/MDQLDEMO/*.zip /test/dest
	scp /test/dest/MQDL.zip deploy_jenkins@40.76.244.235:/destiny
	ssh deploy_jenkins@40.76.244.235 'ls -la /destiny'
	
	 
	 
          """
        }
      }
    }
    stage('Deployment') {
      steps {
        
            script {
              sh """
              	 
         	 ssh deploy_jenkins@40.76.244.235 'whoami'
		 ssh deploy_jenkins@40.76.244.235 'pwd'
		 ssh deploy_jenkins@40.76.244.235 'cd /destiny'
		 ssh deploy_jenkins@40.76.244.235 'cp /destiny/MQDL.zip /bkp'
		 ssh deploy_jenkins@40.76.244.235 'unzip /destiny/MQDL.zip -y'
		 ssh deploy_jenkins@40.76.244.235 'cd /destiny && ./destiny/install_python.sh'
		 ssh deploy_jenkins@40.76.244.235 'test -f /destiny/requirements.txt'
		 ssh deploy_jenkins@40.76.244.235 'pip3 install -r /destiny/requirements.txt'
		 
                
              """
            }

      }
    }
    stage('Rollback') {
      steps {
        script {
          sh """
   
  	
	      ssh azureuser@20.55.79.184
	      sudo mkdir -p /home/azureuser/rlbk/
	      cd /home/azureuser/
	      sudo mv dest.tar.gz /home/azureuser/rlbk
	      sudo rm -rf dest.tar.gz /home/azureuser/dest
	    

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
