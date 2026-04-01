# Dockerization Guide

This document explains the Docker setup for the `ecomm-webapp-rajapur` application, describing each component and outlining how to run the project.

## What is Dockerization?

Dockerization is the process of packaging an application and its dependencies into isolated, standard units called containers. For this project, Docker ensures that it runs securely and consistently on any machine without having to manually install tools like Node.js, `pnpm`, or PostgreSQL. 

## What This Setup Does

We have used `docker-compose` to orchestrate multiple containers that map locally to your machine. 

1. **`app` container** 
   - Uses the official `node:22-alpine` image as its base.
   - Installs system dependencies using the `pnpm` package manager via Corepack.
   - Maps your local project folder to `/usr/src/app` inside the container. This means when you hit save on any code changes in your favorite editor, the `start:dev` hot-reload picks it up and rebuilds instantly.
   - Ignores your local `node_modules` and handles the container's version anonymously to avoid symlink complications.
   - Runs on the `APP_PORT` set to `4000` (can be changed in `.env`).

2. **`db` container (PostgreSQL)**
   - Uses the official `postgres:15-alpine` image.
   - Bootstraps automatically creating the following database configuration internally:
     - **Database name:** `ecomm-wepapp-rajapur`
     - **Database user:** `ecomm-user`
     - **Database password:** `ecomm@dev123`
   - Configures a healthcheck to ensure the container verifies Database readyness before the `app` container starts and attempts a connection.
   - Exposes port `5432`.
   - Maps its data to a persistent named docker volume (`ecomm-db-data`) to prevent your data records from wiping when you close your machine.

## How to use it?

### Requirements
You must have [Docker Desktop](https://www.docker.com/products/docker-desktop/) installed on your machine and running. 

### 1. Starting the environment 

To run both your NestJS application and Postgres database via `docker-compose`, navigate to the project directory in your terminal and type:

```bash
docker compose up -d --build
```

- `-d` runs it in "detached mode" in the background. 
- `--build` ensures your images are built for the latest changes. 

When you do this, you can watch the application logs specifically safely using:
```bash
docker compose logs -f app
```

### 2. Stopping the environment

When you need to turn off the server without deleting the database volume, use:

```bash
docker compose stop
```

### 3. Deleting the environment completely

If you'd like to remove the containers completely and **clear** the database, run:
```bash
docker compose down -v
```

> [!WARNING]
> Running the command with `-v` will delete the `ecomm-db-data` volume entirely. Run `docker compose down` (without `-v`) if you want to keep the data but tear down the network.
