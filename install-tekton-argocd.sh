#!/bin/bash

set -e  # Para o script se algum comando falhar

# Verifica se o kubectl está configurado
if ! kubectl cluster-info > /dev/null 2>&1; then
  echo "❌ Kubeconfig não está configurado. Configure e tente novamente."
  exit 1
fi

# Instala Tekton Pipelines
echo "🚀 Instalando Tekton Pipelines..."
kubectl apply --filename https://storage.googleapis.com/tekton-releases/pipeline/latest/release.yaml

# Instala Tekton Triggers
echo "🚀 Instalando Tekton Triggers..."
kubectl apply --filename https://storage.googleapis.com/tekton-releases/triggers/latest/release.yaml

# Instala Tekton Dashboard (opcional)
echo "🚀 Instalando Tekton Dashboard..."
kubectl apply --filename https://storage.googleapis.com/tekton-releases/dashboard/latest/release.yaml


echo "🚀 Instalando Tekton Interceptors..."
kubectl apply -f https://storage.googleapis.com/tekton-releases/triggers/latest/interceptors.yaml

# Cria namespace do ArgoCD
echo "🚀 Criando namespace argocd..."
kubectl create namespace argocd || true

# Instala o ArgoCD
echo "🚀 Instalando ArgoCD..."
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml




# Instala ArgoCD via Helm
# echo "🚀 Instalando ArgoCD..."
# helm repo add argo https://argoproj.github.io/argo-helm
# helm repo update
# helm install argocd argo/argo-cd --namespace argocd --set server.service.type=LoadBalancer

# Exibe status da instalação
echo "✅ Instalação concluída!"
echo "🔍 Para acessar o ArgoCD, pegue a senha com:"
echo "kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath='{.data.password}' | base64 -d && echo"
