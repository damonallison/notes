# Azure

## Credentials

AzureDemo12~%9

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

* Infrastructure for managing microservices.
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
*



## Service Fabric

* Infrastructure for hosting, scaling, deploying, versioning microservices.
* Stateful services (DB backed). Service Fabric can co-locate stateful services together
  (i.e., services that use the same DB).
