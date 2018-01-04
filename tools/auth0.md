# Auth0

## Token Retrieval

* [Dev](https://test-sso.chrobinson.com/oauth/token)
* [Int](https://test-sso-int.chrobinson.com/oauth/token)
* [Trn](https://app-training-auth.chrobinson.com/oauth/token)
* [Prod](https://app-auth.chrobinson.com/oauth/token)

## Auth0 Management

* [Non-prod](https://test-auth0-manage.chrobinson.com/#/)
* [Prod](https://manage-auth.chrobinson.com/#/)

## Auth0 Tenants

* test-sso = development
* test-sso-int = integration
* app-training-auth = training
* app-auth = prod

## Auth0

### Clients

Each client represents an application. Each client type specifies a different workflow.

#### Client Settings

* Client ID : The unique client identifier. Clients use this when authenticating.
* Client Secret : A string used to validate `id_token` for authentication. Client secret is used in our `NavisphereCarrier.Framework` to validate JWT tokens (i.e., `id_token`s).
* Allowed Callback URLs: The set of URLs which Auth0 is allowed to redirect the user back to. This is a comma separated value, and can contain wildcards. Make sure to specify `http` or `https`
  * Example `https://*.google.com,https://*.chrobinson.com`
* JWT Expiration (in seconds): Defaults to `36000` or 10 hours.

### Connections

Connections are sources of users. Connections can be custom databases, 3rd party systems (Facebook, Google), or "Enterprise" (i.e., AD)

### OIDC

Any new Auth0 features, examples and documentation moving forward will target only the OIDC-conformant pipeline. All Auth0 SDK versions that depend on the legacy pipeline are deprecated and will not receive updates for new features or non-critical security issues, and will eventually be discontinued.


#### Questions

* What are `client_credentials`?

* What is the difference between `id_token` and `access_token`? When to use which?

* `id_token` contains a list of claims. We use the claims to both validate the token and determine the user associated with the token.
  * `id_token` was added to the Open ID Connect spec (OIDC) to allow the client to know the identity of the user.

* `scope` controls which attributes are returned in the `id_token`
  * If `scope` == `openid`, `id_token` will contain only `iss, sub, aud, exp, iat` claims.

```
{
  // The issuer.
  "iss": "https://test-sso.chrobinson.com/",

  // The unique identity of the user. In the format "provider|ID".
  /// In this example, "auth0" is the provider and the userId == 168.
  // Examples of other providers include facebook, google, twitter, etc.
  "sub": "auth0|168",

  // The "audience". For us, the audience is the client id.
  "aud": "PpSSObHwgurIqWW01UenSRQyBG8GSEI6",

  // Expiration time.
  "exp": 1497974068,

  // Issued at time.
  "iat": 1497973948
}
```  

### Auth0 Endpoints

* `Authorization` endpoint.
  * `response_type` - tells the server what type of grant to execute.
    * `response_type=code` : The response returns an authorization code which can later be exchanged for an access token.
    * `response_type=token` : The response will include an access token.
    * `response_type=id_token token` : Returns access *and* `id_token`.

* `Token` endpoint.
  * Used by the clidnt to get an access token or refresh token.

### Refresh

* For refresh, you could perform another authorization flow (which would require the user's password).

* You can ask for a refresh token by adding `offline_access` to the scope of the initial authorization flow. This will
  return a refresh token, which can be stored in session. The app can use `refresh_token` to
  obtain a new `id_token` using `/oauth/token` with `grant_type=refresh_token`
  * `scope = "openid offline_access"`



## JWT

* JWTs are a compact, *usually* digitally signed, JSON set of "claims" about a user. A claim is simply a name / value pair. You typically use claims to convey information about a user.
* JWTs can be embedded within a JWT (what for? nested claims passing between different servers - like a relay?)

```
{
  "isAdmin" : true,
  "user_type" : "carrier"
}
```

* The suggested pronunciation of JWT is the same as the English word "jot".

* JWTs are broken into *usually* 3 parts (only 2 parts if signed):
  * Header. Token type (`JWT`) and encryption algorithm used.
  * Claims. A set of name/value pairs.

* JTWs are smaller and less complex than SAML


# iOS

com.chrobinson.auth0sample://test-sso.chrobinson.com/ios/com.chrobinson.auth0sample/callback
