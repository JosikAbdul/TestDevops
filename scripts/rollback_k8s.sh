#!/usr/bin/env bash
# rollback_k8s.sh - Undo last deployment for a given deployment name and namespace
DEPLOYMENT=${1:-optimized-app}
NAMESPACE=${2:-default}
KUBECTL=${KUBECTL:-kubectl}

if ! command -v $KUBECTL &> /dev/null; then
  echo "kubectl not found in PATH"
  exit 2
fi

echo "Starting rollback for deployment: $DEPLOYMENT in namespace: $NAMESPACE"
# Check rollout status
$KUBECTL rollout status deployment/$DEPLOYMENT -n $NAMESPACE --timeout=60s
if [ $? -ne 0 ]; then
  echo "Current rollout not healthy, attempting rollback..."
  $KUBECTL rollout undo deployment/$DEPLOYMENT -n $NAMESPACE
  if [ $? -eq 0 ]; then
    echo "Rollback initiated successfully."
    $KUBECTL rollout status deployment/$DEPLOYMENT -n $NAMESPACE --timeout=120s
  else
    echo "Rollback command failed. Manual intervention required."
    exit 1
  fi
else
  echo "Current rollout is healthy. No rollback required."
fi
