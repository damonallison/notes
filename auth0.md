# Auth0

Auth0 abstracts user authentication.

## Questions

* What is the difference between an `access_token` and `id_token`?

* Write a proof of concept .NET API which accepts Auth0 tokens, including scopes (permissions).

## Guidance

* Everything must be `OIDC` conformant.
* All clients should use `RS256` (PKI based token decryption).
* Auth0 ships platform APIs (js, .net, ios, etc.), however you can use Auth0 with simple HTTP. If you are building all of your authentication API custom, you have to interact with the API directly.


## Terminology

* Connection : a method used to authenticate users.
  * Custom credentials (database, text file, anything custom)
  * Social network logins (facebook, google, twitter)
  * Enterprise directory stores (AD, Google Apps, SAML-P, WS-Federation)
  * Passwordless (Touch ID, SMS, Email codes)

* Hooks : ability to customize behavior of Auth0 by executing node.js scripts on an action.

* Extensions : allow you to install / run applications which extend Auth0.

## Clients

* Native. Used for mobile, desktop, or hybrid apps. They run natively on device.
* SPA.
* Regular web application.
* Non Interactive Client. Used for server -> server communication like CLIs, daemons.

### Client Types

* Confidential. Confidential clients are able to hold credentials (client ID and secret) in a secure way. Confidential clients require client ID and secret to authenticate.

* Public. Cannot hold credentials securely. These include native desktop or mobile applications and web applications.

### Client Grant Types

* Each client can specify which grant types it allows. (Configure the client using the `grant-types` property.)


## APIs

An API is an entity that represents an external resource (data), capable of accepting and responding to client requests.

When accessing an API (resource server), the client must provide an access token.

Each API has a set of permissions. Clients can request a subset of those permissions when authorizing, and include them in the access token as part of the `scope` request parameter.

* An API is a `resource server` in the `OAuth2` spec.

## OIDC Conformance
