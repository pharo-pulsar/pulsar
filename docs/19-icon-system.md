# 19. Icon System

Pulsar uses a lazy icon resolution system based on named identifiers. Models declare icon names; the UI resolves them through a chain of icon providers.

## Icon Providers

Pulsar supports multiple icon provider backends:

| Provider | Source |
|---|---|
| `PulsarMDINeutralIconProvider` | MDI (Material Design Icons) neutral set — the base provider |
| `PvAliasedVSCodeIconProvider` | VSCode icon aliases (maps VSCode names to local icons) |
| `PvDefaultIconProvider` | Terminal fallback — always answers `ThemeIcons current noIcon` |

`PulsarMDINeutralIconProvider` [Pulsar-Browser, tag Application] is a `SpLocationIconProvider` subclass that serves the Templarian Material Design SVGs (bundled under `resources/MaterialDesign`).

`PvAliasedVSCodeIconProvider` [Perspective, tag Icon] is a `PvVSCodeIconProvider` subclass used by the Perspective application composition. It maps VSCode-style icon names (e.g., `#symbol-class`) to the local vscode-icon sets, allowing common icon naming conventions without bundling the full VSCode set.

`PvDefaultIconProvider` [Perspective, tag Icon] is the terminal provider of the chain: it always answers a value (`ThemeIcons current noIcon`), so resolution never fails.

### Provider Composition

`PulsarApplication` builds the provider chain at startup:

```smalltalk
PulsarApplication >> newIconProvider
    ^ SpCompositeIconProvider new
        addProvider: self baseIconProvider;
        in: [ :aProvider |
            (PulsarPragmaCollector collectPragma: #iconProvider in: self)
                do: [ :eachProvider | aProvider addProvider: eachProvider ] ];
        addProvider: PvDefaultIconProvider new;
        yourself

PulsarApplication >> baseIconProvider
    ^ PulsarMDINeutralIconProvider new
        application: self;
        addLocation: self resourcesDir / 'MaterialDesign' / 'extras';
        addLocation: self resourcesDir / 'MaterialDesign' / 'svg'
```

Providers registered through the `<iconProvider>` pragma are inserted between the base provider and the terminal one. For example, `Pulsar-Tool-FileEditor` contributes:

```smalltalk
PulsarApplication >> fileTypeIconProvider
    <iconProvider>
    ^ PulsarVSCodeFileTypeIconProvider new
        addLocation: self resourcesDir / 'FileTypes' / 'svg'
```

## How Models Declare Icons

```smalltalk
PvBaseModel >> iconName
    ^ nil  "default: no icon"

PvBaseModel >> windowIconName
    ^ self iconName  "default: same as model icon"
```

Overriding `iconName` in a model gives it an icon everywhere it appears:

```smalltalk
PvClassModel >> iconName
    ^ self entity systemIconName

PvPackageModel >> iconName
    ^ #package
```

(`Class >> systemIconName` answers `#class`, so class models effectively use the `#class` icon.)

## Icon Resolution Flow

```
Model >> iconName returns #class
    │
    ▼
PulsarApplication >> iconNamed: #class
    │
    ▼
PulsarIconProxy (name: #class, provider: iconProvider)
    │
    ▼
SpCompositeIconProvider
    ├── PulsarMDINeutralIconProvider (base, MDI SVGs)
    ├── <iconProvider> pragma providers (e.g. PulsarVSCodeFileTypeIconProvider)
    └── PvDefaultIconProvider (terminal: noIcon)
    │
    ▼
Form (rendered on screen)
```

## PulsarIconProxy

```smalltalk
PulsarIconProxy
    slots: { iconName. iconProvider }
    package: 'Pulsar-Browser'
```

A lazy resolution proxy. `PulsarApplication >> iconNamed:` answers a `PulsarIconProxy` instead of an actual icon; the icon is only resolved when a message is sent to it:

```smalltalk
PulsarApplication >> iconNamed: aString
    ^ PulsarIconProxy name: aString provider: self iconProvider

PulsarIconProxy >> doesNotUnderstand: aMessage
    | form |
    form := iconProvider iconNamed: iconName.
    form ifNil: [ ^ nil ].
    ^ aMessage sendTo: form
```

## Color Name

Models can also provide a color accent:

```smalltalk
PvBaseModel >> colorName
    ^ nil  "default: no specific color"
```

Overriding this gives a model a colored tint in the UI (e.g., modified packages, unsaved editors).

## Adding a Custom Icon

1. Add the image file to the Pulsar resources
2. Register it with an icon provider subclass (or contribute a provider via a `<iconProvider>` pragma method on `PulsarApplication`)
3. Reference it via `iconName` in your model

Or use a VSCode alias if the icon already has a standard name:

```smalltalk
MyModel >> iconName
    ^ #symbol-ruler  "VSCode alias"
```
