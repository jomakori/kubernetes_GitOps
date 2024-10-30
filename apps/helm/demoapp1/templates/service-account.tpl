{{- range .Values.environments }}
{{- $env := . }}
---
# Applies permissions needed to access ECR repo image
apiVersion: v1
kind: ServiceAccount
metadata:
  name: {{ $env.name }}-sa
  namespace: {{ $env.name }}
  labels:
    app: demoapp1
    env: {{ $env.name }}
  annotations:
    eks.amazonaws.com/role-arn: arn:aws:iam::123456:role/ecr-readonly-access-allrepos
secrets:
  - name: {{ $env.name }}-registry
---
apiVersion: v1
kind: Secret
metadata:
  name: {{ $env.name }}-registry
  namespace: {{ $env.name }}
  labels:
    app: demoapp1
    env: {{ $env.name }}
  annotations:
    eks.amazonaws.com/role-arn: arn:aws:iam::123456:role/ecr-readonly-access-allrepos
{{- end }}
