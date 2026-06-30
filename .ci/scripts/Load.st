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
	baseline: 'Vte' with: [ spec repository: 'github://estebanlm/Spec-VTE:main' ];
	baseline: 'NewTools' with: [ spec 
		repository: 'github://pharo-spec/NewTools:dev-2.0';
		loads: #(default 'NewTools-Gtk') ];
	baseline: 'Roassal' with: [ spec 
		repository: 'git:git@forge.smallworks.eu:pharo/Roassal.git:main';
		loads: #('Roassal-Spec' 'Roassal-Spec-Gtk') ];
	"threaded iceberg"
	baseline: 'LibGit' with: [ spec repository: 'github://pharo-vcs/libgit2-pharo-bindings:experimental-run-in-thread' ];
	baseline: 'Iceberg' with: [ spec repository: 'github://pharo-vcs/iceberg:track-external-files' ];
	"LLM (should be optional)"
	baseline: 'JRPC' with: [ spec 
		repository: 'github://juliendelplanque/JRPC:v3.2.1'; 
		loads: #('Deployment') ];
	"using mine for now to have better control"
	baseline: 'MCP' with: [ spec repository: 'github://estebanlm/MCP:main' ];
	baseline: 'Stargate' with: [ spec repository: 'github://estebanlm/stargate:main' ];
	baseline: 'Linden' with: [ spec repository: 'git:git@forge.smallworks.eu:estebanlm/linden.git:main' ];
	baseline: 'Adwaita' with: [ spec repository: 'github://estebanlm/Spec-LibAdwaita:main' ];
	baseline: 'SourceEditor' with: [ spec repository: 'git:git@forge.smallworks.eu:pharo/SourceEditor.git:main' ];
	baseline: 'Panel' with: [ spec repository: 'github://estebanlm/Spec-LibPanel:main' ];
	baseline: 'Pulsar' with: [ spec repository: 'git:git@forge.smallworks.eu:pharo/Pulsar.git:main' ] ]
