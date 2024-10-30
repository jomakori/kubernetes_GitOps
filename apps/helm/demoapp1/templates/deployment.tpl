{{- range .Values.environments }}
# Staging + Production Deployments
{{- $env := . }}
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: {{ $env.name }}-api
  namespace: {{ $env.name }}
  labels:
    app: demoapp1-api
    rev: {{ $env.image.tag }}
    env: {{ $env.name }}
spec:
  replicas: {{ $env.demoapp1Api.replicas }}
  revisionHistoryLimit: 3
  selector:
    matchLabels:
      app: demoapp1-api
      env: {{ $env.name }}
  template:
    metadata:
      labels:
        app: demoapp1-api
        env: {{ $env.name }}
    spec:
      nodeSelector:
        intent: apps
      serviceAccountName: {{ $env.name }}-sa
      imagePullSecrets:
        - name: {{ $env.name }}-registry
      initContainers:
        - name: py-migrate
          image: {{ $env.image.repository }}:{{ $env.image.tag }}
          imagePullPolicy: Always
          command:
            - python
            - manage.py
            - migrate
          envFrom:
            - secretRef:
                name: {{ $env.name }}-vars
      containers:
        - name: demoapp1-api
          ports:
          - containerPort: {{ $env.demoapp1Api.port }}
          image: {{ $env.image.repository }}:{{ $env.image.tag }}
          imagePullPolicy: Always
          command:
            - /bin/sh
            - -c
            - /start
          env:
          - name: DD_AGENT_HOST
            valueFrom:
              fieldRef:
                fieldPath: status.hostIP
          resources:
            requests:
              memory: {{ $env.demoapp1Api.resourceRequests.memory }}
              cpu: {{ $env.demoapp1Api.resourceRequests.cpu }}
          envFrom:
          - secretRef:
              name: {{ $env.name }}-vars
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: {{ $env.name }}-flower
  namespace: {{ $env.name }}
  labels:
    app: demoapp1-flower
    rev: {{ $env.image.tag }}
    env: {{ $env.name }}
spec:
  replicas: {{ $env.demoapp1Flower.replicas }}
  revisionHistoryLimit: 3
  selector:
    matchLabels:
      app: demoapp1-flower
      env: {{ $env.name }}
  template:
    metadata:
      labels:
        app: demoapp1-flower
        env: {{ $env.name }}
    spec:
      nodeSelector:
        intent: apps
      serviceAccountName: {{ $env.name }}-sa
      imagePullSecrets:
        - name: {{ $env.name }}-registry
      containers:
        - name: demoapp1-flower
          ports:
          - containerPort: {{ $env.demoapp1Flower.port }}
          image: {{ $env.image.repository }}:{{ $env.image.tag }}
          imagePullPolicy: Always
          command:
            - /bin/sh
            - -c
            - /start-flower
          resources:
            requests:
              memory: {{ $env.demoapp1Flower.resourceRequests.memory }}
              cpu: {{ $env.demoapp1Flower.resourceRequests.cpu }}
          envFrom:
          - secretRef:
              name: {{ $env.name }}-vars
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: {{ $env.name }}-celeryworker
  namespace: {{ $env.name }}
  labels:
    app: demoapp1-celeryworker
    rev: {{ $env.image.tag }}
    env: {{ $env.name }}
spec:
  replicas: {{ $env.demoapp1CeleryWorker.replicas }}
  revisionHistoryLimit: 3
  selector:
    matchLabels:
      app: demoapp1-celeryworker
      env: {{ $env.name }}
  template:
    metadata:
      labels:
        app: demoapp1-celeryworker
        env: {{ $env.name }}
    spec:
      nodeSelector:
        intent: apps
      serviceAccountName: {{ $env.name }}-sa
      imagePullSecrets:
        - name: {{ $env.name }}-registry
      containers:
        - name: demoapp1-celeryworker
          image: {{ $env.image.repository }}:{{ $env.image.tag }}
          imagePullPolicy: Always
          command:
            - /bin/sh
            - -c
            - /start-celeryworker
          resources:
            requests:
              memory: {{ $env.demoapp1CeleryWorker.resourceRequests.memory }}
              cpu: {{ $env.demoapp1CeleryWorker.resourceRequests.cpu }}
          envFrom:
          - secretRef:
              name: {{ $env.name }}-vars
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: {{ $env.name }}-celeryworker-heavy
  namespace: {{ $env.name }}
  labels:
    app: demoapp1-celeryworker-heavy
    rev: {{ $env.image.tag }}
    env: {{ $env.name }}
