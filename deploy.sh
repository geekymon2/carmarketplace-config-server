#! /bin/bash
source docker.properties

ENV=$1
KEY=$2

if [ -z "$ENV" ]
then
    echo 'Environment cannot be blank!'
    exit 0
fi

if [ -z "$KEY" ]
then 
    echo 'Key cannot be blank!'
    exit 0
fi

if [ -f "docker.properties" ]
then
    source docker.properties
else
    echo 'docker.properties not found!'
fi


echo "Starting Deployment for Image: $IMAGE_NAME."
echo "- Creating Environment Variables"
printf "ENVIRONMENT=$ENV\nSPRING_PROFILES_ACTIVE=$ENV\nCONFIG_SERVER_ENCRYPT_KEY=$KEY" >> .env
echo "- Loading Environment Variables"
if [ -f .env ]
then
  export $(cat .env | sed 's/#.*//g' | xargs)
fi
echo "- Stopping containers"
docker-compose -f "docker-compose.yml" stop
echo "- Pull the latest docker image"
docker pull "geekymon2/$IMAGE_NAME"
echo "- Starting Container"
docker-compose -f "docker-compose.yml" up -d
echo "- Deployment Complete."