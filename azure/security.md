# Security

* What is `audience` for?

## OAuth 2.0

* Scoped access tokens
* Flows
    * Authorization Code (SPAs)
        * https://www.oauth.com/oauth2-servers/single-page-apps/
    * Password (username / password)
      * Only for 1st party apps. Prefer Authorization Code
    * Client credentials

## OIDC

* Extends OAuth 2.0 w/ authentication and SSO

* `id_token`
* `access_token`

## Okta

* Server-to-server authentication has two options
  * HTTP basic auth (don't use)
  * OAuth 2.0 client credentials


## OAuth 2.0 - Client Credentials

* Client send API credentials --> clientId / secret --> auth server
* Client <-- access token <-- auth server


## Token

```json
{
    "access_token": "token",
    "expires_in": 1234243,

}
```