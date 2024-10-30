{{- range .Values.environments }}
{{- $env := . }}
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: demoapp2-{{ $env.rollout }}
  namespace: {{ $env.name }}
  labels:
    app: demoapp2
    env: {{ $env.rollout }}
spec:
  replicas: {{ $env.demoapp2.replicas }}
  revisionHistoryLimit: 3
  selector:
    matchLabels:
      app: demoapp2
      env: {{ $env.rollout }}
  template:
    metadata:
      labels:
        app: demoapp2

        env: {{ $env.rollout }}
    spec:
      nodeSelector:
        intent: apps
      serviceAccountName: {{ $env.name }}-sa
      imagePullSecrets:
        - name: {{ $env.name }}-registry
      containers:
        - name: demoapp2
          image: {{ $env.image.repository }}:{{ $env.image.tag }}
          ports:
          - containerPort: {{ $env.demoapp2.port }}
          command:
            - /bin/sh
            - -c
            - /server
          resources:
            requests:
              memory: {{ $env.demoapp2.resourceRequests.memory }}
              cpu: {{ $env.demoapp2.resourceRequests.cpu }}
          envFrom:
          - secretRef:
              name: {{ $env.name }}-vars
{{- end }}
