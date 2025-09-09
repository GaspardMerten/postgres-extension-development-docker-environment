# PostgreSQL Extension Development Environment

This project provides a Docker-based PostgreSQL environment for building, testing, and developing PostgreSQL extensions.

## Quick Start: Using the Docker Hub Image

The easiest way to get started is to use the pre-built image from Docker Hub.

**Run the container:**

```bash
docker run -it -v ./extension:/extension -p 5432:5432 --name postgres-container gaspardmerten/postgres_extension_development
```

This command will start the container with the local `extension` directory mounted, allowing you to work on your extension files from your host machine.

*Note: If the image is not found locally, `docker run` will automatically pull it from Docker Hub.*

## Short Tutorial: Understanding the Extension Structure

The `extension` directory contains a minimal PostgreSQL extension to get you started. Here's a breakdown of the essential files:

*   **`my_extension.control`**: This is the main control file for the extension. It tells PostgreSQL about the extension, its version, and which SQL script to run for installation.
*   **`my_extension--1.0.sql`**: This SQL script is executed when you run `CREATE EXTENSION my_extension;`. It defines the functions, operators, and other objects that your extension provides.
*   **`Makefile`**: This file is used by the `make` command to build your extension. It specifies the source files, compilation flags, and installation steps.
*   **`my_extension.c`**: This is the C source code for your extension. Here, you'll define the logic for your functions. For example, the sample `my_extension.c` file might contain a simple function that adds two numbers.

When you run `make install`, the compiled library (e.g., `my_extension.so`) is copied to the PostgreSQL extension directory, and the `.sql` and `.control` files are copied to the appropriate location.

## Building the Image Locally

If you want to modify the development environment itself, you can build the Docker image locally.

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

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
