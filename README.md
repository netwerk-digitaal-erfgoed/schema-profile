# Schema.org Application Profile (SCHEMA-AP)

This is the source code for the public document available at https://docs.nde.nl/schema-profile/.

To build the spec:

```shell
make spec
```

The build, the NDE logo and the house style come from
[spec-boilerplate](https://github.com/netwerk-digitaal-erfgoed/workflows/tree/main/spec-boilerplate),
at the version of the shared workflow that `.github/workflows` calls.
The first `make spec` downloads that version into `.nde/`; it needs curl, tar, npm and Docker.
`make update` downloads it again.

To validate the [examples](examples/) against the [SHACL shape](shacl.ttl):

```shell
make validate
```
