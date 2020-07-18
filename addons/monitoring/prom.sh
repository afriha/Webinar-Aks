#!/bin/bash -v
kubectl create namespace monitoring
kubectl create namespace projet
helm install prometheus-operator stable/prometheus-operator --namespace monitoring