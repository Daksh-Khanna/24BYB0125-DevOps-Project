# Online Portfolio Website — DevOps Pipeline (Use Case 3)

A multi-client web design portfolio site with a full DevOps pipeline:
**Git → Jenkins → Docker → Kubernetes → Nagios + Graphite + Grafana**

> **Running on Windows?** See `SETUP_GUIDE.md` for a Windows-specific walkthrough
> (Docker Desktop + built-in Kubernetes, native Jenkins, and Nagios/Graphite/Grafana as
> Docker containers). The `Jenkinsfile` in this repo already uses `bat` steps for Windows.

---

## 1. Project Structure

```
portfolio-project/
├── src/                     # Static website (HTML/CSS/JS)
│   ├── index.html
│   ├── health.html          # used by Nagios / Docker HEALTHCHECK
│   ├── css/style.css
│   └── js/main.js
├── Dockerfile
├── nginx.conf                # custom nginx config (adds /health, /nginx_status)
├── Jenkinsfile                # CI/CD pipeline definition
├── k8s/
│   ├── deployment.yaml        # 3-replica Deployment with probes
│   └── service.yaml           # NodePort Service (port 30080)
├── monitoring/
│   ├── nagios/portfolio.cfg           # host + service checks
│   ├── graphite/collectd.conf         # feeds infra metrics to Carbon
│   ├── graphite/push_nginx_metrics.sh # feeds nginx metrics to Carbon
│   └── grafana/portfolio-dashboard.json
└── README.md
```

## 2. Step-by-Step Implementation

### Step 1 — Version Control (Git/GitHub)
```bash
git init
git add .
git commit -m "Initial commit: portfolio site + DevOps pipeline"
git branch -M main
git remote add origin https://github.com/<yourusername>/<RegisterNumber>-DevOps-Project.git
git push -u origin main
```
Take a screenshot of the GitHub repo page showing all files pushed.

### Step 2 — Jenkins Automated Build
1. Install Jenkins, then install the **Docker Pipeline** and **Kubernetes CLI** plugins.
2. Add credentials in Jenkins: `dockerhub-creds` (Docker Hub username/password) and
   `kubeconfig-file` (secret file — your cluster's kubeconfig).
3. Create a new Pipeline job → point it at this repo → it will auto-detect the `Jenkinsfile`.
4. Click **Build Now**.
5. Screenshot the Jenkins Dashboard, the Job Configuration page, the Console Output, and the
   final "Success" build status (all four are required if Jenkins is local).

### Step 3 — Docker Build & Run (manual verification, optional if Jenkins already did it)
```bash
docker build -t <yourdockerhubuser>/online-portfolio:latest .
docker run -d -p 8080:80 --name portfolio-test <yourdockerhubuser>/online-portfolio:latest
# Visit http://localhost:8080
docker push <yourdockerhubuser>/online-portfolio:latest
```
Screenshot: `docker images`, `docker ps` (container running), and the browser showing the site.

### Step 4 — Kubernetes Deployment
```bash
kubectl apply -f k8s/deployment.yaml
kubectl apply -f k8s/service.yaml
kubectl get pods -l app=portfolio
kubectl get svc portfolio-service
```
Access the site at `http://<node-ip>:30080` (or `http://localhost:30080` on minikube with
`minikube service portfolio-service`).
Screenshot: `kubectl get pods` and `kubectl get svc` both showing **Running**, and the browser output.

### Step 5 — Nagios Monitoring
```bash
sudo cp monitoring/nagios/portfolio.cfg /usr/local/nagios/etc/objects/
# add: cfg_file=/usr/local/nagios/etc/objects/portfolio.cfg  to nagios.cfg
sudo systemctl restart nagios
```
Open the Nagios web UI → Services → confirm **Host UP** and **HTTP Website / PING / Docker
Daemon** services are **OK**. Screenshot this page.

### Step 6 — Graphite Metrics
```bash
# On the monitored host/node:
sudo apt install collectd
sudo cp monitoring/graphite/collectd.conf /etc/collectd/collectd.conf
sudo systemctl restart collectd

# Cron job (every minute) to push nginx metrics:
* * * * * /path/to/monitoring/graphite/push_nginx_metrics.sh http://localhost:30080/nginx_status <graphite-host> 2003
```
Open Graphite's web UI (`http://<graphite-host>:8080`) → Metrics tree → expand `portfolio.*` →
confirm data points are arriving. Screenshot the graph.

### Step 7 — Grafana Dashboard
1. In Grafana, add a **Graphite** data source pointing at your Graphite server.
2. Dashboards → Import → upload `monitoring/grafana/portfolio-dashboard.json`.
3. Select the Graphite data source when prompted.
4. Confirm panels for CPU, Memory, Network Traffic, Nginx Connections, and Uptime populate
   with live data. Screenshot the dashboard.

## 3. Expected Final Output Checklist
- [ ] Website deployed successfully
- [ ] Kubernetes Pods Running (3/3)
- [ ] Website accessible via browser (NodePort 30080)
- [ ] Nagios: Host UP, Services OK
- [ ] Graphite: receiving `portfolio.*` metrics
- [ ] Grafana: dashboard rendering all panels
