

### Add new environment(deployment instance).

1. Set prerequisites

Replace `ENVIRONMENT` variable value with environment name you going to create.

```bash
export ENVIRONMENT=poc
export GITHUB_RUNNER_PAT=***
export TERRAGRUNT_PROVIDER_CACHE=1
git checkout -b feature/add-${ENVIRONMENT}-environment
```

2. Create variable file

```bash
cd configuration
touch ${ENVIRONMENT}.tfvars
cd ..
```

3. Create terraform backend storage

```bash
cd src/terragrunt/tfstate/naming
terragrunt apply -auto-approve
cd ../tfstate
terragrunt apply -auto-approve -var create_all=true

cd src/terragrunt/tfstate
terragrunt run-all apply -auto-approve -var create_all=true
```

4. Deploy `base` layer

```bash
cd ../../base
terragrunt run-all apply -auto-approve
```

5. Deploy `github` layer

```bash
cd ../../github
terragrunt run-all apply -auto-approve
```

6. Commit changes to repositotory

```bash
git add .
git commit -m "Add new ${ENVIRONMENT} environment"
git push origin HEAD
```

7. Create pull request and merge to main branch.

8. Add GitHub environment

### Delete environment(deployment instance).