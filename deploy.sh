#!/usr/bin/env bash

# Exit immediately if a command exits with a non-zero status
set -e

# ==============================================================================
# CONFIGURATION
# ==============================================================================
APP_NAME="user-service-app"                  # Docker image and app name
VERSION="${1:-v1.1}"                     # Takes 1st argument as version, defaults to v1.1
CLUSTER_NAME="cluster-dev"          # Target Kind cluster name
DEPLOYMENT_NAME="user-service-deployment" # Kubernetes deployment name
CONTAINER_NAME="user-service"            # Container name inside the deployment spec

IMAGE_TAG="${APP_NAME}:${VERSION}"
CONTEXT_NAME="kind-${CLUSTER_NAME}"

# ==============================================================================
# DEPLOYMENT PIPELINE
# ==============================================================================
echo "🚀 Starting automated build & deploy pipeline for [${IMAGE_TAG}]..."

# 1. Build the Docker Image
echo "📦 [1/4] Building Docker image: ${IMAGE_TAG}..."
docker build -t "${IMAGE_TAG}" .

# 2. Load the Image into Kind Cluster
echo "🚚 [2/4] Loading image into Kind cluster '${CLUSTER_NAME}'..."
kind load docker-image "${IMAGE_TAG}" --name "${CLUSTER_NAME}"

# 3. Switch Kubectl Context & Update Deployment Image
echo "🔄 [3/4] Switching context to '${CONTEXT_NAME}' and updating image..."
kubectl config use-context "${CONTEXT_NAME}"
kubectl set image deployment/"${DEPLOYMENT_NAME}" "${CONTAINER_NAME}=${IMAGE_TAG}"

# 4. Monitor Rollout Status
echo "⏳ [4/4] Waiting for rollout to complete..."
kubectl rollout status deployment/"${DEPLOYMENT_NAME}"

echo "✅ Successfully deployed ${IMAGE_TAG} to cluster '${CLUSTER_NAME}'!"