spec:
  replicas: {{ $env.demoapp1CeleryWorkerHeavy.replicas }}
  revisionHistoryLimit: 3
  selector:
    matchLabels:
      app: demoapp1-celeryworker-heavy
      env: {{ $env.name }}
  template:
    metadata:
      labels:
        app: demoapp1-celeryworker-heavy
        env: {{ $env.name }}
    spec:
      nodeSelector:
        intent: apps
      serviceAccountName: {{ $env.name }}-sa
      imagePullSecrets:
        - name: {{ $env.name }}-registry
      containers:
        - name: demoapp1-celeryworker-heavy
          image: {{ $env.image.repository }}:{{ $env.image.tag }}
          imagePullPolicy: Always
          command:
            - /bin/sh
            - -c
            - /start-celeryworker -xq heavy
          resources:
            requests:
              memory: {{ $env.demoapp1CeleryWorkerHeavy.resourceRequests.memory }}
              cpu: {{ $env.demoapp1CeleryWorkerHeavy.resourceRequests.cpu }}
          envFrom:
          - secretRef:
              name: {{ $env.name }}-vars
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: {{ $env.name }}-celeryworker-high
  namespace: {{ $env.name }}
  labels:
    app: demoapp1-celeryworker-high
    rev: {{ $env.image.tag }}
    env: {{ $env.name }}
spec:
  replicas: {{ $env.demoapp1CeleryWorkerHigh.replicas }}
  revisionHistoryLimit: 3
  selector:
    matchLabels:
      app: demoapp1-celeryworker-high
      env: {{ $env.name }}
  template:
    metadata:
      labels:
        app: demoapp1-celeryworker-high
        env: {{ $env.name }}
    spec:
      nodeSelector:
        intent: apps
      serviceAccountName: {{ $env.name }}-sa
      imagePullSecrets:
        - name: {{ $env.name }}-registry
      containers:
        - name: demoapp1-celeryworker-high
          image: {{ $env.image.repository }}:{{ $env.image.tag }}
          imagePullPolicy: Always
          command:
            - /bin/sh
            - -c
            - /start-celeryworker -q priority.high
          resources:
            requests:
              memory: {{ $env.demoapp1CeleryWorkerHigh.resourceRequests.memory }}
              cpu: {{ $env.demoapp1CeleryWorkerHigh.resourceRequests.cpu }}
          envFrom:
          - secretRef:
              name: {{ $env.name }}-vars
# Production-only Deployment
{{- if eq $env.name "demoapp1-prod" }}
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: {{ $env.name }}-celerybeat
  namespace: {{ $env.name }}
  labels:
    app: demoapp1-celerybeat
    rev: {{ $env.image.tag }}
    env: {{ $env.name }}
spec:
  replicas: {{ $env.demoapp1CeleryBeat.replicas }}
  revisionHistoryLimit: 3
  selector:
    matchLabels:
      app: demoapp1-celerybeat
      env: {{ $env.name }}
  template:
    metadata:
      labels:
        app: demoapp1-celerybeat
        env: {{ $env.name }}
    spec:
      nodeSelector:
        intent: apps
      serviceAccountName: {{ $env.name }}-sa
      imagePullSecrets:
        - name: {{ $env.name }}-registry
      containers:
        - name: demoapp1-celerybeat
          image: {{ $env.image.repository }}:{{ $env.image.tag }}
          imagePullPolicy: Always
          command:
            - /bin/sh
            - -c
            - /start-celerybeat
          resources:
            requests:
              memory: {{ $env.demoapp1CeleryBeat.resourceRequests.memory }}
              cpu: {{ $env.demoapp1CeleryBeat.resourceRequests.cpu }}
          envFrom:
          - secretRef:
              name: {{ $env.name }}-vars
{{- end }}
{{- end }}
