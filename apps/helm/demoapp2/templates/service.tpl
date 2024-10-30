{{- range .Values.environments }}
{{- $env := . }}
---
apiVersion: v1
kind: Service
metadata:
  name: demoapp2-{{ $env.rollout }}
  namespace: {{ $env.name }}
  annotations:
  labels:
    app: demoapp2
    env: {{ $env.rollout }}
spec:
  selector:
    app: demoapp2
    env: {{ $env.rollout }}
  ports:
  - name: http
    protocol: TCP
    port: 80
    targetPort: {{ $env.demoapp2.port }}
  - name: https
    protocol: TCP
    port: 443
    targetPort: {{ $env.demoapp2.port }}
  type: NodePort
{{- end }}
