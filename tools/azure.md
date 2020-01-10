# Azure

* Docker / ACS / AKS / Azure Functions / helm
* Azure SQL / Cosmos DB (w/ Mongo DB drivers)
* Key vault
* DevOps (TFS / work tracking)

* Networking / firewall / dns / vpn / traffic manager



* Terraform - infrastructure as code

* Microservices architecture
    * Docker -> ACR -> AKS -> Azure SQL / Cosmos / Elastic
    * API gateway (ingress)

    * Key Vault
    * Helm

* Data
    * Do *not* store w/ container
    * Azure SQL / Cosmos DB
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
    * Packages multiple k8s objects into a single chart
    *

* Docker / ACR
* CosmosDB (Mongo)
* Azure SQL
* Terraform


## Command Line

### .NET

```bash

# Local version information
$ dotnet info

# List of available templates
$ dotnet new --list

# Create a new console application.
$ dotnet new console --name [project-name]

# Add a nuget package
$ dotnet add package MongoDB.Driver
```

## Needs

* Security - Auth0 OK?
* Networking / VPN
* Application hosting model. Containers vs. PaaS
* Storage
  * MongoDB (Cosmos)
  * Elastic (Azure Search)
  * File System (Azure Blob Storage?)
  * SQL (Azure SQL)
* Monitoring: App Insights / Azure Monitor (portal? logs?)
* CI / CD
* DR / multi-region (Azure Traffic Manager)
* `az` CLI
* Billing : How to partition into `Resource Groups`? (Azure Resource Manager)
  * Provision `Resource Groups` via JSON (infra as code)
  * User definition, RBAC.
  * Use tags for billing?

## TODO

* A common subscription all vision developers have full access to. Personal dev accounts won't scale.

* API running in `App Service`. Difference between App Service and hosting via AKS or Service Fabric?
  * Look into using Docker images on App Service.
* Run an Azure function. Put rules engine into Azure Functions?
* Service Fabric: .NET Core and Java only?

## Vision

* How to partition by customer? What to share between tenants?
  * MongoDB - by tenant. Metadata - across tenants.

## Getting started

* [Azure Developer Guide](https://docs.microsoft.com/en-us/azure/guides/developer/azure-developer-guide)

### App hosting

```plain

VM -> Service Fabric -> App Service -> Functions (Code Only)

-- IaaS --------- PaaS -------------------- Serverless ------->

```

#### App Service

* App / API hosting.
* Auto-scaling.
* Quick to develop.
* Continuous, container based deployments.

New Apps in app service can be of type:

* Web Apps : sites / web apps
* Mobile Apps : Web Apps w/ extra support for authentications and push notifications.
* API Apps : for API hosting (w/ swagger metadata)

#### Service Fabric

* Infrastructure for hosting, scaling, deploying, versioning, managing microservices.
* Supports WebAPI / OWIN / ASP.NET Core

### Azure Services

* Azure SQL Database
* Azure Storage - blob
* Azure DocumentDB - non-relational NoSQL (json documents). SQL queries over object data.

### Docker Support

* Docker provides efficient, predictable deployment. The unit of deployment is
  the coarse grained container, not individual files or executables.
* Azure Container Service allows you to manage / configure a cluster of VMs.

### Authentication

* Azure AD
* App Service hosts get built-in support for Azure AD, Twitter, Facebook.

### Monitoring

* Application Insights
* Azure Monitoring (graphing)

### Azure Management

* Azure CLI
* Azure Powershell
* Azure Portal : web based interface
* REST APIs
* Azure SDKs

## CosmosDB

* The next generation of Azure DocumentDB.
* A schemaless DB which natively supports multiple data models
  * document, key-value, graph, table and columnar data models.
* Access the data using NoSQL APIs of your choice.
  * MongoDB (document)
  * Azure Table Storage (key value)

## Azure Functions

* Event driven, on demand
    * Triggers
        * cron schedule
        * Azure queues / service bus messages
        * HTTP (web hook listener)
