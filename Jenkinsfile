private void loadVarsFromFile(String path) {
    def file = readFile(path)
        .replaceAll("(?m)^\\s*\\r?\\n", "")  // skip empty line
        .replaceAll("(?m)^#[^\\n]*\\r?\\n", "")  // skip commented lines
    file.split('\n').each { envLine ->
        def (key, value) = envLine.tokenize('=')
        env."${key}" = "${value.trim().replaceAll('^\"|\"$', '')}"
    }
}

pipeline {
    agent { label '2025-kondraev' }

    stages {
        stage('Prepare TaskBot for Deploy') {
            parallel {
                stage('Build TaskBot') {
                    steps {
                        build(job: 'cherepanov-taskbot-build')
                    }
                }
                stage('Prepare infrastructure for TaskBot') {
                    steps {
                        build(job: 'cherepanov-taskbot-ansible')
                        loadVarsFromFile('/home/jenkins/myenv')
                    }
                }
            }
        }
        stage('Deploy TaskBot') {    
            steps {
                build(job: 'cherepanov-taskbot-deploy', parameters: [string(name: 'SERVER_ADDRESS', value: env.DEV_SERVER_IP)])
            }
        }
    }
}
