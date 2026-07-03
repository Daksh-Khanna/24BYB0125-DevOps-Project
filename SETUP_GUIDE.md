# Tool Installation & Project Setup Guide (Windows Edition)
## Online Portfolio Website — DevOps Assignment 2 (Use Case 3)

This version is written for **Windows 10 (2004+) or Windows 11**, using **PowerShell** and
**Docker Desktop** as the backbone. Docker Desktop quietly uses WSL2 under the hood, but you
won't need to touch a Linux terminal directly — everything below runs from PowerShell.

**The overall strategy:**
| Tool | How it runs on Windows |
|---|---|
| Git | Native Windows install |
| Docker | Docker Desktop |
| Kubernetes | Built into Docker Desktop (toggle on, no Minikube needed) |
| Jenkins | Native Windows install (.msi) so it can call `docker.exe`/`kubectl.exe` directly |
| Nagios | Docker container (no native Windows build exists) |
| Graphite | Docker container |
| Grafana | Docker container (or native installer — both work) |

---

## 0. Prerequisites

1. Enable **WSL2** (Docker Desktop requires it even though you won't interact with it directly):
   Open PowerShell **as Administrator** and run:
   ```powershell
   wsl --install
   ```
   Restart your PC if prompted.

2. Install **Docker Desktop for Windows**: https://www.docker.com/products/docker-desktop
   During setup, keep **"Use WSL 2 instead of Hyper-V"** checked.

3. After install, open Docker Desktop → **Settings → Kubernetes** → check **Enable Kubernetes** → **Apply & Restart**.
   Wait for the whale icon in the system tray to show "Kubernetes running" (green).

4. Verify everything from PowerShell:
   ```powershell
   docker --version
   docker run hello-world
   kubectl version --client
   kubectl get nodes        # should show a node named "docker-desktop", Ready
   ```

---

## 1. Git & GitHub

Install **Git for Windows**: https://git-scm.com/download/win (accept defaults; this also gives you Git Bash, which is handy but optional).

```powershell
git --version
git config --global user.name "Your Name"
git config --global user.email "you@example.com"
```

- Create a GitHub account at **https://github.com** if needed.
- Create an empty repo named `RegisterNumber-DevOps-Project`.
- Push the project (run inside the `portfolio-project` folder):
```powershell
cd portfolio-project
git init
git add .
git commit -m "Initial commit: portfolio site + DevOps pipeline"
git branch -M main
git remote add origin https://github.com/<yourusername>/<RegisterNumber>-DevOps-Project.git
git push -u origin main
```
**Access:** `https://github.com/<yourusername>/<RegisterNumber>-DevOps-Project`

---

## 2. Docker (already installed in Step 0)

```powershell
docker images
docker ps
```
No separate install needed — Docker Desktop is your Docker engine, CLI, and (optionally) Kubernetes all in one. There's no web UI for Docker itself; use the **Docker Desktop app** (GUI) or the `docker` CLI to inspect images/containers.

---

## 3. Jenkins (native Windows install)

Download the Windows installer: **https://www.jenkins.io/download/** → *Windows* → run the `.msi`.

The installer will:
- Install Jenkins as a **Windows Service**
- Open a browser to `http://localhost:8080` automatically

**Important — give Jenkins access to Docker/Kubernetes:**
By default the Jenkins service runs as `Local System`, which usually **cannot** see Docker
Desktop (it's tied to your logged-in user session). Fix this:
1. Press `Win + R` → type `services.msc` → Enter
2. Find **Jenkins** → right-click → **Properties → Log On** tab
3. Select **This account** → enter your own Windows username/password
4. Click **OK**, then right-click Jenkins → **Restart**

**First-time setup at http://localhost:8080:**
1. Unlock Jenkins using the password from:
   ```powershell
   Get-Content "C:\Program Files\Jenkins\secrets\initialAdminPassword"
   ```
2. Choose **Install suggested plugins**
3. Also install (*Manage Jenkins → Plugins → Available*): **Docker Pipeline**, **Kubernetes CLI**
4. Create your admin user

**Add credentials** (*Manage Jenkins → Credentials → System → Global credentials → Add*):
- `dockerhub-creds` — Username/Password (your Docker Hub login)
- `kubeconfig-file` — Secret file, upload `%USERPROFILE%\.kube\config` (Docker Desktop creates this automatically once Kubernetes is enabled)

**Create the pipeline job:**
1. New Item → name `online-portfolio-pipeline` → type **Pipeline**
2. *Pipeline* section → **Pipeline script from SCM** → SCM: Git → your GitHub repo URL → Script Path: `Jenkinsfile`
3. Save → **Build Now**

> **Note on the Jenkinsfile:** since Jenkins now runs natively on Windows, its pipeline steps
> must use `bat` (Windows batch) instead of `sh` (Linux shell). A Windows-ready `Jenkinsfile`
> is included in **Section 8**.

**Access:** `http://localhost:8080`

---

## 4. Kubernetes (already enabled via Docker Desktop in Step 0)

No Minikube needed — Docker Desktop's built-in Kubernetes is simpler on Windows and, unlike
Minikube, its NodePort services are reachable directly at `localhost`.

```powershell
cd portfolio-project
kubectl apply -f k8s\deployment.yaml
kubectl apply -f k8s\service.yaml
kubectl get pods -l app=portfolio      # wait for "Running"
kubectl get svc portfolio-service
```

**Access the site:** `http://localhost:30080` — that's it, no `minikube service` command required.

---

## 5. Nagios (Docker container)

Nagios has no native Windows build, so run it as a Linux container via Docker Desktop.

```powershell
mkdir C:\nagios\etc, C:\nagios\var, C:\nagios\plugins

docker run -d --name nagios `
  -p 8081:80 `
  -v C:\nagios\etc:/opt/nagios/etc `
  -v C:\nagios\var:/opt/nagios/var `
  -v C:\nagios\plugins:/opt/Custom-Nagios-Plugins `
  jasonrivers/nagios:latest
```
> On first run, the container populates `C:\nagios\etc` with its default config files
> (this is why the folders should start empty).

**Add this project's checks:**
```powershell
copy portfolio-project\monitoring\nagios\portfolio.cfg C:\nagios\etc\objects\portfolio.cfg
```
Then edit `C:\nagios\etc\nagios.cfg` (Notepad is fine) and add this line near the other `cfg_file=` entries:
```
cfg_file=/opt/nagios/etc/objects/portfolio.cfg
```
Restart the container to pick up the change:
```powershell
docker restart nagios
```

**Access:** `http://localhost:8081` — default login is **nagiosadmin / nagios**
(change this password via the `NAGIOSADMIN_PASS` environment variable on `docker run`,
e.g. add `-e NAGIOSADMIN_PASS=yourpassword` before `jasonrivers/nagios:latest`).
Go to **Services** in the left menu to see Host UP / Services OK.

---

## 6. Graphite (Docker container)

```powershell
docker run -d `
  --name graphite `
  --restart=always `
  -p 8082:80 `
  -p 2003-2004:2003-2004 `
  -p 2023-2024:2023-2024 `
  -p 8125:8125/udp `
  -p 8126:8126 `
  graphiteapp/graphite-statsd
```

**Access:** `http://localhost:8082` — default login **root / root** (change after first login)
Carbon plaintext receiver: `localhost:2003` — this is what feeds metrics in.

**Feed metrics in** (run periodically from PowerShell, or schedule via Windows Task Scheduler):
```powershell
$stats = Invoke-WebRequest -Uri "http://localhost:30080/nginx_status" -UseBasicParsing
$active = ($stats.Content -split "`n")[2] -replace '\D',''
$ts = [int][double]::Parse((Get-Date -UFormat %s))
$msg = "portfolio.nginx.active_connections $active $ts`n"
$client = New-Object System.Net.Sockets.TcpClient("localhost", 2003)
$stream = $client.GetStream()
$bytes = [System.Text.Encoding]::ASCII.GetBytes($msg)
$stream.Write($bytes, 0, $bytes.Length)
$client.Close()
```
> This is a PowerShell translation of `monitoring/graphite/push_nginx_metrics.sh`. If you have
> Git Bash available, you can run the original `.sh` script instead — either works.

For system-level metrics, `collectd` is Linux-only, so on Windows the simplest substitute is
reading Kubernetes' own resource metrics:
```powershell
kubectl top pods
kubectl top nodes
```

Check data arrived: open `http://localhost:8082` → **Metrics** tree (left sidebar) → expand `portfolio` → click a metric to graph it.

---

## 7. Grafana (Docker container)

```powershell
docker run -d --name grafana -p 3000:3000 grafana/grafana
```

**Access:** `http://localhost:3000` — default login **admin / admin** (forced password change on first login)

**Connect it to Graphite:**
1. Left menu → **Connections → Data sources → Add data source → Graphite**
2. URL: `http://host.docker.internal:8082` (use this special DNS name so the Grafana
   container can reach the Graphite container through the host — `localhost` won't work
   *between* two separate containers)
3. Save & Test

**Import the dashboard:**
1. Left menu → **Dashboards → New → Import**
2. Upload `portfolio-project\monitoring\grafana\portfolio-dashboard.json`
3. Select the Graphite data source → **Import**

**Access dashboard:** `http://localhost:3000/dashboards` → **Online Portfolio - Infrastructure Dashboard**

---

## 8. Windows-Compatible Jenkinsfile

Replace the contents of `portfolio-project\Jenkinsfile` with this version — it swaps every
`sh` step for `bat` so it runs correctly under a native Windows Jenkins agent:

```groovy
pipeline {
    agent any

    environment {
        DOCKERHUB_CREDENTIALS = credentials('dockerhub-creds')
        IMAGE_NAME  = "yourdockerhubuser/online-portfolio"
        IMAGE_TAG   = "${env.BUILD_NUMBER}"
        KUBECONFIG_CRED = credentials('kubeconfig-file')
    }

    stages {
        stage('Checkout') {
            steps {
                git branch: 'main', url: 'https://github.com/yourusername/online-portfolio-devops.git'
            }
        }

        stage('Validate') {
            steps {
                bat 'if not exist src\\index.html exit 1'
                bat 'if not exist src\\css\\style.css exit 1'
                bat 'if not exist src\\js\\main.js exit 1'
            }
        }

        stage('Build Docker Image') {
            steps {
                bat 'docker build -t %IMAGE_NAME%:%IMAGE_TAG% -t %IMAGE_NAME%:latest .'
            }
        }

        stage('Push to Docker Hub') {
            steps {
                bat 'echo %DOCKERHUB_CREDENTIALS_PSW%| docker login -u %DOCKERHUB_CREDENTIALS_USR% --password-stdin'
                bat 'docker push %IMAGE_NAME%:%IMAGE_TAG%'
                bat 'docker push %IMAGE_NAME%:latest'
            }
        }

        stage('Deploy to Kubernetes') {
            steps {
                bat '''
                    set KUBECONFIG=%KUBECONFIG_CRED%
                    kubectl set image deployment/portfolio-deployment portfolio=%IMAGE_NAME%:%IMAGE_TAG% --record || kubectl apply -f k8s\\deployment.yaml
                    kubectl apply -f k8s\\service.yaml
                    kubectl rollout status deployment/portfolio-deployment
                '''
            }
        }

        stage('Smoke Test') {
            steps {
                bat 'timeout /t 10'
                bat 'curl -f http://localhost:30080/health.html || echo Check NodePort/service'
            }
        }
    }

    post {
        success { echo 'Pipeline completed successfully. Portfolio site deployed.' }
        failure { echo 'Pipeline failed. Check console output above.' }
        always  { bat 'docker logout || exit 0' }
    }
}
```

---

## 9. Running the Whole Project End-to-End

```powershell
# 1. Make a change
notepad portfolio-project\src\index.html

# 2. Push to GitHub
cd portfolio-project
git add .
git commit -m "Update homepage copy"
git push

# 3. Trigger Jenkins: click "Build Now" in the Jenkins UI
#    (or set up a GitHub webhook -> Settings -> Webhooks -> Payload URL:
#    http://<your-public-ip-or-ngrok-url>:8080/github-webhook/ for full automation —
#    this requires Jenkins to be reachable from the internet, which typically means
#    using a tool like ngrok on a home/lab machine)

# 4. Jenkins builds the Docker image -> pushes to Docker Hub -> deploys to Kubernetes
# 5. Kubernetes rolls out new pods with zero downtime (RollingUpdate strategy)
# 6. Confirm the change is live:
start http://localhost:30080

# 7. Watch metrics in Grafana / status in Nagios in real time
```

---

## 10. Where to Access Everything — Quick Reference

| Tool | URL | Default Login |
|---|---|---|
| GitHub repo | `https://github.com/<user>/<RegisterNumber>-DevOps-Project` | your GitHub account |
| Jenkins | `http://localhost:8080` | admin user you create during setup |
| Docker Hub | `https://hub.docker.com/r/<user>/online-portfolio` | your Docker Hub account |
| Portfolio site (Kubernetes) | `http://localhost:30080` | — |
| Nagios | `http://localhost:8081` | `nagiosadmin` / `nagios` (change via `-e NAGIOSADMIN_PASS=`) |
| Graphite | `http://localhost:8082` | `root` / `root` (change after first login) |
| Grafana | `http://localhost:3000` | `admin` / `admin` (forced change on first login) |

---

## 11. Common Troubleshooting (Windows-specific)

- **Jenkins can't run `docker` commands** ("docker is not recognized") → the Jenkins service
  is still logged in as `Local System`. Re-check Section 3's "Log On" fix, and confirm
  `docker.exe` is on the PATH for that account (`where docker` in a Command Prompt run as
  that user).
- **`kubectl get nodes` returns nothing / connection refused** → Kubernetes isn't enabled or
  hasn't finished starting in Docker Desktop. Check the whale icon in the system tray; it
  should say "Kubernetes running" in green. This can take a few minutes on first enable.
- **Grafana can't reach Graphite** → don't use `localhost` between two containers; use
  `host.docker.internal` as shown in Section 7, since each container has its own network namespace.
- **Port already in use** (e.g. `8080` conflicts with something else) → change the `-p` mapping
  on the `docker run` command, e.g. `-p 8090:80`, and just remember to use that port when
  browsing instead.
- **`wsl --install` says WSL already installed but Docker Desktop still won't start** → run
  `wsl --update` in an Administrator PowerShell, then restart your PC.
- **Nagios config check fails after editing nagios.cfg** → exec into the container to run the
  built-in validator:
  ```powershell
  docker exec -it nagios /opt/nagios/bin/nagios -v /opt/nagios/etc/nagios.cfg
  ```
