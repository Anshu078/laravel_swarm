def containerName="cargoflare"
def tag="v1.1"
def gitURL="https://github.com/Anshu078/laravel_swarm.git"
node {
    stage('CHECKOUT') {
        checkout([$class: 'GitSCM', branches: [[name: '*/deployment']], extensions: [], userRemoteConfigs: [[credentialsId: 'cargoflare-front-app', url: 'https://github.com/Anshu078/laravel_swarm.git']]])
    }
    stage('IMAGE PRUNE') {
        sh "docker image prune -f"
    }
    stage('IMAGE BUILD'){
        sh "docker build -t $containerName:$tag --pull --no-cache ."
        echo "Image build complete"
    }
    stage('PUSH TO DOCKER REGISTERY'){
        withCredentials([usernamePassword(credentialsId: 'dockerHubAccount', usernameVariable: 'dockerUser', passwordVariable: 'dockerPassword')]) {
            sh "docker login -u $dockerUser -p $dockerPassword"
            sh "docker tag $containerName:$tag $dockerUser/$containerName:$tag"
            sh "docker push $dockerUser/$containerName:$tag"
            echo "Image push complete"
        }
    }
	
	/*stage("SonarQube Scan"){
	     withSonarQubeEnv credentialsId: 'SonarQubeScanner1'){
	        sh"${sonarscanner}/bin/sonar-scanner"
          }
    }*/
	
	stage("DEPLOYMENT"){
        playbook: 'laravel-ansible.yaml'
        sh 'ansible-playbook laravel-ansible.yaml'
    }
}