build: check-env
	dotnet build app/app.csproj /p:DeployOnBuild=true /p:DeployTarget=Package;CreatePackageOnPublish=true
	cd app/bin/Debug/netcoreapp3.1/Publish/ && zip -r ../../../app.zip .

deploy: check-env
	terraform -chdir=terraform init; \
	terraform -chdir=terraform apply -auto-approve

destroy: check-env
	terraform -chdir=terraform init; \
	terraform -chdir=terraform destroy -auto-approve

test: check-env
	curl --silent $$(terraform -chdir=terraform output --raw api_url) | jq

check-env:
	@for var in terraform az jq curl dotnet; do \
		if ! command -v $$var &> /dev/null; then \
			echo "$$var could not be found"; \
			exit 1; \
		fi; \
	done
