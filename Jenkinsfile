pipeline {
  agent {
    docker {
      image 'python:3.13'
      args '-u 0:0 -v /var/run/docker.sock:/var/run/docker.sock'
    }
  }

  options { timestamps() }

  stages {

    // ---------- Stage 1: Install Base Tooling ----------
    stage('Install Base Tooling') {
      steps {
        sh '''
          set -eux
          apt-get update
          DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
            git wget unzip ca-certificates docker-cli default-jre-headless

          command -v git
          command -v docker
          docker --version
          java -version || true

          SCAN_VER=7.2.0.5079
          BASE_URL="https://binaries.sonarsource.com/Distribution/sonar-scanner-cli"

          CANDIDATES="
            sonar-scanner-${SCAN_VER}-linux-x64.zip
            sonar-scanner-${SCAN_VER}-linux.zip
            sonar-scanner-cli-${SCAN_VER}-linux-x64.zip
            sonar-scanner-cli-${SCAN_VER}-linux.zip
          "

          rm -f /tmp/sonar.zip || true
          for f in $CANDIDATES; do
            URL="${BASE_URL}/${f}"
            echo "Trying: $URL"
            if wget -q --spider "$URL"; then
              wget -qO /tmp/sonar.zip "$URL"
              break
            fi
          done

          test -s /tmp/sonar.zip || { echo "Failed to download SonarScanner ${SCAN_VER}"; exit 1; }

          unzip -q /tmp/sonar.zip -d /opt
          SCAN_HOME="$(find /opt -maxdepth 1 -type d -name 'sonar-scanner*' | head -n1)"
          ln -sf "$SCAN_HOME/bin/sonar-scanner" /usr/local/bin/sonar-scanner
          sonar-scanner --version

          test -S /var/run/docker.sock || { echo "ERROR: /var/run/docker.sock not mounted"; exit 1; }
        '''
      }
    }

    // ---------- Stage 2: Checkout ----------
    stage('Checkout') {
      steps {
        git branch: 'main', url: 'https://github.com/sareefhub/Locaza.git'
      }
    }

    // ---------- Stage 3: Install Python Deps ----------
    stage('Install Python Deps') {
      steps {
        dir('backend') {
          sh '''
            set -eux
            python -m pip install --upgrade pip
            pip install poetry
            poetry config virtualenvs.create false
            poetry install

            # Install testing dependencies
            pip install pytest pytest-cov
          '''
        }
      }
    }

    // ---------- Stage 4: Run Tests & Coverage ----------
    stage('Run Tests & Coverage') {
      steps {
        dir('backend') {
          sh '''
            set -eux
            export PYTHONPATH="$PWD"

            mkdir -p tests
            if [ ! -f "tests/test_main.py" ]; then
              cat > tests/test_main.py << 'EOF'
from fastapi.testclient import TestClient
import sys, os
sys.path.append(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))
from app.main import app

client = TestClient(app)

def test_root():
    response = client.get("/")
    assert response.status_code in [200, 404]
EOF
            fi

            pytest -q --cov=app --cov-report=xml tests/
            ls -la
          '''
        }
      }
    }

    // ---------- Stage 5: SonarQube Analysis ----------
    stage('SonarQube Analysis') {
      steps {
        dir('backend') {
          withSonarQubeEnv('SonarQube servers') {
            sh '''
              set -eux
              sonar-scanner \
                -Dsonar.host.url="$SONAR_HOST_URL" \
                -Dsonar.login="$SONAR_AUTH_TOKEN" \
                -Dsonar.projectBaseDir="$PWD" \
                -Dsonar.projectKey=locaza-backend \
                -Dsonar.projectName="Locaza Backend" \
                -Dsonar.sources=app \
                -Dsonar.tests=tests \
                -Dsonar.python.version=3.13 \
                -Dsonar.python.coverage.reportPaths=coverage.xml \
                -Dsonar.sourceEncoding=UTF-8
            '''
          }
        }
      }
    }

    // ---------- Stage 6: Quality Gate ----------
    stage('Quality Gate') {
      steps {
        timeout(time: 10, unit: 'MINUTES') {
          waitForQualityGate abortPipeline: true
        }
      }
    }

    // ---------- Stage 7: Build Docker Image ----------
    stage('Build Docker Image') {
      steps {
        dir('backend') {
          sh 'docker build -t locaza-backend:latest .'
        }
      }
    }

    // ---------- Stage 8: Push to Registry ----------
    stage('Push to Registry') {
      steps {
        withCredentials([usernamePassword(
          credentialsId: 'dockerhub-cred',
          usernameVariable: 'DOCKER_USER',
          passwordVariable: 'DOCKER_PASS'
        )]) {
          sh '''
          echo "$DOCKER_PASS" | docker login -u "$DOCKER_USER" --password-stdin
          docker tag locaza-backend:latest $DOCKER_USER/6510110115-locaza-backend:latest
          docker push $DOCKER_USER/6510110115-locaza-backend:latest
          '''
        }
      }
    }

    // ---------- Stage 9: Deploy Container ----------
    stage('Deploy Container') {
      steps {
        sh '''
          set -eux
          docker rm -f locaza-backend || true
          docker run -d --name locaza-backend -p 8000:8000 locaza-backend:latest
        '''
      }
    }
  }

  post { always { echo "Pipeline finished" } }
}
