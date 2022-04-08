./byfn.sh down -Y

docker rm -f $(docker ps -aq)

docker volume prune -f

docker network prune -f