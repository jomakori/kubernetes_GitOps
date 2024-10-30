{{- range .Values.environments }}
{{- $env := . }}
---
{{/* The doppler token are passed in via Terraform (DevOps repo) & stored in cluster */}}
apiVersion: v1
kind: Secret
metadata:
    name: doppler-token-auth
    namespace: {{ $env.name }}
    annotations:
      argocd.argoproj.io/sync-wave: "-3" {{/* Prioritize - Set up secrets before app deployment */}}
type: Opaque
data:
    dopplerToken: {{ b64enc $env.dopplerToken | quote }}
---
{{/* Provides a way to securely access & manage secrets stored in Doppler within the Kubernetes cluster. */}}
apiVersion: external-secrets.io/v1beta1
kind: SecretStore
metadata:
  name: doppler-token-auth
  namespace: {{ $env.name }}
  annotations:
      argocd.argoproj.io/sync-wave: "-2" {{/* Prioritize - Set up secrets before app deployment */}}
spec:
  provider:
    doppler:
      auth:
        secretRef:
          dopplerToken:
            name: doppler-token-auth
            key: dopplerToken
---
{{/* It allows for dynamic fetching of secrets from Doppler & updates them in real time in the Kubernetes cluster. */}}
apiVersion: external-secrets.io/v1beta1
kind: ExternalSecret
metadata:
  name: demoapp1-vars
  namespace: {{ $env.name }}
  annotations:
      argocd.argoproj.io/sync-wave: "-1" {{/* Prioritize - Set up secrets before app deployment */}}
spec:
  secretStoreRef:
    kind: SecretStore
    name: doppler-token-auth
  refreshInterval: 10s
  target:
    name: {{ $env.name }}-vars
  dataFrom:
    - find:
        name:
          regexp: .*
{{- end }}
