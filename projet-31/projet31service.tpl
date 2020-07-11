kind: Service
apiVersion: v1
metadata:
  name: projet-31
  namespace: projet
  annotations:
    service.beta.kubernetes.io/azure-load-balancer-resource-group: ${RG}
spec:
  selector:
    app: "projet-31"
  ports:
    - protocol: "TCP"
      port: 5000
      targetPort: 5000
  type: LoadBalancer
  loadBalancerIP: ${LoadBalancerIP}
