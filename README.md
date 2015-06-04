dedupapi
=============

__Species occurrence deduplication API__

## Base URL

`http://comingsoon...`

## Developing

Run `thin start`, then hit http://localhost:3000

## The endpoints so far

* `/` (redirects to `/heartbeat`)
* `/heartbeat` (`GET`)
* `/dups` (`POST`)

## On the CLI

using [http](https://github.com/jakubroztocil/httpie) instead of curl

### heartbeat

```sh
http --follow localhost:3000
```

```
{
    "routes": [
        "/heartbeat (GET)",
        "/dups (POST)"
    ]
}
```

### post data

```sh
http localhost:3000/dups < test_notpretty.json
```
