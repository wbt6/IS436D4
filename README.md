# SmartCampus — Deliverable 4: Data Model & Architecture

## Project summary
SmartCampus is a platform to streamline student services across campus: advising, counseling, IT support, appointment booking, and service requests. This repository contains the database schema, ERD documentation, architecture design, deployment artifacts (Docker Compose), project plan, and team information to satisfy Deliverable 4.

## Repo links
- GitHub repo: https://github.com/wbt6/docker-database-project  (replace with your repo URL if different)
- GitHub project: https://github.com/users/wbt6/projects/2

## Technologies used
- Database: MySQL 8 (containerized via Docker Compose)
- Containerization: Docker & Docker Compose
- Backend: Node.js + Express (recommended) or Python + FastAPI
- Frontend: React (recommended) or static HTML/CSS
- Cache: Redis (optional)
- Monitoring: Prometheus + Grafana (optional)
- Reverse proxy: Nginx
- CI/CD: GitHub Actions

## Contents
- `README.md` — this file
- `sql/schema_and_seed.sql` — single MySQL script to create and seed the database
- `docker-compose.yml` — MySQL container example
- `erd/` — ERD exports and textual entity descriptions (PNG/PDF/TXT)
- `architecture/` — architecture diagrams + matrices
- `project-plan/` — CSV of issues / stories
- `TEAM.md` — team contacts, bios, meeting times

## How to run (local DB)
1. Install Docker & Docker Compose.
2. Clone repo and ensure `sql/schema_and_seed.sql` exists.
3. `docker compose up -d`
4. Connect to DB: host `localhost`, port `3306`, user `sc_admin`, password `sc_admin123`, database `smartcampus_db`.

## Deliverable submission
