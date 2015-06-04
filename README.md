dedupapi
=============

__Species occurrence deduplication API__

## Base URL

`http://comingsoon...`

## develop

Run `thin start`, then hit http://localhost:3000

## The endpoints so far

* `/heartbeat`
* `/dedup`

## On the CLI

<!-- using [http](https://github.com/jakubroztocil/httpie) instead of curl -->

### heartbeat

```sh
curl localhost:3000/heartbeat
```

### post data

```sh
curl -XPOST localhost:3000/dedup -d ''
```
