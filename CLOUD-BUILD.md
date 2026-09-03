# Orchard Linux cloud build

The permanent workflow file is:

```text
.github/workflows/build-iso.yml
```

It builds the ISO inside a Debian 13 container on GitHub-hosted infrastructure.

The artifact name never changes:

```text
orchard-linux-amd64
```

The artifact contains:

```text
orchard-linux-amd64.iso
orchard-linux-amd64.iso.sha256
```
