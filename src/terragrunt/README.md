

### Add new environment(deployment instance).

1. Set prerequisites

Replace `ENVIRONMENT_SHORT_NAME` variable value with environment name you going to create.

```bash
export ENVIRONMENT_SHORT_NAME=poc
export GITHUB_RUNNER_PAT=***
export TERRAGRUNT_PROVIDER_CACHE=1
git checkout -b feature/add-${ENVIRONMENT_SHORT_NAME}-environment
```

2. Create variable file

```bash
cd configuration
touch ${ENVIRONMENT_SHORT_NAME}.tfvars
cd ..
```

3. Create terraform backend storage

```bash

cd src/terragrunt/tfstate/naming
terragrunt apply -auto-approve
cd ../tfstate
terragrunt apply -auto-approve -var create_all=true
```

4. Deploy `base` layer

```bash
cd ../../base
terragrunt run-all apply -auto-approve
```

5. Commit changes to repositotory

```bash
git add .
git commit -m "Add new ${ENVIRONMENT_SHORT_NAME} environment"
git push origin HEAD
```

6. Create pull request and merge to main branch.

7. Add GitHub environment

### Delete environment(deployment instance).