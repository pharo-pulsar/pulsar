# Install instructions

package dependencies: 
- gtk4
- gtksourceview5
- libadwaita
- libpanel
- libgit2 (this is not really required but you will want it if you want to commit your changes)

they are to be installed, for the moment through: 

## Linux
they should be already in the system, otherwise you can install them using your favourite installer.

## MacOS
homebrew (TBD)

## Windows
You are a real programmer... why aren't you using linux?

### 1. You need `msys2` subsystem
### 2. Then install this packages (from the msys2 terminal): 

```shell
pacman -S mingw-w64-clang-aarch64-gtk4 mingw-w64-clang-x86_64-gtksourceview5 mingw-w64-clang-x86_64-libadwaita mingw-w64-clang-x86_64-libpanel mingw-w64-clang-x86_64-libgit2
``` 

You **need** to make sure your libraries (usually in `C:\msys2\clang64\bin`) are in the path.

### 3. A VM *stripped* from external libraries 
You need it because otherwise the libraries will conflict and everythign will crash.  
You can download [this one one from the pharo site](https://files.pharo.org/get-files/140/pharo-vm-Windows-X86-stable.zip) and remove everything that is not a plugin :)

### 4. Download a usable image
Right now we are using [Pharo14 build 200](https://files.pharo.org/image/140/Pharo14.0-SNAPSHOT.build.200.sha.c126aa2736.arch.64bit.zip)
(We will validate new images time to time but since P14 is changing maby underlying things, we will not be moving so much, 
we want to deal with our bugs -already a lot- not others bugs).

### 4. Install MetaMetacello
(this is not really *required* but it will make easier the next step ;)

```smalltalk
Metacello new 
	repository: 'github://estebanlm/MetaMetacello:main';
	baseline: 'MetaMetacello';
	load.
```

### 5. Install a lot of packages

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
	baseline: 'Panel' with: [ spec repository: 'github://estebanlm/Spec-LibPanel:main' ];
	baseline: 'DockBrowser' with: [ spec 
		repository: 'git:git@forge.smallworks.eu:pharo/DockBrowser.git:dev';
		className: #BaselineOfPerspective ] ].

(Smalltalk classNamed: #GEnumeration) allSubclassesDo: #initializeEnumeration.
(Smalltalk classNamed: #StringInterpolationPlugin) install.
```

**IMPORTANT!!! For all this to work you need to add your keys to your account in the forge!** 
