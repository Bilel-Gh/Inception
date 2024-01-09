all:
	mkdir -p /home/bghandri/data/mariadb
	mkdir -p /home/bghandri/data/wordpress
	chmod -R 777 /home/bghandri/data/mariadb
	chmod -R 777 /home/bghandri/data/wordpress
	docker-compose --verbose -f ./srcs/docker-compose.yml build
	docker-compose --verbose -f ./srcs/docker-compose.yml up -d

logs:
	docker logs wordpress
	docker logs mariadb
	docker logs nginx

clean:
	docker container stop nginx mariadb wordpress
	docker network rm inception

fclean: clean
	@sudo rm -rf /home/bghandri/data/mariadb/*
	@sudo rm -rf /home/bghandri/data/wordpress/*
	@docker system prune -af

re: fclean all

.Phony: all logs clean fclean
