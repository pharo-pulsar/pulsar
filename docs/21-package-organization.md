# 21. Package Organization

Pulsar is organized into two package groups: the **Perspective** substrate and the **Pulsar** IDE packages.

## Package Groups

### Perspective (UI Substrate)

Loaded first. These packages provide the model layer, basic presenters, and the spotter.

| Package | Contains |
|---|---|
| `Perspective` | `PvBaseModel`, `PvEnvironmentModel`, `PvEnvironment`, action infrastructure, composite icons, base presenters |
| `Perspective-Spotter` | `PvViewEntry`, spotter base infrastructure |
| `Perspective-Project` | Project model concepts (largely superseded by Pulsar) |
| `Perspective-Package` | Package model concepts |
| `Perspective-Class` | `PvClassModel`, class hierarchy support |
| `Perspective-Method` | Method model concepts |

### Pulsar (IDE)

| Package | Contains |
|---|---|
| **`Pulsar-Browser`** | Core IDE: browser, editors, debugger, notifications, snapshots, actions, task scheduling, spotter, project system, updater |
| **`BaselineOfPulsar`** | Metacello baseline loading all Pulsar packages and dependencies |

### Pulsar Tool Packages

| Package | Tool |
|---|---|
| `Pulsar-Tool-Changes` | Epicea change browser (`PulsarChangesBrowser`) |
| `Pulsar-Tool-Repositories` | Iceberg Git repository browser (`PulsarRepositoryBrowser`) |
| `Pulsar-Tool-TestRunner` | Test runner integration (`PulsarTestRunnerBrowser`) |
| `Pulsar-Tool-FileEditor` | External file editor (`PulsarFileEditor`, `PulsarDirectoryBrowser`) |
| `Pulsar-Tool-ObjectExplorer` | Object inspector (`PulsarObjectExplorer`) |
| `Pulsar-Tool-CritiquesConsole` | Code critiques panel (`PulsarCritiquesConsole`) |
| `Pulsar-Tool-FlagsConsole` | Method/user/extension flags console (`PulsarFlagsConsole`) |
| `Pulsar-Tool-Roassal` | Roassal visualization |
| `Pulsar-Tool-LLM` | LLM chat/codex integration, MCP tools |
| `Pulsar-Tool-MorphicWorld` | Morphic world embedding |

### Test Package

| Package | Contains |
|---|---|
| `Pulsar-Browser-Tests` | Tests for core Pulsar browser functionality |

## Dependency Chain

```
External baselines
    ├── Adwaita (github://estebanlm/Spec-LibAdwaita:main)
    ├── Linden (github://estebanlm/linden)
    ├── Vte (github://estebanlm/Spec-VTE:main/src)
    └── MCP (github://estebanlm/MCP:main/src)

Pulsar packages
    │
    ├── Perspective-Spotter        requires Linden
    ├── Perspective                requires Adwaita, Linden, Perspective-Spotter
    ├── Perspective-Project        requires Perspective
    ├── Perspective-Package        requires Perspective
    ├── Perspective-Class          requires Perspective
    ├── Perspective-Method         requires Perspective
    │
    ├── Pulsar-Browser             requires Perspective
    ├── Pulsar-Tool-*              requires Pulsar-Browser
    │     └── Pulsar-Tool-LLM      also requires Vte, MCP
    └── Pulsar-Browser-Tests       requires Pulsar-Browser
```

Spec itself (Spec2-Core, Spec2-Code, Spec-Panel, etc.) comes in as a transitive dependency of the external baselines above — there is no `BaselineOfGtk`/`BaselineOfSpecCore`/`BaselineOfSpecGtk` in this project.

## Where to Put Things

| If you're adding... | Put it in... |
|---|---|
| A new model (generic, reusable) | `Perspective` or `Pulsar-Browser` |
| A new model (tool-specific) | `Pulsar-Tool-YourThing` |
| A new presenter/panel | `Pulsar-Tool-YourThing` |
| A new editor | `Pulsar-Tool-YourThing` |
| A new request announcement | `Pulsar-Tool-YourThing` |
| A new general announcement | `Pulsar-Browser` |
| An action registration on an existing model | That model's package |
| A baseline entry | `BaselineOfPulsar` |
| Browser-wide changes | `Pulsar-Browser` |
| A new icon provider | `Perspective` for substrate providers, `Pulsar-Browser` for Pulsar providers (e.g. the MDI provider); tool-specific providers register themselves via an `<iconProvider>` pragma (chapter 19) |

## Package Loading Order

1. External baselines (Adwaita, Linden, Vte, MCP — bringing Spec with them)
2. Perspective-Spotter
3. Perspective
4. Perspective-Project, Perspective-Package, Perspective-Class, Perspective-Method
5. Pulsar-Browser (core IDE)
6. Pulsar-Tool-* packages (each tool)
7. Pulsar-Browser-Tests (tests)

Each layer depends only on layers loaded before it.

## Adding a New Package to the Baseline

```smalltalk
BaselineOfPulsar >> baseline: spec
    <baseline>
    spec for: #common do: [
        spec
            package: 'Pulsar-Tool-MyThing'
            with: [ spec requires: 'Pulsar-Browser' ] ]
```

If your tool depends on additional packages (e.g., a third-party library), list them all as an array, like `Pulsar-Tool-LLM` does (`requires: #('Pulsar-Browser' 'Vte' 'MCP')`).
