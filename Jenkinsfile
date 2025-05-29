pipeline {
    agent any

    environment {
        DOCKER_IMAGE = 'expense-tracker-app'
    }

    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Build Docker Image') {
            steps {
                echo '🐳 Building Docker image...'
                sh 'docker build -t $DOCKER_IMAGE .'
            }
        }

        stage('Debug Container Contents') {
            steps {
                echo '🧰 Checking what is inside the Docker container workspace...'
                sh 'docker run --rm -v "$WORKSPACE:/app" -w /app $DOCKER_IMAGE ls -al'
                sh 'docker run --rm -v "$WORKSPACE:/app" -w /app $DOCKER_IMAGE ls -al app || echo "❌ app folder missing"'
                sh 'docker run --rm -v "$WORKSPACE:/app" -w /app $DOCKER_IMAGE ls -al tests || echo "❌ tests folder missing"'
            }
        }

        stage('Run Tests') {
            steps {
                echo '🧪 Running Pytest...'
                sh '''
                    docker run --rm -v "$WORKSPACE:/app" -w /app $DOCKER_IMAGE \
                    bash -c "pytest tests > test-report.txt || true"
                '''
            }
        }

        stage('Lint Code') {
            steps {
                echo '🔍 Running Pylint...'
                sh '''
                    docker run --rm -v "$WORKSPACE:/app" -w /app $DOCKER_IMAGE \
                    bash -c "pip install pylint && pylint app > pylint-report.txt || true"
                '''
            }
        }

        stage('Security Scan') {
            steps {
                echo '🔒 Running Bandit...'
                sh '''
                    docker run --rm -v "$WORKSPACE:/app" -w /app $DOCKER_IMAGE \
                    bash -c "pip install bandit && bandit -r app > bandit-report.txt || true"
                '''
            }
        }

        stage('Verify Reports') {
            steps {
                echo '📂 Verifying generated reports...'
                sh 'ls -al $WORKSPACE'
                sh 'cat test-report.txt || echo "❌ test-report.txt not found"'
                sh 'cat pylint-report.txt || echo "❌ pylint-report.txt not found"'
                sh 'cat bandit-report.txt || echo "❌ bandit-report.txt not found"'
            }
        }

        stage('Deploy') {
            steps {
                echo '🚀 Deploying (stub)...'
            }
        }
    }

    post {
        always {
            echo '📦 Archiving reports...'
            archiveArtifacts artifacts: '*.txt', allowEmptyArchive: true
        }
    }
}
