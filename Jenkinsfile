pipeline{
    agent any
    // tools{
    //     jdk 'jdk17'
    //     nodejs 'node16'
    // }
    environment {
        SCANNER_HOME=tool 'sonar-scanner'
    }
    stages {
        stage('clean workspace'){
            steps{
                cleanWs()
            }
        }
        stage('Checkout from Git'){
            steps{
                git branch: 'main', url: 'https://github.com/rameshkumarvermagithub/NotesTaker.git'
            }
        }
        stage("Sonarqube Analysis "){
            steps{
                withSonarQubeEnv('sonar-server') {
                    sh ''' $SCANNER_HOME/bin/sonar-scanner -Dsonar.projectName=notestaker \
                    -Dsonar.projectKey=notestaker'''
                }
            }
        }
        stage("quality gate"){
           steps {
                script {
                    waitForQualityGate abortPipeline: false, credentialsId: 'sonar'
                }
            }
        }
        // stage('Install Dependencies') {
        //     steps {
        //         sh "npm install"
        //     }
        // }
        stage('OWASP FS SCAN') {
            steps {
                dependencyCheck additionalArguments: '--scan ./ --disableYarnAudit --disableNodeAudit', odcInstallation: 'DP-Check'
                dependencyCheckPublisher pattern: '**/dependency-check-report.xml'
            }
        }
         stage('TRIVY FS SCAN') {
            steps {
                sh "trivy fs . > trivyfs.txt"
            }
        }
        stage("Docker Build & Push"){
            steps{
                script{
                   withDockerRegistry(credentialsId: 'docker', toolName: 'docker'){
                       sh "docker build -t notestaker ."
                       sh "docker tag notestaker rameshkumarverma/notestaker:latest"
                       sh "docker push rameshkumarverma/notestaker:latest"
                    }
                }
            }
        }
        stage("TRIVY"){
            steps{
                sh "trivy image rameshkumarverma/notestaker:latest > trivyimage.txt"
            }
        }
        stage("deploy_docker"){
            steps{
                sh "docker stop notestaker || true"  // Stop the container if it's running, ignore errors
                sh "docker rm notestaker || true" 
                sh "docker run -d --name notestaker -p 3000:3000 -p 8000:8000 rameshkumarverma/notestaker:latest"
            }
        }
      // stage('Deploy to Kubernetes') {
      //       steps {
      //           script {
      //               // dir('K8S') {
      //                   withKubeConfig(caCertificate: '', clusterName: '', contextName: '', credentialsId: 'k8s', namespace: '', restrictKubeConfigAccess: false, serverUrl: '') {
      //                       // Apply deployment and service YAML files
      //                       sh 'kubectl apply -f deployment.yml'
      //                       sh 'kubectl apply -f service.yml'

      //                       // Get the external IP or hostname of the service
      //                       // def externalIP = sh(script: 'kubectl get svc amazon-service -o jsonpath="{.status.loadBalancer.ingress[0].hostname}"', returnStdout: true).trim()

      //                       // Print the URL in the Jenkins build log
      //                       // echo "Service URL: http://${externalIP}/"
      //                   }
      //               // }
      //           }
      //       }
      //   }

    }
}
