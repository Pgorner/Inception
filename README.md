# Inception
How to set up the 42 Inception project. 


Folder structure:

Inception/
│
├── Makefile
├── srcs/
│   ├── docker-compose.yml
│   ├── .env
│   │
│   ├── requirements/
│   │   ├── mariadb/
│   │   │   ├── conf/   <-- Conf folder specific to MariaDB service
│   │   │   │   └── (MariaDB-specific conf files)
│   │   │   ├── Dockerfile
│   │   │   ├── .dockerignore
│   │   │   └── tools/   <-- Tools folder specific to MariaDB service
│   │   │       └── (MariaDB-specific tools and scripts)
│   │   │
│   │   ├── nginx/
│   │   │   ├── conf/   <-- Conf folder specific to Nginx service
│   │   │   │   └── (Nginx-specific conf files)
│   │   │   ├── Dockerfile
│   │   │   ├── .dockerignore
│   │   │   └── tools/   <-- Tools folder specific to Nginx service
│   │   │       └── (Nginx-specific tools and scripts)
│   │   │
│   │   └── wordpress/
│   │       ├── conf/   <-- Conf folder specific to WordPress service
│   │       │   └── (WordPress-specific conf files)
│   │       ├── Dockerfile
│   │       ├── .dockerignore
│   │       └── tools/   <-- Tools folder specific to WordPress service
│   │           └── (WordPress-specific tools and scripts)
│   │
│   └── tools/  <-- General tools directory, if you have tools shared across services
│       └── (General tools and scripts used by multiple services)
│
└── (Other project files and directories, in this case not needed)


Where to start:
1. Make the above folder structure
2. Download your choice of System and set it up in VM
3. Start with the Makefile
4. Write the docker-compose.yml
5. Write your .env



2. Download your choice of System and set it up in VM
   I chose lubuntu as it was suggested to be due to having a graphics interface and being lightweight. Also has generally worked for Inception before
    download: https://lubuntu.me/downloads/
    setup: https://www.cs.jhu.edu/~joanne/virtualBox.html
   Things to note:
        - needs 2 CPU in VBox to run otherwise kernel panic
        - would go to -settings->general->advanced and enable at least Shared Clipboard (Bidirectional) or its a pain to do this

    If it aint working follow instructions in the link above.

   Download and install docker
     - sudo apt-get update
     - sudo apt-get docker.io
     - sudo apt-get docker-compose
   Download git
     - sudo apt-get install git-all
  
      I prefer to code locally to some extent then push, clone in VM and then keep working there


4. MAKEFILE WHATS NEEDED(OR I THINK IS NEEDED):

Targets:
all: This target is the default one that gets executed when you simply run make. It ensures that Docker is running (check-docker), checks for the existence of the .env file ($(ENV_FILE)), creates necessary data directories ($(DATA)), and starts the project (up). It's convenient for developers because they can initiate the entire project setup with a single command.

up: This target uses Docker Compose to launch the services defined in ./srcs/docker-compose.yml. It reads environment variables from the .env file specified in ENV_FILE. This is crucial for starting the project in the correct configuration and environment.

down: This target stops and removes all services defined in ./srcs/docker-compose.yml. It's essential for cleanly shutting down the project, releasing resources, and ensuring no leftover containers affect future runs.

re: This target is a shorthand for cleaning the project (clean) and then rebuilding it (all). It's a useful convenience for developers who want to reset the project to a clean state and rebuild everything from scratch.

logs: This target displays the logs of the services defined in ./srcs/docker-compose.yml. It's helpful for debugging and understanding what's happening inside the running containers.

clean: This target stops and removes all running containers, deletes all images, and removes all Docker volumes. It's a powerful, albeit potentially dangerous, command that ensures a complete cleanup of the Docker environment. It's useful when you want to reclaim disk space and start fresh, but use it cautiously to avoid accidental data loss.

check-docker: This target checks if Docker is running. If not, it attempts to start Docker in the background. This is important because the other targets depend on Docker being operational. The check ensures a smooth experience for developers, alerting them if Docker needs to be started manually.

$(ENV_FILE): This target checks if the .env file exists. If not, it displays an error message and exits. This is useful for ensuring that the necessary configuration file is present before starting the project, preventing potential runtime errors due to missing configuration.

$(DATA): This target creates specific directories (wordpress_db and wordpress_files) within the data directory. It's crucial for ensuring that the project has the required directory structure for storing data. Without these directories, the project might encounter errors related to missing paths.


4. Write the docker-compose.yml
   
version: '3'
This specifies the version of the Docker Compose file format being used. Different versions support different features and syntax, so it's important to specify the correct version for compatibility.

networks: inception:
Defines a custom bridge network named "inception". Docker containers within the same network can communicate with each other. Using a custom network isolates these services from the default bridge network, providing a more controlled and secure environment.

services:
This section defines the individual services or containers in the application.

volumes: Mounts a Docker volume named to the container

container_name: Specifies the custom name for the container.

env_file: Loads environment variables from the specified file (.env in this case). Environment variables often contain sensitive information like passwords or API keys.

build: Specifies the build context
networks: Connects the container to the "inception" network.
restart: always: Ensures that the container restarts automatically if it exits.

nginx:
ports: "443:443": Maps port 443 on the host to port 443 on the container. This is for serving HTTPS traffic.
volumes: Mounts the same wordpress_files volume to serve the WordPress website

volumes:
This section defines named volumes used by the services. Named volumes provide a way to persist data even if the containers are removed. The volumes are of type local and are mounted to specific directories on the host (${HOME}/data/wordpress_db and ${HOME}/data/wordpress_files).

Explanation of the Order:
The order of services and volumes in this YAML file is arbitrary. Docker Compose processes the services and volumes sections in the order they are defined, but there is no strict requirement for the order of services or volumes. However, it's a good practice to keep related services close to each other in the file for readability and maintainability.


6. Write your .env
