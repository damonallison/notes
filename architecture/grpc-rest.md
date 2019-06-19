# REST and gRPC

## REST / JSON

* Ubiquitous
  * Default API format
  * Language / library support
  * Simple / human readable

* Well supported ecosystem
  * Authentication
  * Caching
  * Proxying
  * Scaling
  * Tooling (postman, chrome)

* Industry support
  * Google - QUIC

* Verbose
  * HTTP is not efficient

* When to use
  * Customer / partner facing APIs
  * Web APIs
* Working w/ JS tooling (mongo, S3)
  *

## gRPC / Protocol Buffers (Avro / Thrift)

* Performance
  * Protocol buffers (or Avro / Thrift) are compact, deserialization is fast
  * Some studies show large perf gains, expecially for non-JS environments where
    JSON serialization and deserialization have to happen on both sides (Java ->
    Java)
      * https://auth0.com/blog/beating-json-performance-with-protobuf/

* Strong typing
  * Services and data structures both strongly typed

* Tooling support
  * *Most* languages support gRPC
  * Extra build / compilation step required

* When to use
  * When performance is a concern
    * High volume, internal systems.
  *

* What to watch out for
  * Somewhat of a niche - resources are not as plentiful
  * Some languages require 3rd party libraries, potentially of varying quality
  * Messages are not human readable. Debugging can be a bit tricker,.
    * Can't read thru an example request.