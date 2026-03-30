# al-codespace-rewards

Demo: **Business Central AL extension development using GitHub Codespaces** — zero local installation.

> **Fork this repo first, then open a Codespace from your fork.**
> Creating a Codespace directly from this repo means you cannot push changes back.

> **Note:** This is a demonstration repository — published to show what's possible with GitHub Codespaces for Business Central AL development, without any local tooling. It reflects how I explore and test this workflow in my own practice. Use it as a starting point and adapt to your own project and sandbox setup.

---

## Inspiration

This repo is inspired by Tobias Fenster's article
**[Using MCPs with GitHub Copilot without installing anything locally](https://tobiasfenster.io/using-mcps-with-github-copilot-without-installing-anything-locally)** (Mar 2026),
which demonstrates the Codespaces + MCP pattern for Business Central using Azure DevOps work items and the AL Symbols MCP server.

This repo adapts that same approach specifically for **AL extension development** with a BC Online sandbox as the runtime target, and adds `SShadowSdk.al-lsp-for-agents` as a Copilot agent mode extension on top.

---

## Why this exists

When testing a Per-Tenant Extension (PTE) against a BC Online sandbox, the usual friction is setup time — getting a local environment, configuring the AL extension, pointing it at the right tenant. That overhead gets in the way of what you actually want: a quick, functional AL demo you can publish and verify in minutes.

This repo exists to remove that friction. It is a small but complete PTE — real tables, pages, logic, and tests — that you can fork, open in a Codespace, and publish to your own sandbox without touching your local machine. It serves two purposes: a personal sandbox for fast iteration, and something concrete to share with others who want to try the same workflow.

---

## What is a Codespace?

A **GitHub Codespace** is a cloud-hosted VS Code environment that runs entirely in your browser.
Forking and opening this repo in a Codespace provisions the complete AL toolchain automatically — AL Language extension, GitHub Copilot, Copilot Chat, PowerShell, Node.js — with no local configuration required.

---

## Architecture

| Component | Purpose |
|---|---|
| GitHub Codespace | Editor, AL tooling, Copilot, MCP servers, source control |
| BC Online Sandbox | Runtime — publish, debug, test |

No Docker. No Windows machine. No local VS Code install.

---

## Quickstart

1. **Fork** this repo (top-right Fork button)
2. In your fork → **Code** → **Codespaces** → **Create codespace on main**
3. Wait ~2 min for the container to build
4. Edit `.vscode/launch.json` — set your sandbox name and tenant ID
5. Sign in to your Microsoft tenant when the AL extension prompts you
6. `Ctrl+Shift+P` → **AL: Download Symbols**
7. `F5` → publishes the extension to your BC Online sandbox

---

## launch.json — your values go here

```json
{
  "version": "0.2.0",
  "configurations": [
    {
      "name": "BC Online Sandbox",
      "type": "al",
      "request": "launch",
      "server": "https://businesscentral.dynamics.com",
      "serverInstance": "sandbox",
      "authentication": "AAD",
      "environmentType": "Sandbox",
      "environmentName": "YOUR_SANDBOX_NAME",
      "tenant": "YOUR_TENANT_ID_OR_DOMAIN",
      "startupObjectType": "Page",
      "startupObjectId": 22,
      "schemaUpdateMode": "Synchronize"
    }
  ]
}
```

---

## Copilot agent mode + MCP

Once symbols are downloaded, open `.vscode/mcp.json` in the editor — a **Start** link appears above each server entry. Click it to activate.

Switch Copilot Chat to **Agent mode** and query your actual BC symbol packages:

```text
Show all fields on table 50000 MBS Reward.
Which objects in this workspace reference the Customer table?
Suggest how to extend Customer Card to display the reward level.
```

`SShadowSdk.al-lsp-for-agents` is pre-installed via `devcontainer.json` and contributes additional tools to agent mode: go-to-definition, find references, call hierarchy, and rename — no extra setup needed.

---

## About the AL extension

The extension — **MBS Rewards Simple** — is a Customer Rewards feature built on the official Microsoft AL example:

> [Building your first sample extension — Microsoft Learn](https://learn.microsoft.com/en-us/dynamics365/business-central/dev-itpro/developer/devenv-extension-example)

It assigns reward levels (Gold, Silver, Bronze) to customers based on configurable discount percentages and minimum purchase thresholds.

| Object type | Description |
|---|---|
| `Table 50000` | Reward levels with discount % and min. purchase |
| `TableExtension` | Adds Reward ID field to the standard Customer table |
| `Page` + `PageExtension` | Reward List, Reward Card, Customer Card extension |
| `Codeunit` | Reward assignment logic |
| `PermissionSet` | Access control for extension objects |
| `Tests` | AL test codeunits |

**ID range:** 50000–50099 · **Publisher:** MBS · **Target:** Cloud · **Runtime:** 16.0

---

## Requirements

- GitHub account with Codespaces access (GitHub Pro or above)
- Microsoft 365 / Dynamics 365 Business Central tenant with a Sandbox environment

---

## See it in action

![Codespace with BC extension published](https://github.com/mbaic/al-codespace-ms-rewards/blob/main/docs/images/al-codespace-demo.jpg)

---

## License

This project is licensed under the MIT License — see the [LICENSE](LICENSE) file for details.
