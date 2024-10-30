{{- range .Values.environments }}
{{- $env := . }}
---
apiVersion: v1
kind: Service
metadata:
  name: demoapp1-api-{{ $env.rollout }}
  namespace: {{ $env.name }}
  annotations:
  labels:
    app: demoapp1-api
    env: {{ $env.name }}
spec:
  selector:
    app: demoapp1-api
    env: {{ $env.name }}
  ports:
  - name: http
    protocol: TCP
    port: 80
    targetPort: {{ $env.demoapp1Api.port }}
  - name: https
    protocol: TCP
    port: 443
    targetPort: {{ $env.demoapp1Api.port }}
  type: NodePort
---
apiVersion: v1
kind: Service
metadata:
  name: demoapp1-flower-{{ $env.rollout }}
  namespace: {{ $env.name }}
  annotations:
  labels:
    app: demoapp1-flower
    env: {{ $env.name }}
spec:
  externalTrafficPolicy: Local
  selector:
    app: demoapp1-flower
    env: {{ $env.name }}
  ports:
  - name: http
    protocol: TCP
    port: 80
    targetPort: {{ $env.demoapp1Flower.port }}
  - name: https
    protocol: TCP
    port: 443
    targetPort: {{ $env.demoapp1Flower.port }}
  type: NodePort
{{- end }}
