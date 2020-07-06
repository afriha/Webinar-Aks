---

kind: Service
apiVersion: v1
metadata:
  name: nginx-projet31
  namespace: projet
  annotations:
    service.beta.kubernetes.io/azure-load-balancer-resource-group: ${RG}
spec:
  selector:
    app: nginx
  ports:
    - protocol: "TCP"
      port: 443
      targetPort: 443
  type: LoadBalancer
  loadBalancerIP: ${LoadBalancerIP}
