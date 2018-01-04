# Azure

* Can we run an "azure-like" environment on-prem?
  * Yes, Service Fabric.


## Getting started

[Azure Developer Guide](https://opbuildstorageprod.blob.core.windows.net/output-pdf-files/en-us/guides/azure-developer-guide.pdf)

* How are you going to host your application?
  * Virtual Machines : Self-managed
  * Service Fabric
  * App Service
  * Functions (code only (serverless))

### App hosting

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
