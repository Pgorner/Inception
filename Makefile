# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    Makefile                                           :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: pgorner <pgorner@student.42heilbronn.de    +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2023/09/28 16:11:11 by pgorner           #+#    #+#              #
#    Updated: 2023/10/28 14:17:53 by pgorner          ###   ########.fr        #
#                                                                              #
# **************************************************************************** #

ENV_FILE := ./srcs/.env
DATA := ./data

all: $(ENV_FILE) $(DATA) up

up:
	@docker-compose -f ./srcs/docker-compose.yml --env-file $(ENV_FILE) up -d --build

down:
	@docker-compose -f ./srcs/docker-compose.yml down

re: clean all

logs:
	@docker-compose -f ./srcs/docker-compose.yml logs

clean:
	@rm -rf $(HOME)/data/wordpress_db
	@rm -rf $(HOME)/data/wordpress_files
	@docker system prune --all --force --volumes
	@docker volume prune --force
	@docker network prune --force
	@docker volume rm `docker volume ls -q`
	@echo "MADE CLEAN"

$(ENV_FILE):
	@echo "Please create the .env file at $(ENV_FILE) with the required environment variables:"
	@echo "# MySQL/MariaDB"
	@echo "DB_DATABASE="
	@echo "DB_HOSTNAME="
	@echo "DB_USER="
	@echo "DB_PASSWORD="
	@echo "# WP Admin"
	@echo "WP_ADMIN_USR="
	@echo "WP_ADMIN_EMAIL="
	@echo "WP_ADMIN_PWD="
	@echo "# WP User"
	@echo "WP_USER_NAME="
	@echo "WP_USER_EMAIL="
	@echo "WP_USER_PASSWORD="
	@exit 1
	
$(DATA):
	mkdir -p $(HOME)/data/wordpress_db
	mkdir -p $(HOME)/data/wordpress_files

.PHONY: all re down clean logs docker-up docker-check