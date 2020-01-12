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

* Infrastructure as code
* Loose coupling / message passing
* Use NoSQL / documents if you don't need complex joins / transactions
* Health checks / auto failover
* Failover: multi-region / availability zones w/in region
* Security: defense in depth. Network / SSO / MFA / RBAC

---

## Getting started

* [Azure Developer Guide](https://docs.microsoft.com/en-us/azure/guides/developer/azure-developer-guide)

#### App Service

* App / API hosting.
* Auto-scaling.
* Quick to develop.
* Continuous, container based deployments.

New Apps in app service can be of type:

* Web Apps : sites / web apps
* Mobile Apps : Web Apps w/ extra support for authentications and push notifications.
* API Apps : for API hosting (w/ swagger metadata)

### Docker Support

* Docker provides efficient, predictable deployment. The unit of deployment is
  the coarse grained container, not individual files or executables.

### Authentication

* Azure AD
* App Service hosts get built-in support for Azure AD, Twitter, Facebook.

### Monitoring

* Application Insights
* Azure Monitoring (graphing)

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

## Key Vault

* Securely store secrets. Access from app via a versioned URI.
* Each application can have access to it's own vault.
* To access a key vault from an application:
    * Create a service principal (clientId / clientSecret).
    * Give the service principal access to the key vault.
    * Use the service principal from code to obtain secrets.

---
```shell

#
# Resource naming: alphanumeric + hypen. Be descriptive, include entity (rg == resource group)
#
# damonallison-prod-rg
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
az acr login --name

# Tag image for ACR
docker tag azure-vote-front damon.azurecr.io/azure-vote-front:v1
docker push damon.azurecr.io/azure-vote-front:v1

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
