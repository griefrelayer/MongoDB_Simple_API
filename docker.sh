#!/bin/bash

StartContainers() {
  docker build -t api .

  docker run --expose=27017 --name mongodb -d mongo

  MONGO_IP=$(docker network inspect bridge | awk ' /'mongodb'/ {getline;getline;getline;print}' - | grep -oE '((1?[0-9][0-9]?|2[0-4][0-9]|25[0-5])\.){3}(1?[0-9][0-9]?|2[0-4][0-9]|25[0-5])' -)

  docker run --name=api --env MONGO_DB_IP="$MONGO_IP" -p 8000:8000 -d api
}

StopContainers() {
  docker stop mongodb api
}

RestartContainers() {
  docker restart mongodb api
}

DeleteContainers() {
  docker rm -f mongodb api
}

TestAPI() {
  docker exec api pytest
}

Help() {
  # shellcheck disable=SC1073
  cat <<EOF
    Help
  Usage:
    ./docker.sh up  to start containers
    ./docker.sh down  to stop containers
    ./docker.sh restart  to restart containers
    ./docker.sh delete  to delete containers
    ./docker.sh testapi to run pytest with api tests in "api" container (works only if it's running)
    ./docker.sh help  to show help
EOF
}

ARG1=$1
case $ARG1 in
  help)
    Help
    ;;
  up)
    StartContainers
    ;;
  down)
    StopContainers
    ;;
  restart)
    RestartContainers
    ;;
  delete)
    DeleteContainers
    ;;
  testapi)
    TestAPI
    ;;
  *)
    Help
    ;;
esac