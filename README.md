# hello-pipeline-k8s

Repositorio com arquivos da pipeline tekton do projeto Hello-app.

Este laboratório considera que já exista instalado:

1. Cluster k8s (Por aqui, minikube) 2. Kubectl
   3.Tekton

Para fins de execução:

1. Criaçao do namespace
   kubectl create namespace hello-dev

2. Instalar pvc
   kubectl apply -f 06-pvc.yaml

3. Instalar a task git clone
   Ver mais em: https://hub.tekton.dev/

   kubectl apply -f https://api.hub.tekton.dev/v1/resource/tekton/task/git-clone/0.9/raw -n <namespace>

4. Instalar demais tasks customizadas
   kubectl apply -f 01-buildah-customized.yaml
   kubectl apply -f 02-git-commit-manifest.yaml
   kubectl apply -f 03-kustomize-update-manifest.yaml
5. Instalar a pipeline
   kubectl apply -f 04-pipeline.yaml

Criar secret do docker hub
Por questões de segurança não podemos versionar o secret no repo, mas vou deixar texto do yaml:

apiVersion: v1
kind: Secret
metadata:
name: dockerhub-secret
annotations:
tekton.dev/docker-0: https://index.docker.io/v1/
type: kubernetes.io/basic-auth
stringData:
username: <seu usuario docker hub>
password: <seu token que deve ser criado la no docker hub>

Criar secret do github
Criar serviceaccount com os secrets associado e referenciar no pipelinerun
kubectl apply -f 07-serviceaccount.yaml

6. Criar o pipelinerun
   kubectl create -f 05-run.yaml
