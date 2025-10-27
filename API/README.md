# Build and Run API

docker build -t efd-api .

docker network create efd-net

docker run -d --name efd-mongo --network efd-net -p 27017:27017 -e MONGO_INITDB_ROOT_USERNAME=root -e MONGO_INITDB_ROOT_PASSWORD=root mongo:7

docker run -d --name efd-api --network efd-net -p 3001:3000 -e MONGO_URI="mongodb://root:root@efd-mongo:27017/efd?authSource=admin" -e JWT_SECRET="super_secret" -e JWT_EXPIRES="7d" efd-api