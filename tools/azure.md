# Azure

* C# API (CRUD + Search)
    * Docker / AKS / Scaling
    * Cosmos (using Mongo)
    * Security
    * Logging / Monitoring

## Done

* KeyVault
* Functions
* Docker ACR / AKS

## Plan

* Compute
    * Docker
    * Kubernetes
    * Functions

* Data
    * Do *not* store w/ container
    * Azure SQL
    * Cosmos DB (MongoDB drivers)
    * Azure Disks / Files (Files if the same volume needs to be shared by multiple pods

* AKS
    * k8s managed service
        * Load balancing
    * Horizontal Pod Autoscaler (HPA) - autoscales nodes based on pod specs
    * Warning: You can't change the VM size after you build the cluster
    * Availability
        * Readiness probes: ready?
        * Liveness probes: working?

* CI/CD
    * Define tag standards: tag naming conventions, versioning strategy
    * Quality gates @ each stage
    * Containerized builds - allows dev to run builds on machine
    * Helm
        * Packages multiple k8s objects into a single chart. Deploy charts.

* Infrastructure
    * Terraform - infrastructure as code
    * Networking / firewall / dns / vpn / traffic manager

* Security
    * Key Vault
    * IAM / RBAC
    * SSO / OAuth

## Principles

* Immutable infrastructure as code
* Loose coupling / message passing
* Use NoSQL / documents if you don't need complex joins / transactions
* Health checks / auto failover
* Failover: multi-region / availability zones w/in region
* Security: defense in depth. Network / SSO / MFA / RBAC

---

## CosmosDB

* The next generation of Azure DocumentDB.
* A schemaless DB which natively supports multiple data models
  * document, key-value, graph, table and columnar data models.
* Access the data using NoSQL APIs of your choice.
  * MongoDB (document)
  * Azure Table Storage (key value)

## Azure Functions

* Use functions for simple APIs / responding to events / cron

* Event driven, on demand
    * Triggers
        * cron schedule
        * Azure queues / service bus messages
        * HTTP (web hook listener)

* Service integrations can trigger a function or serve as input / output
    * Cosmos / Service Bus (Queues)

## Azure Pipelines

* Stages (Build / Test / Deploy) -> Jobs (Build, PushToRegistry) -> Steps ->
  Tasks
* Jobs are the smallest unit of work that gets distributed to an agent
* Approvals: Reources (environments) can require approvals
* Gates: Requirements that must be met before / after deployment (i.e., no
  incidents reported before promoting the release))
* Deployment rings: Ability to control (via approvals) to a larger group of users
* Full API for controlling Azure DevOps

## Key Vault

* Securely store secrets. Access from app via a versioned URI.
* Each application can have access to it's own vault.
* To access a key vault from an application:
    * Create a service principal (clientId / clientSecret).
    * Give the service principal access to the key vault.
    * Use the service principal from code to obtain secrets.


## C#

### 7.0

### 8.0

* Nullable reference types
* Records
* Default reference implementation


## .NET

* TPL
    * `Parallel.For`: Simple concurrency
    * Tasks can have continuations (`ContinueWith`)
    * Tasks can have children (`AttachedToParent`)
    * Convenience functions
        * `WhenAll` - execute a `Task` when all tasks are complete
        * `WhenAny` - execute a `Task` when *one* of many tasks complete
        * `Delay` - task that returns after a delay
        * `FromResult` - returns a task from a known value
---     *
```shell

# Build the application
dotnet publish -c Release

# Build a docker image
docker build -t customer-api:v1 .

# Run a docker container
# Exposes container port 80 on the host's port 5000.
# http://localhost:5000/customer
docker run -it --rm -p 5000:80 customer-api:v1

# Tag/push the container to Azure Container Registry (ACR)
docker tag customer-api:v1 damon.azurecr.io/customer-api:v1
docker push damon.azurecr.io/customer-api:v1

# Apply k8s manifest (deploy)
kubectl apply -f customer-api-k8s.yaml

# View k8s resources
kubectl get all


---

#
# Resource naming: alphanumeric + hypen.
# Be descriptive, include entity (rg == resource group)
#
# damon-prod-rg
#
# Azure hierarchy
#
# Subscription
#  Resource Groups
#    Resources

az account --list-locations -o table
az group create --name damon-rg --location eastus

# damon.azurecr.io
az acr create -g damon-rg --name damon --sku Basic
az acr login --name damon

# Tag image for ACR

# View images in ACR
az acr repository list --name damon

# See tags for image (v1)
az acr repository show-tags --name damon --repository azure-vote-front --output table

#
# Adds AKS credentials to local kubectl config
#
az aks get-credentials -g damon-rg --name damon-aks

# Verify kubectl is hooked up correctly
kubectl get nodes

# Watch a service for changes (external ip)
kubectl get service azure-vote-front --watch

# Provision pods / services in AKS

```

## Links

* [Azure Developer Guide](https://docs.microsoft.com/en-us/azure/guides/developer/azure-developer-guide)
