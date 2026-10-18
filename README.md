
# Aspire

A devcontainer feature that installs the Aspire CLI and configures VS Code extensions and port forwarding.

See the [feature documentation](src/aspire/README.md) for usage and the `installCli` option.

## Local testing

With Docker running, test the feature directly from this checkout:

```sh
npx --yes @devcontainers/cli features test -f aspire --skip-duplicated -i ubuntu:24.04 .
```

This tests the default stable installation on Ubuntu and builds devcontainers for daily and CLI-disabled scenarios. The stable and daily tests verify that `aspire` resolves to `/usr/local/bin/aspire` and runs in a fresh shell without profile scripts, including as a non-root user.

Inside a devcontainer, check the installation with `command -v aspire` and `aspire --version`. Rebuild the devcontainer after changing feature options.