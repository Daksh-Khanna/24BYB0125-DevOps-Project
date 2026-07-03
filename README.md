# 🚀 Online Portfolio Website - DevOps Pipeline

A complete end-to-end DevOps implementation for deploying and monitoring a static portfolio website using GitHub, Jenkins, Docker, Kubernetes, Nagios, Graphite, Grafana, and Telegraf.

This project was developed as part of the **DevOps Assignment – Use Case 3** at **VIT Vellore**.

---

# 📖 Project Overview

This project demonstrates a complete CI/CD workflow for an online portfolio website.

The implementation includes:

- Source Code Management using GitHub
- Continuous Integration using Jenkins
- Docker Containerization
- Docker Hub Image Repository
- Kubernetes Deployment
- Website Availability Monitoring using Nagios
- Infrastructure Metrics Collection using Telegraf & Graphite
- Dashboard Visualization using Grafana

---

# 🏗️ Architecture

```
                     GitHub
                        │
                        ▼
                   Jenkins CI
                        │
                        ▼
               Docker Image Build
                        │
                        ▼
                  Docker Hub
                        │
                        ▼
                  Kubernetes
                        │
                        ▼
               Portfolio Website
                        │
        ┌───────────────┴───────────────┐
        ▼                               ▼
     Nagios                     Telegraf Agent
(Availability Check)                  │
                                      ▼
                                 Graphite
                                      │
                                      ▼
                                   Grafana
```

---

# 🛠️ Tech Stack

- HTML5
- CSS3
- JavaScript
- Nginx
- Git
- GitHub
- Jenkins
- Docker
- Docker Hub
- Kubernetes (Docker Desktop)
- Nagios
- Graphite
- Grafana
- Telegraf

---

# 📂 Project Structure

```
24BYB0125-DevOps-Project
│
├── src/
│   ├── index.html
│   ├── health.html
│   ├── css/
│   └── js/
│
├── k8s/
│   ├── deployment.yaml
│   └── service.yaml
│
├── monitoring/
│   └── portfolio.cfg
│
├── Dockerfile
├── Jenkinsfile
├── nginx.conf
├── README.md
└── portfolio-dashboard.json
```

---

# ✨ Features

- Static portfolio website hosted using Nginx
- Automated Docker image build
- Docker Hub image repository
- Kubernetes deployment with 3 replicas
- Rolling updates
- Docker Health Check
- Kubernetes Readiness Probe
- Kubernetes Liveness Probe
- Website monitoring using Nagios
- Infrastructure metrics collection using Telegraf
- Metrics storage using Graphite
- Resource utilization dashboards using Grafana

---

# 📋 Prerequisites

Before running the project, install:

- Git
- Docker Desktop (Kubernetes Enabled)
- Jenkins
- kubectl
- Docker Hub Account
- Nagios
- Graphite
- Grafana
- Telegraf

---

# ⚙️ Jenkins Pipeline

The Jenkins pipeline performs the following stages:

1. Validate Project Files
2. Build Docker Image
3. Push Docker Image to Docker Hub

---

# 🐳 Docker

Build the Docker image

```bash
docker build -t dakshkhanna/online-portfolio:latest .
```

Push the image

```bash
docker push dakshkhanna/online-portfolio:latest
```

---

# ☸️ Kubernetes Deployment

Deploy the application

```bash
kubectl apply -f k8s/deployment.yaml
kubectl apply -f k8s/service.yaml
```

Verify Deployment

```bash
kubectl get pods
```

Verify Service

```bash
kubectl get svc
```

Port Forward

```bash
kubectl port-forward service/portfolio-service 8085:80
```

---

# 🌐 Local URLs

| Service | URL |
|---------|-----|
| Portfolio Website | http://localhost:8085 |
| Jenkins | http://localhost:8080 |
| Nagios | http://localhost:8081 |
| Graphite | http://localhost:8082 |
| Grafana | http://localhost:3000 |

---

# 📊 Monitoring

## Nagios

Monitors:

- Host Availability
- HTTP Health Check

Health Endpoint

```
/health.html
```

---

## Graphite

Stores infrastructure metrics collected using Telegraf.

Collected metrics include:

- CPU Usage
- Memory Usage
- Disk Usage
- System Uptime

---

## Grafana

Displays dashboards for:

- CPU Usage
- Memory Usage
- Disk Usage
- System Uptime

---

# 📦 Docker Image

Repository

```
dakshkhanna/online-portfolio
```

Tag

```
latest
```

Docker Hub

https://hub.docker.com/r/dakshkhanna/online-portfolio

---

# 📷 Project Demonstration

The project demonstrates:

- GitHub Repository
- Jenkins CI Pipeline
- Docker Image Creation
- Docker Hub Repository
- Kubernetes Deployment
- Running Portfolio Website
- Nagios Monitoring
- Graphite Metrics Collection
- Grafana Dashboards

---

# 📌 Assignment Mapping

| Requirement | Status |
|-------------|--------|
| GitHub Repository | ✅ |
| Automated Jenkins Pipeline | ✅ |
| Docker Containerization | ✅ |
| Docker Hub Image | ✅ |
| Kubernetes Deployment | ✅ |
| Website Deployment | ✅ |
| Website Availability Monitoring | ✅ |
| Infrastructure Metrics Collection | ✅ |
| Dashboard Visualization | ✅ |

---

# 👨‍💻 Author

**Daksh Khanna**

Registration Number: **24BYB0125**

VIT Vellore

---

# 📄 License

This project was developed for academic purposes as part of the **DevOps Assignment – Use Case 3** at **VIT Vellore**.