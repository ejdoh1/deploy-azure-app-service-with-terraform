# Deploy an Azure App Service app with Terraform

## Sample dotnet application

The following commands were used to create and locally test the sample dotnet application (./app).

```sh
mkdir app
cd app
dotnet new webapi -f netcoreapp3.1
dotnet build
dotnet run
curl --silent --insecure https://localhost:5001/weatherforecast | jq
```

## Setup

Run `az account show` and if you're not logged in then run `az login`.

## Steps

```sh
make build
make deploy
make test
make destroy
```
