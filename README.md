# 🚀 Online Portfolio Website - DevOps CI/CD Pipeline

![Docker](https://img.shields.io/badge/Docker-Containerized-2496ED?logo=docker&logoColor=white)
![Kubernetes](https://img.shields.io/badge/Kubernetes-Deployed-326CE5?logo=kubernetes&logoColor=white)
![Jenkins](https://img.shields.io/badge/Jenkins-CI%2FCD-D24939?logo=jenkins&logoColor=white)
![Nagios](https://img.shields.io/badge/Nagios-Monitoring-000000)
![Graphite](https://img.shields.io/badge/Graphite-Metrics-5C2D91)
![Grafana](https://img.shields.io/badge/Grafana-Dashboard-F46800?logo=grafana&logoColor=white)

A complete end-to-end DevOps implementation for deploying and monitoring a static portfolio website using GitHub, Jenkins, Docker, Kubernetes, Nagios, Telegraf, Graphite, and Grafana.

This project was developed as part of **DevOps Assignment 2 – Use Case 3** at **VIT Vellore**.

---

# 📖 Project Overview

This project demonstrates a complete DevOps workflow for an online portfolio website.

The implementation includes:

- Version Control using GitHub
- Continuous Integration using Jenkins
- Docker Containerization
- Docker Hub Image Repository
- Kubernetes Deployment
- Website Availability Monitoring using Nagios
- Infrastructure Metrics Collection using Telegraf
- Metrics Storage using Graphite
- Dashboard Visualization using Grafana

---

# 🏗️ System Architecture

```text
                    GitHub
                       │
                       ▼
                Jenkins Pipeline
                       │
                       ▼
               Docker Image Build
                       │
                       ▼
                  Docker Hub
                       │
                       ▼
              Kubernetes Cluster
                       │
                       ▼
             Online Portfolio Website
                       │
        ┌──────────────┴──────────────┐
        ▼                             ▼
    Nagios                     Telegraf
(Availability Check)                │
                                    ▼
                               Graphite
                                    │
                                    ▼
                                 Grafana
```

---

# 🛠️ Technologies Used

| Category | Technology |
|----------|------------|
| Version Control | Git, GitHub |
| CI/CD | Jenkins |
| Containerization | Docker |
| Container Registry | Docker Hub |
| Web Server | Nginx |
| Orchestration | Kubernetes |
| Monitoring | Nagios |
| Metrics Collection | Telegraf |
| Metrics Storage | Graphite |
| Visualization | Grafana |
| Frontend | HTML, CSS, JavaScript |

---

# 📁 Project Structure

```text
24BYB0125-DevOps-Project
│
├── k8s/
│   ├── deployment.yaml
│   └── service.yaml
│
├── monitoring/
│   └── nagios/
│       └── portfolio.cfg
│
├── src/
│   ├── css/
│   │   └── style.css
│   │
│   ├── images/
│   │
│   ├── js/
│   │   └── main.js
│   │
│   ├── health.html
│   └── index.html
│
├── Dockerfile
├── Jenkinsfile
├── nginx.conf
├── README.md
└── .gitignore
```

---

# ✨ Features

- Static portfolio website hosted using Nginx
- Automated Docker image build using Jenkins
- Docker Hub image repository
- Kubernetes deployment with 3 replicas
- Rolling Updates
- Docker Health Check
- Kubernetes Readiness Probe
- Kubernetes Liveness Probe
- Website monitoring using Nagios
- Infrastructure metrics collection using Telegraf
- Metrics storage using Graphite
- Resource visualization using Grafana

---

# 📋 Prerequisites

Install the following before running the project:

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

The Jenkins pipeline performs:

- Validate project files
- Build Docker image
- Push Docker image to Docker Hub

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

# ☸️ Kubernetes

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

# ❤️ Health Monitoring

The application exposes a health endpoint used by:

- Docker HEALTHCHECK
- Kubernetes Readiness Probe
- Kubernetes Liveness Probe
- Nagios HTTP Monitoring

Health Endpoint

```
/health.html
```

---

# 📊 Monitoring Stack

## Nagios

Monitors:

- Host Availability
- Website HTTP Health

---

## Graphite

Stores infrastructure metrics collected using **Telegraf**.

Metrics include:

- CPU Usage
- Memory Usage
- Disk Usage
- System Uptime

---

## Grafana

Visualizes infrastructure metrics using dashboards.

Dashboard Panels:

- CPU Usage
- Memory Usage
- Disk Usage
- System Uptime

---

# 🌐 Local Services

| Service | URL |
|---------|-----|
| Portfolio Website | http://localhost:8085 |
| Jenkins | http://localhost:8080 |
| Nagios | http://localhost:8081 |
| Graphite | http://localhost:8082 |
| Grafana | http://localhost:3000 |

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

This project demonstrates:

- GitHub Repository
- Jenkins CI/CD Pipeline
- Docker Image Build
- Kubernetes Deployment
- Running Portfolio Website
- Nagios Monitoring
- Graphite Metrics Collection
- Grafana Dashboard

---

# ✅ Assignment Requirements

| Requirement | Status |
|------------|--------|
| GitHub Repository | ✅ |
| Jenkins Pipeline | ✅ |
| Docker Containerization | ✅ |
| Docker Hub Repository | ✅ |
| Kubernetes Deployment | ✅ |
| Website Deployment | ✅ |
| Nagios Monitoring | ✅ |
| Graphite Metrics Collection | ✅ |
| Grafana Dashboard | ✅ |

---

# 👨‍💻 Author

**Daksh Khanna**

**Registration Number:** 24BYB0125

**Institution:** VIT Vellore

GitHub: https://github.com/Daksh-Khanna

Docker Hub: https://hub.docker.com/u/dakshkhanna

---

# 📄 License

This project was developed for academic purposes as part of **DevOps Assignment 2 – Use Case 3** at **VIT Vellore**.