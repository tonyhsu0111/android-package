#CreateName="2019/12/24"
#MAINTAINER="Tony Hsu"
GETIP=$(shell ip addr| grep en | grep inet |sed "s/\/.*//" |cut -c 10-23)

SOURCE_PATH=$(PWD)

help:
	@echo ""
	@echo ""
	@echo "-- Help Menu"
	@echo ""
	@echo "   1. make build        - build container"
	@echo "   2. make run          - start container"
	@echo "   3. make rm           - rm container"
	@echo "   4. make logs         - view logs"
	@echo "   5. make clean        - remove image and unused docker data"
	@echo "   6. make restart      - restart container"	


.PHONY:build
build:
	@echo "Build Docker"
	@docker-compose -f docker-compose.yml build --force-rm


logs:
	@docker-compose logs --tail 25 -f 

rm:
	@echo "remove Docker"
	@docker-compose -f docker-compose.yml down

run:
	@echo "RUN Docker"
	@docker-compose -f docker-compose.yml down
	@docker-compose -f docker-compose.yml up -d

clean:
	@echo "Remove image Docker"
	@docker-compose -f docker-compose.yml  down --rmi all
	@docker system prune -f

restart:
	@echo "RESTART Docker"
	@docker-compose restart

