pipeline {
    agent {
        label 'Agent-1' //config agent in jenkins after creatin server and add the agent name here
    }
    options{
        //how much time does a snapshot need to run? max time? that we will configure here
        timeout(time: 30, unit: 'MINUTES') //we can give mints, hours, seconds etc.. 
        disableConcurrentBuilds() //Next build will wait for the previous build to get completed.
    }

    stages {
        stage('Init') {
            steps {  //if you awant to write shell script,linux commands in pipeline use """
                sh """ 
                    cd 01-VPC
                    terraform init reconfigure 
                """
            }
        }
        stage('plan') {
            steps {
                sh 'echo This is test'
            }
        }
        stage('Deploy') {
            steps {
                sh 'echo This is deploy'
            }
        }
    }
    post {//we have many posts,below are 3 among them. so posts run after build.used for trigging mails about status etc
        always { 
            echo 'the steps we write here will always run after any build'
        }
        success { 
            echo 'the steps we write here will run after only success build'
        }
        failure { 
            echo 'the steps we write here will run after only failure build'
        }
    }
}