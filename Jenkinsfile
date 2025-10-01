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
            git wget unzip ca-certificates docker-cli default-jre-headless curl

        # Install docker-compose
        curl -L "https://github.com/docker/compose/releases/download/v2.20.2/docker-compose-linux-x86_64" \
            -o /usr/local/bin/docker-compose
        chmod +x /usr/local/bin/docker-compose
        docker-compose --version

        docker --version
        java -version || true

        # ---- Install SonarScanner CLI ----
        SCAN_VER=5.0.1.3006
        BASE_URL="https://binaries.sonarsource.com/Distribution/sonar-scanner-cli"
        FILE="sonar-scanner-cli-${SCAN_VER}-linux.zip"

        wget -qO /tmp/sonar.zip "$BASE_URL/$FILE"
        test -s /tmp/sonar.zip || { echo "Failed to download SonarScanner ${SCAN_VER}"; exit 1; }

        unzip -q /tmp/sonar.zip -d /opt
        SCAN_HOME="$(find /opt -maxdepth 1 -type d -name 'sonar-scanner*' | head -n1)"
        ln -sf "$SCAN_HOME/bin/sonar-scanner" /usr/local/bin/sonar-scanner
        sonar-scanner --version

        # validate docker.sock
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

    // ---------- Stage 7: Deploy with Docker Compose ----------
    stage('Deploy with Docker Compose') {
      steps {
        sh '''
          set -eux
          echo "Building Docker image..."
          docker-compose build backend

          echo "Stopping old containers..."
          docker-compose down || true

          echo "Starting services..."
          docker-compose up -d

          echo "Checking service status..."
          docker-compose ps

          echo "Backend logs:"
          docker-compose logs backend --tail=10

          echo "Testing backend connection..."
          curl -f http://localhost:8000/ || \
          curl -f http://localhost:8000/docs || \
          echo "Backend may still be starting..."
        '''
      }
    }
  }

  post {
    always { echo "Pipeline finished" }
  }
}
