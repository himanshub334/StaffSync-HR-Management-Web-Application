# StaffSync — HR Management Web Application

Angular 15 + TypeScript + Node.js + Express + PostgreSQL HR platform.

## Features
- Employee onboarding and directory
- Leave management and atomic approval workflow
- ADMIN / HR / EMPLOYEE RBAC
- JWT access tokens and refresh-token rotation
- PostgreSQL normalized schema and PL/pgSQL procedures
- HR reporting with LAG, ROLLUP and NTILE
- Swagger/OpenAPI
- Angular Material, standalone components, reactive forms, OnPush and RxJS
- Docker Compose and GitHub Actions
- Jest API tests

## Run
```bash
docker compose up --build
```
Frontend: http://localhost:4200
API: http://localhost:3000
Swagger: http://localhost:3000/api-docs

Demo users:
admin@staffsync.local / Admin@123
hr@staffsync.local / Hr@123
employee@staffsync.local / Employee@123

## GitHub
```bash
git init
git add .
git commit -m "Initial commit - StaffSync HR management application"
git branch -M main
git remote add origin https://github.com/YOUR_USERNAME/StaffSync.git
git push -u origin main
```
# StaffSync-HR-Management-Web-Application
