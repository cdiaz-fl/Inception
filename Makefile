name = inception
all:
	@printf "Launching ${name}...\n"
	@bash srcs/requirements/wordpress/tools/make_dir.sh
	@docker-compose -f ./srcs/docker-compose.yml --env-file srcs/.env up -d

bonus:
	@printf "Launching Bonus ${name}...\n"
	@bash srcs/requirements/wordpress/tools/make_dir.sh
	@docker-compose -f ./srcs/requirements/bonus/docker-compose.yml --env-file ./srcs/requirements/bonus/.env up -d

build:
	@printf "Building ${name}...\n"
	@docker-compose -f ./srcs/docker-compose.yml --env-file srcs/.env up -d --build

build_bonus:
	@printf "Building Bonus ${name}...\n"
	@docker-compose -f ./srcs/requirements/bonus/docker-compose.yml --env-file srcs/requirements/bonus/	.env up -d --build

down:
	@printf "Stopping ${name}...\n"
	@docker-compose -f ./srcs/docker-compose.yml --env-file srcs/.env down

bonus_down:
	@printf "Stopping Bonus ${name}...\n"
	@docker-compose -f ./srcs/requirements/bonus/docker-compose.yml --env-file ./srcs/requirements/bonus/.env down

re:	fclean build
#@docker-compose -f ./srcs/docker-compose.yml --env-file srcs/.env up -d --build

clean: down
	bonus_down
	@printf "Cleaning ${name}...\n"
	@docker system prune -a
	@sudo rm -rf ~/data/wordpress/*
	@sudo rm -rf ~/data/mariadb/*

fclean: 
	@printf "Cleaning all...\n"
	@docker stop $$(docker ps -qa)
	@docker-compose -f ./srcs/docker-compose.yml down -v --remove-orphans --rmi all
	@docker-compose -f ./srcs/requirements/bonus/docker-compose.yml down -v --remove-orphans --rmi all
	@docker system prune --all --force --volumes
	@docker network prune --force
	@docker volume prune --force
	@sudo rm -rf ~/data/wordpress/*
	@sudo rm -rf ~/data/mariadb/*

.PHONY	: all build down re clean fclean bonus bonus_down build_bonus
