# Install instructions

package dependencies: 
- gtk4
- gtksourceview5
- libadwaita
- libpanel

## 1. Download VM
they should be already in the system, otherwise you can install them using your favourite installer.

### Linux 
You should be ok, buy you may need `libpanel` and `gtksourceview5` from the list of dependencies. If that is the case, install them using you favorite package manager.

### MacOS
You are a real programmer... why aren't you using linux?

Download the prepared VM with dependencies **TODO**

### Windows
You are a real programmer... why aren't you using linux?

[Download the prepared VM with dependencies](https://nextcloud.smallworks.eu/s/eBe3k6dJWfsJMf5).
This is a temporal location and likely a temporal VM, but for now it should make the job.

## 2. Download a usable image
Right now we are using [Pharo14 build 200](https://files.pharo.org/image/140/Pharo14.0-SNAPSHOT.build.200.sha.c126aa2736.arch.64bit.zip)
(We will validate new images time to time but since P14 is changing many underlying things, we will not be moving so much, 
we want to deal with our bugs -already a lot- not others bugs).

This build is very alpha and there are problems everywhere... in case of the build 200, you want to execute this as first step: 

```Smalltalk
Object compile: 'inform: aString
	"Display a message for the user to read and then dismiss."
	
	aString isEmptyOrNil
		ifFalse: [ UIManager default inform: aString ]'.
``` 

### 3. Install MetaMetacello
(this is not really *required* but it will make easier the next step ;)

```smalltalk
Metacello new 
	repository: 'github://estebanlm/MetaMetacello:main';
	baseline: 'MetaMetacello';
	load.
```

### 4. Install a lot of packages

```smalltalk
MetaMetacello load: [ :spec | spec      
	lockBaselines;
	baseline: 'UnifiedFFI' with: [ spec 
		repository: 'github://pharo-cig/UnifiedFFI:main';
		className: #BaselineOfUnifiedFFIFull ];
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
		repository: 'github://pharo-spec/gtk-bindings:gtk4';
		loads: #(default 'Gtk-Utils') ];
	baseline: 'SpecGtk' with: [ spec 
		repository: 'github://pharo-spec/Spec-Gtk:gtk4';
		loads: #(default) ];
	baseline: 'NewTools' with: [ spec 
		repository: 'github://pharo-spec/NewTools:dev-2.0';
		loads: #(default 'NewTools-Gtk') ];
	baseline: 'Stargate' with: [ spec repository: 'github://estebanlm/stargate:main' ];
	baseline: 'Linden' with: [ spec repository: 'git:git@forge.smallworks.eu:estebanlm/linden.git:main' ];
	baseline: 'Adwaita' with: [ spec repository: 'github://estebanlm/Spec-LibAdwaita:main' ];
	baseline: 'SourceEditor' with: [ spec repository: 'git:git@forge.smallworks.eu:pharo/SourceEditor.git:main' ];
	baseline: 'Panel' with: [ spec repository: 'github://estebanlm/Spec-LibPanel:main' ];
	baseline: 'DockBrowser' with: [ spec 
		repository: 'git:git@forge.smallworks.eu:pharo/DockBrowser.git:main';
		className: #BaselineOfPerspective ] ].

(Smalltalk classNamed: #GEnumeration) allSubclassesDo: #initializeEnumeration.
"We want to work with string interpolation, but for now do not install it as it 
 creates problems while saving changes (they become corrupt, digging why). 
 Also current implementation is not backward compatible so we need to think how to  
 do it right."
"(Smalltalk classNamed: #StringInterpolationPlugin) install."
```

**IMPORTANT!!! For all this to work you need to add your keys to your account in the forge!** 

#### 4.1. In MacOS
`Spec-Gtk` changes the default driver for the morphic world to `OSGtkDriver` but this is not 
working properly for the moment, so better if we revert it or your image will not be working
when tryign to execute it in morphic.

```Smalltalk
OSWindowDriver driverClass: OSSDL2Driver.
```  

### 5. Run

in Linux/MacOS:
```Shell
pharo --worker Pharo.image run dock
```

in Windows:
```Shell
PharoConsole.exe --headless --worker Pharo.image run dock
```
