#!/bin/bash -v
kubectl create namespace monitoring
helm install prometheus-operator stable/prometheus-operator --namespace monitoring