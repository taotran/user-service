pipeline {
    agent any

    environment {
        APP_NAME        = 'user-service'
        CLUSTER_NAME    = 'dev-cluster'
        DEPLOYMENT_NAME = 'user-service-deployment'
        CONTAINER_NAME  = 'user-service'
        // Tag image with git commit hash or build number for traceability
        IMAGE_TAG       = "${APP_NAME}:${BUILD_NUMBER}"
        KUBECONFIG      = '/root/.kube/config'
    }

    options {
        timeout(time: 15, unit: 'MINUTES')
        disableConcurrentBuilds()
        buildDiscarder(logRotator(numToKeepStr: '10'))
    }

    stages {
        stage('1. Code Quality & Test') {
            steps {
                echo "🧪 Running Unit Tests..."
                // sh './gradlew test' or 'mvn test'
            }
        }

        stage('2. Build App & Docker Image') {
            steps {
                echo "📦 Building Docker Image: ${IMAGE_TAG}..."
                sh "docker build -t ${IMAGE_TAG} ."
            }
        }

        stage('3. Load Image to Kind') {
            steps {
                echo "🚚 Loading ${IMAGE_TAG} into Kind cluster '${CLUSTER_NAME}'..."
                // Load local image directly into the Kind cluster nodes
                sh "kind load docker-image ${IMAGE_TAG} --name ${CLUSTER_NAME}"
            }
        }

        stage('4. Deploy to dev-cluster') {
            steps {
                echo "🚀 Performing Rolling Update on ${DEPLOYMENT_NAME}..."
                sh """
                    # Switch context to target dev-cluster
                    kubectl config use-context kind-${CLUSTER_NAME}

                    # Update deployment image
                    kubectl set image deployment/${DEPLOYMENT_NAME} ${CONTAINER_NAME}=${IMAGE_TAG}
                """
            }
        }

        stage('5. Verify Rollout & Health') {
            steps {
                echo "⏳ Verifying deployment health..."
                sh """
                    # Block until new pods pass readiness probes
                    kubectl rollout status deployment/${DEPLOYMENT_NAME} --timeout=90s
                """
            }
        }
    }

    post {
        success {
            echo "✅ Build #${BUILD_NUMBER} successfully deployed to ${CLUSTER_NAME}!"
        }
        failure {
            echo "❌ Deployment failed! Check logs below:"
            sh "kubectl get pods -l app=${APP_NAME}"
        }
    }
}
