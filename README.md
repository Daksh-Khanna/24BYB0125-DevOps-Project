# 🚀 Online Portfolio Website – DevOps CI/CD Pipeline

![Docker](https://img.shields.io/badge/Docker-Containerized-2496ED?logo=docker&logoColor=white)
![Kubernetes](https://img.shields.io/badge/Kubernetes-Deployed-326CE5?logo=kubernetes&logoColor=white)
![Jenkins](https://img.shields.io/badge/Jenkins-CI%2FCD-D24939?logo=jenkins&logoColor=white)
![Nagios](https://img.shields.io/badge/Nagios-Monitoring-000000)
![Graphite](https://img.shields.io/badge/Graphite-Metrics-5C2D91)
![Grafana](https://img.shields.io/badge/Grafana-Dashboard-F46800?logo=grafana&logoColor=white)

A complete DevOps implementation of an **Online Portfolio Website** demonstrating Continuous Integration, Containerization, Kubernetes Deployment, Website Monitoring, Infrastructure Metrics Collection, and Dashboard Visualization.

This project was developed for **DevOps Assignment 2 – Use Case 3** at **VIT Vellore**.

---

# 📌 Project Overview

This project implements a complete DevOps workflow for deploying and monitoring a static portfolio website.

The pipeline includes:

- Source Code Management using GitHub
- Automated Build using Jenkins
- Docker Image Creation
- Docker Hub Repository
- Kubernetes Deployment
- Website Availability Monitoring using Nagios
- Infrastructure Metrics Collection using Telegraf
- Metrics Storage using Graphite
- Dashboard Visualization using Grafana

---

# 🏗️ Architecture

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
(Availability)                     │
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
| Image Repository | Docker Hub |
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
└── .gitignore
```

---

# ⚙️ CI/CD Pipeline

The Jenkins pipeline performs the following tasks:

- ✅ Validate project files
- ✅ Build Docker image
- ✅ Push Docker image to Docker Hub

---

# 🐳 Docker

Build the image

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

# 🌐 Local Services

| Service | URL |
|---------|-----|
| Portfolio Website | http://localhost:8085 |
| Jenkins | http://localhost:8080 |
| Nagios | http://localhost:8081 |
| Graphite | http://localhost:8082 |
| Grafana | http://localhost:3000 |

---

# ❤️ Health Check

The application exposes a health endpoint used by:

- Docker HEALTHCHECK
- Kubernetes Readiness Probe
- Kubernetes Liveness Probe
- Nagios HTTP Monitoring

```
/health.html
```

---

# 📊 Monitoring

## Nagios

Nagios continuously monitors:

- Host Availability
- Website HTTP Status

---

## Graphite

Graphite stores infrastructure metrics collected by **Telegraf**.

Metrics include:

- CPU Usage
- Memory Usage
- Disk Usage
- System Uptime

---

## Grafana

Grafana visualizes the collected metrics.

Dashboard Panels

- CPU Usage
- Memory Usage
- Disk Usage
- System Uptime

---

# 📷 Screenshots

The project includes the following demonstrations:

- GitHub Repository
- Jenkins Pipeline
- Docker Image
- Kubernetes Pods
- Running Website
- Nagios Monitoring
- Graphite Metrics
- Grafana Dashboard

---

# 📋 Assignment Requirements

| Requirement | Status |
|------------|--------|
| GitHub Repository | ✅ |
| Jenkins Pipeline | ✅ |
| Docker Container | ✅ |
| Docker Hub Repository | ✅ |
| Kubernetes Deployment | ✅ |
| Website Deployment | ✅ |
| Nagios Monitoring | ✅ |
| Graphite Metrics | ✅ |
| Grafana Dashboard | ✅ |

---

# 👨‍💻 Author

**Daksh Khanna**

Registration Number: **24BYB0125**

VIT Vellore

GitHub: https://github.com/Daksh-Khanna

Docker Hub: https://hub.docker.com/u/dakshkhanna

---

# 📄 License

This project was developed for academic purposes as part of **DevOps Assignment 2 – Use Case 3** at **VIT Vellore**.