all:
	# mkdir -p /home/bghandri/data/mariadb
	# mkdir -p /home/bghandri/data/wordpress
	mkdir -p /Users/bilelgh/INCEPTION/data/mariadb
	mkdir -p /Users/bilelgh/INCEPTION/data/wordpress
	chmod 777 /Users/bilelgh/INCEPTION/data/mariadb
	chmod 777 /Users/bilelgh/INCEPTION/data/wordpress
	docker-compose -f ./srcs/docker-compose.yml build
	docker-compose -f ./srcs/docker-compose.yml up -d

logs:
	docker logs wordpress
	docker logs mariadb
	docker logs nginx

clean:
	docker container stop nginx mariadb wordpress
	docker network rm inception

fclean: clean
	# @sudo rm -rf /home/bghandri/data/mariadb/*
	# @sudo rm -rf /home/bghandri/data/wordpress/*
	@sudo rm -rf /Users/bilelgh/INCEPTION/data/mariadb/*
	@sudo rm -rf /Users/bilelgh/INCEPTION/data/wordpress/*
	@docker system prune -af

re: fclean all

.Phony: all logs clean fclean
