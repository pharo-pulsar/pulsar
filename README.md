# Install instructions

package dependencies: 
- gtk4
- gtksourceview5
- libadwaita
- libpanel
- librsvg

## 1. Download VM

### Linux 
You should be ok about dependencies, but you may need `libpanel`, `librsvg` and `gtksourceview5` if you are running a tiny machine. 
If that is the case, install them using you favorite package manager.  
E.g. in Ubuntu (And maybe other debian distros) you can do this:
```shell
sudo apt install libadwaita-1-0 libgtksourceview-5-0 libpanel-1-1 librsvg2-2
``` 

### MacOS
You can download a VM prepared with dependencies [here](https://forge.smallworks.eu/pharo/-/packages/generic/pharovm-full-macos-arm).  
We currently do not support old macOS intel machines.

### Windows

**TODO**

## 2. Download a Pulsar image
You can download a bundle with the pre-built image: 

- [Releases](https://forge.smallworks.eu/pharo/-/packages/generic/pulsar).
- [Nightly builds](https://forge.smallworks.eu/pharo/-/packages/generic/pulsar-nightly-build).

## 3. Run it

in Linux:
```Shell
pharo --worker Pharo.image openPulsar
```

**NOTE:** You may want to create an alias in your shell to easy the start. I use fishshell and I have defined this function in my `config.fish` : 
```fish
function psr
    pharo --worker $argv[1] openPulsar $argv[2..-1]
end
```

in MacOS:
```Shell
./Pharo.app/Contents/Pharo --worker --headless Pharo.image openPulsar
```

in Windows:
```Shell
PharoConsole.exe --worker --headless Pharo.image openPulsar
```

# Build instructions
**You do not need to build the pulsar image by yourself**, the CI does that job for you. Nevertheless this information is useful 
in case, for any reason I cannot see, you still want to build the Pulsar image by yourself.

## 1. Download a usable image
Right now we are using Pharo 14, download the latest image (knowing that also Pharo is in development, things may fail).

## 2. Install MetaMetacello
(this is not really *required* but it will make easier the next step ;)

```smalltalk
Metacello new 
	repository: 'github://estebanlm/MetaMetacello:main';
	baseline: 'MetaMetacello';
	load.
```

### 3. Install a lot of packages

**IMPORTANT!!! For all this to work you need to add your keys to your account in the forge!** 

```smalltalk
MetaMetacello load: [ :spec | spec
	baseline: 'UnifiedFFI' with: [ spec 
		repository: 'github://pharo-cig/UnifiedFFI:main';
		className: #BaselineOfUnifiedFFIFull ];
	baseline: 'Alexandrie' with: [ spec repository: 'github://pharo-graphics/Alexandrie:master' ]; 
	baseline: 'Resvg' with: [ spec repository: 'github://pharo-cig/pharo-resvg:main' ]; 
	baseline: 'StringInterpolation' with: [ spec 
		repository: 'github://estebanlm/pharo-string-interpolation:master';
		loads: #('StringInterpolation') ];
	baseline: 'Refactoring' with: [ spec
		repository: 'git:git@forge.smallworks.eu:pharo/RefactoringEngine.git:main' ];
	baseline: 'Themes' with: [ spec 
		repository: 'github://estebanlm/Themes:main';
		loads: #('HighlightStyles') ]; 
	baseline: 'Spec2' with: [ spec 
		repository: 'github://pharo-spec/Spec:dev-3.0';
		loads: #(default 'Spec2-Alexandrie' 'Spec2-Adapters-Morphic-Alexandrie') ];
	baseline: 'Gtk' with: [ spec 
		repository: 'github://pharo-spec/gtk-bindings:main';
		loads: #(default 'Gtk-Utils') ];
	baseline: 'SpecGtk' with: [ spec 
		repository: 'github://pharo-spec/Spec-Gtk:main';
		loads: #(default) ];
	baseline: 'NewTools' with: [ spec 
		repository: 'github://pharo-spec/NewTools:dev-2.0';
		loads: #(default 'NewTools-Gtk') ];
	baseline: 'Stargate' with: [ spec repository: 'github://estebanlm/stargate:main' ];
	baseline: 'Linden' with: [ spec repository: 'git:git@forge.smallworks.eu:estebanlm/linden.git:main' ];
	baseline: 'Adwaita' with: [ spec repository: 'github://estebanlm/Spec-LibAdwaita:main' ];
	baseline: 'SourceEditor' with: [ spec repository: 'git:git@forge.smallworks.eu:pharo/SourceEditor.git:main' ];
	baseline: 'Panel' with: [ spec repository: 'github://estebanlm/Spec-LibPanel:main' ];
	baseline: 'Pulsar' with: [ spec repository: 'git:git@forge.smallworks.eu:pharo/Pulsar.git:main' ] ].
```

### 4. Prepare your environment

```smalltalk
(Smalltalk classNamed: #GEnumeration) allSubclassesDo: #initializeEnumeration.
"We want to work with string interpolation, but for now do not install it as it 
 creates problems while saving changes (they become corrupt, digging why). 
 Also current implementation is not backward compatible so we need to think how to  
 do it right."
"(Smalltalk classNamed: #StringInterpolationPlugin) install."

"we ban this rule because is annoying since we use LF as end line (in linux). Also this should be agnostic, we should not care about it."
ReMethodSourceContainsLinefeedsRule enabled: false.
"And this one, since there is no real need of this and is also annoying :P"
ReCompactSourceCodeRule enabled: false.
```

#### 4.1. In MacOS
`Spec-Gtk` changes the default driver for the morphic world to `OSGtkDriver` but this is not 
working properly for the moment, so better if we revert it or your image will not be working
when tryign to execute it in morphic.

```Smalltalk
OSWindowDriver driverClass: OSSDL2Driver.
```  
