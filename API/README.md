# Build and Run API

Docker Desktop is required

1. BUILD

```shell
docker build -t gas-station-api .
```

2. RUN ON PORT 3001 on your machine

```shell
docker run -d -p 3001:3000 gas-station-api
```