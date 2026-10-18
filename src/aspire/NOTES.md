## Language-specific tooling

This feature installs the Aspire CLI and Aspire VS Code extension and configures port-forwarding settings. A separate .NET SDK is not required.

Additional editor extensions such as Bicep and GitHub Copilot are not installed by this feature. Configure them separately through VS Code or the consuming devcontainer configuration.

Language-specific SDKs and editor extensions should be selected by the consuming devcontainer configuration or template preset. Starting with feature version 3, this feature no longer automatically installs C# Dev Kit (`ms-dotnettools.csdevkit`). C# presets that need it should add it explicitly to `customizations.vscode.extensions`.

Set `installCli` to `false` to apply only the shared editor configuration without installing the Aspire CLI. Workloads that need additional SDKs or runtimes should configure those separately.
