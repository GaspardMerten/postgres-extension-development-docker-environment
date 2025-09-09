# PostgreSQL Extension Development Environment

This project provides a Docker-based PostgreSQL environment for building, testing, and developing PostgreSQL extensions.

## Getting Started

### Prerequisites

*   [Docker](https://docs.docker.com/get-docker/) must be installed on your system.

### Building and Running the Container

1.  **Build the Docker image:**

    ```bash
    docker build -t postgres-extension-dev .
    ```

2.  **Run the Docker container:**

    ```bash
    docker run -it -v ./extension:/extension -p 5432:5432 --name postgres-container postgres-extension-dev
    ```

    This command will:
    *   Start the container in interactive mode (`-it`).
    *   Mount the local `extension` directory into the `/extension` directory in the container (`-v ./extension:/extension`). This allows you to edit files on your host machine and have the changes reflected in the container.
    *   Forward port 5432 from the container to your host machine (`-p 5432:5432`).
    *   Name the container `postgres-container` for easy access.

## Extension Development

This environment is pre-configured for PostgreSQL extension development. A sample extension named `my_extension` is included.

### Reloading an Extension

When you modify the source code of your extension (e.g., `my_extension.c`), you need to rebuild and reinstall it for the changes to be loaded by PostgreSQL.

#### Manual Reload Process

1.  **Access the container's shell:**

    If you are not already in the container's shell from the `docker run` command, you can use:

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
    -- Replace my_extension with the name of your extension
    DROP EXTENSION my_extension;
    CREATE EXTENSION my_extension;
    ```

#### Automated Reload with `pg-reload`

A convenience script, `pg-reload`, is included to automate the build and reload process.

**From inside the container:**

Simply run the `pg-reload` command. The script is in the system's PATH.

```bash
pg-reload
```

**From the host machine:**

You can execute the script inside the running container using `docker exec`:

```bash
docker exec postgres-container pg-reload
```

This script performs the following steps:

1.  Executes `make clean && make install` within the `extension` directory.
2.  Connects to the `postgres` database.
3.  Drops and recreates the `my_extension` extension.