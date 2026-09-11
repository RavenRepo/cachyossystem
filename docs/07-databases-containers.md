# 07 — Databases and containers

## PostgreSQL

Keep the database local by default.

```bash
systemctl status postgresql --no-pager
sudo ss -lntp | grep postgres
```

## Podman

Prefer rootless containers.

```bash
podman info
podman run --rm docker.io/library/hello-world
```

Audit published ports before adding UFW rules.
