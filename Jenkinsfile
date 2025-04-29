private void loadVarsFromFile(String path) {
    // Читаем содержимое файла в одну строку
    def file = readFile(path)
        // Удаляем пустые строки (в том числе строки с пробелами)
        .replaceAll("(?m)^\\s*\\r?\\n", "")  
        // Удаляем строки-комментарии (начинаются с символа #)
        .replaceAll("(?m)^#[^\\n]*\\r?\\n", "")  

    // Разбиваем оставшийся текст на строки по символу новой строки
    file.split('\n').each { envLine ->
        // Разделяем строку на ключ и значение по знаку равенства
        def (key, value) = envLine.tokenize('=')
        // Удаляем кавычки по краям значения и сохраняем в переменные окружения
        env."${key}" = "${value.trim().replaceAll('^\"|\"$', '')}"
    }
}

pipeline {
    agent { label '2025-cherepanov' }

    stages {
        stage('Prepare Bot for Deploy') {
            parallel {
                stage('Build Bot') {
                    steps {
                        build(job: 'cherepanov-taskbot-yandex')
                    }
                }
                stage('Prepare infrastructure for Bot') {
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
