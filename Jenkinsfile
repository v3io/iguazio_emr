pipeline {
   agent any
   environment {
    PATH="${PATH}:/home/iguazio/.local/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games:/usr/lib/jvm/java-8-oracle/bin:/usr/lib/jvm/java-8-oracle/db/bin:/usr/lib/jvm/java-8-oracle/jre/bin:/home/iguazio/iguazio/install/ziggy"
   }

   parameters {
    string( defaultValue: "latest", description: 'tag version: igz_0.12.6_b36_20170703185723', name: 'buildTag')
    string( defaultValue: "develop", description: 'kubernetes branch name', name: 'KubernetesBranchName')
   }


   stages {
    stage('Build docker images') {
      steps {
        echo 'Building docker images'
        node('emr68') {
          git branch: 'develop', credentialsId: '242e5e6c-973f-4dd1-b292-b1c63c84d18e', url: 'git@github.com:iguazio/kubernetes.git'
        }
      }
    }
    stage('Run emr cluster') {
      steps {
        node('emr68') {
          echo 'Running EMR cluster tests..'
          echo 'checking if docker exists'
          sh 'docker -v || exit 1'

          echo 'running docker builder'
          sh '/usr/bin/python bin/docker_builder.py --tag latest'

          echo 'Running EMR cluster tests..'
          sh 'bin/run_emr_docker.sh'
          }
        }
      }

      stage('Clean environment') {
        steps {
          node('emr68') {
            deleteDir()
            sh 'ls -lah'
            sh 'env'
          }
        }
      }


    }
}
