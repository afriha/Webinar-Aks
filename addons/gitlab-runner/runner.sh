#!/bin/bash -v
kubectl create namespace gitlab-runner
kubectl create clusterrolebinding gitlab-runner --clusterrole=cluster-admin --serviceaccount=gitlab-runner:default
helm install gitlab-runner -f /home/afriha/Aks/addons/gitlab-runner/values.yaml gitlab/gitlab-runner --namespace gitlab-runner