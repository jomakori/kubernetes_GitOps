{{- range .Values.environments }}
{{- $env := . }}
---
apiVersion: autoscaling/v2
kind: HorizontalPodAutoscaler
metadata:
  name: {{ $env.name }}-hpa
  namespace: {{ $env.name }}
spec:
  scaleTargetRef:
    apiVersion: apps/v1
    kind: Deployment
    name: demoapp2-{{ $env.rollout }}
  minReplicas: 1
  maxReplicas: 10
  metrics:
  - type: Resource
    resource:
      name: cpu
      target:
        type: Utilization
        averageUtilization: 67
  - type: Resource
    resource:
      name: memory
      target:
        type: Utilization
        averageUtilization: 67
{{- end }}
