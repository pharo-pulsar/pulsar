MetaMetacello load: [ :spec | spec
	baseline: 'Alexandrie' with: [ spec repository: 'github://pharo-graphics/Alexandrie:master' ]; 
	baseline: 'RSVG' with: [ spec repository: 'github://pharo-cig/pharo-librsvg:main' ]; 
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
	baseline: 'Roassal' with: [ spec 
		repository: 'git:git@forge.smallworks.eu:pharo/Roassal.git:main';
		loads: #('Roassal-Spec-Gtk') ];
	baseline: 'Stargate' with: [ spec repository: 'github://estebanlm/stargate:main' ];
	baseline: 'Linden' with: [ spec repository: 'git:git@forge.smallworks.eu:estebanlm/linden.git:main' ];
	baseline: 'Adwaita' with: [ spec repository: 'github://estebanlm/Spec-LibAdwaita:main' ];
	baseline: 'SourceEditor' with: [ spec repository: 'git:git@forge.smallworks.eu:pharo/SourceEditor.git:main' ];
	baseline: 'Panel' with: [ spec repository: 'github://estebanlm/Spec-LibPanel:main' ];
	baseline: 'Pulsar' with: [ spec repository: 'git:git@forge.smallworks.eu:pharo/Pulsar.git:main' ];
	baseline: 'LibGit' with: [ spec repository: 'github://pharo-vcs/libgi2-pharo-bindings.git:experimental/run-in-thread' ] ]
