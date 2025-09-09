# PostgreSQL Extension Development Environment

This project provides a Docker-based PostgreSQL environment for building, testing, and developing PostgreSQL extensions. It's designed to be easy for beginners to get started, while also providing the tools and flexibility that experienced developers need.

The docker image is available on [Docker Hub](https://hub.docker.com/r/gaspardmerten/postgres_extension_development) and can be used directly. Alternatively, you can build the image locally from the provided `Dockerfile`.

## Prerequisites

Before you begin, you'll need to have [Docker](https://docs.docker.com/get-docker/) installed on your system. Docker is a tool that allows you to run applications in isolated environments called containers. This project uses Docker to provide a consistent and reproducible PostgreSQL development environment.

## Getting Started: A Step-by-Step Guide for Beginners

This guide will walk you through setting up the development environment using the pre-built Docker image from Docker Hub. This is the fastest and easiest way to get started.

### 1. Run the Container

Open your terminal and run the following command:

```bash
docker run -it -v ./extension:/extension -p 5432:5432 --name postgres-container gaspardmerten/postgres_extension_development
```

Let's break down this command:
*   `docker run`: This is the command to start a new Docker container.
*   `-it`: This tells Docker to run the container in interactive mode, so you can see the output and interact with the shell inside the container.
*   `-v ./extension:/extension`: This mounts the `extension` directory from your computer into the `/extension` directory inside the container. This is the key to development: you can edit the files on your host machine, and the changes will be immediately available in the container.
*   `-p 5432:5432`: This forwards port 5432 from the container to port 5432 on your host machine. This allows you to connect to the PostgreSQL database running inside the container using any PostgreSQL client on your computer.
*   `--name postgres-container`: This gives the container a memorable name, so you can easily refer to it later.
*   `gaspardmerten/postgres_extension_development`: This is the name of the Docker image to use. If you don't have it on your computer, Docker will automatically download it from Docker Hub.

### 2. Understanding the Extension Structure

The `extension` directory in this project contains a minimal PostgreSQL extension to get you started. Here's a breakdown of the essential files:

*   **`my_extension.control`**: This is the main control file for the extension. It tells PostgreSQL about the extension, its version, and which SQL script to run for installation.
*   **`my_extension--1.0.sql`**: This SQL script is executed when you run `CREATE EXTENSION my_extension;`. It defines the functions, operators, and other objects that your extension provides.
*   **`Makefile`**: This file is used by the `make` command to build your extension. It specifies the source files, compilation flags, and installation steps.
*   **`my_extension.c`**: This is the C source code for your extension. Here, you'll define the logic for your functions. For example, the sample `my_extension.c` file might contain a simple function that adds two numbers.

When you run `make install`, the compiled library (e.g., `my_extension.so`) is copied to the PostgreSQL extension directory, and the `.sql` and `.control` files are copied to the appropriate location.

### 3. Developing and Reloading Your Extension

When you make changes to your extension's source code (e.g., `my_extension.c`), you need to rebuild and reinstall it for the changes to be loaded by PostgreSQL.

#### The Easy Way: Automated Reloading

A convenience script, `pg-reload`, is included to automate the build and reload process.

*   **From inside the container:** If you are in the container's shell, you can simply run:
    ```bash
    pg-reload
    ```
*   **From your host machine:** You can execute the script inside the running container using `docker exec`:
    ```bash
    docker exec postgres-container pg-reload
    ```

This script will:
1.  Clean the build artifacts.
2.  Build and install the extension.
3.  Connect to the `postgres` database.
4.  Drop and recreate the `my_extension` extension to load the new version.

#### The Manual Way: Step-by-Step

For a better understanding of the process, you can also reload the extension manually:

1.  **Access the container's shell:**
    ```bash
    docker exec -it postgres-container bash
    ```
2.  **Navigate to your extension's source directory:**
    ```bash
    cd /extension
    ```
3.  **Build and install the extension:**
    ```bash
    make clean && make install
    ```
4.  **Connect to PostgreSQL and reload the extension:**
    ```sql
    psql -U postgres
    -- In the psql shell, run:
    DROP EXTENSION my_extension;
    CREATE EXTENSION my_extension;
    ```

## For Advanced Users: Building the Image Locally

If you want to modify the development environment itself (e.g., by installing additional tools or changing the PostgreSQL version), you can build the Docker image locally.

### 1. Build the Docker Image

```bash
docker build -t postgres-extension-dev .
```

### 2. Run the Custom Container

```bash
docker run -it -v ./extension:/extension -p 5432:5432 --name postgres-container postgres-extension-dev
```

This is the same `docker run` command as before, but this time it uses your locally built `postgres-extension-dev` image.

## License

This project is licensed under the MIT License - see the [LICENSE](https://github.com/GaspardMerten/postgres-extension-development-docker-environment/blob/main/LICENSE) file for details.