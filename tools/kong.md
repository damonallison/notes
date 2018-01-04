# Kong

Kong is API middleware. It allows you to add middleware to your API layer by adding plugins written in LUA. Client requests are extended (via Kong plugins) and proxied to the final API.

Client <-> Kong <-> API


## Kong Environment

* `[dev|int|trn]kong.chrobinson.com:8001`

* Plugins in use
    * `correlation-id`
    * `jwt`
    * `tcp-log`
    * `http-log`

* Do we use the kong `consumer` concept at all?

* What tools do we use to manage our kong instance?
* Who manages kong? CRUDs APIs?

* Do we have customers setup as consumers in kong?
    * Tracking, access management, etc.


### Ports Used

* :8000 : http client listener, forwards traffic to your APIs.
* :8443 : https client listener, forwards traffic to your APIs.
* :8001 : http Admin API listener.
* :8444 : https Admin API listener.

* Note: Kong is based on nginx. All nginx monitoring tools can be used.

### Plugins used

* `tcp-log`
* `jwt`
* `tcp-log`
* `http-log`

### Kong Examples

```

# Run a cassandra container
$ docker run -d --name kong-database -p 9042:9042 cassandra:3

# Migrate the cassandra DB
docker run --rm \
    --link kong-database:kong-database \
    -e "KONG_DATABASE=cassandra" \
    -e "KONG_PG_HOST=kong-database" \
    -e "KONG_CASSANDRA_CONTACT_POINTS=kong-database" \
    kong kong migrations up

# Run a kong container.
docker run -d --name kong \
    --link kong-database:kong-database \
    -e "KONG_DATABASE=cassandra" \
    -e "KONG_PG_HOST=kong-database" \
    -e "KONG_CASSANDRA_CONTACT_POINTS=kong-database" \
    -p 8000:8000 \
    -p 8443:8443 \
    -p 8001:8001 \
    -p 8444:8444 \
    kong

# Add an API to kong
$ curl -i -X POST \
  --url http://localhost:8001/apis/ \
  --data 'name=example-api' \
  --data 'hosts=example.com' \
  --data 'upstream_url=http://mockbin.org'

# Verify the API has been created
$ curl -i -X GET \
  --url http://localhost:8000/ \
  --header 'Host: example.com'

# Add key auth to example-api
curl -i -X POST \
  --url http://localhost:8001/apis/example-api/plugins/ \
  --data 'name=key-auth'


# Add a consumer (user)
# Consumers allow you to track, provide access management, etc, for a user.
curl -i -X POST \
  --url http://localhost:8001/consumers/ \
  --data "username=damon"

# Create an API key for our user.
curl -i -X POST \
  --url http://localhost:8001/consumers/damon/key-auth/ \
  --data 'key=allison'

# Verify API key
curl -i -X GET \
  --url http://localhost:8000 \
  --header "Host: example.com" \
  --header "apikey: ENTER_KEY_HERE"

```
