"
I am a trait that gives a Pulsar presenter or model a declarative, lazily built set of actions.

Rather than assembling toolbars, context menus and panel buttons by hand, a user of this trait declares actions in `<dockActions>` methods and obtains the resulting group through `actions`. `PulsarActionCollector` discovers those pragma methods on both the instance and class side, builds an `SpActionGroup` sorted by priority and name, and gives every command the receiver as its default context. The group is created on first access and cached in the trait's `actions` slot, so repeated UI refreshes reuse the same commands.

Clients usually select the part they need by group identifier:

```smalltalk
self actions actionsFor: #panelWidget
```

Declaring a group near the object it acts on keeps its presentation and behaviour together:

```smalltalk
defineActionsOn: aBuilder
	<dockActions>

	aBuilder addGroup: #directory with: [ :group |
		group addActionWith: [ :action |
			action
				name: 'New folder';
				iconName: 'addFolder';
				action: [ self doAddFolderCommand: action ] ] ]
```

The cached group is built with the receiver as context. When commands must operate on another object, such as a selection or an editor, build a fresh group with `PulsarActionCollector` and an explicit context instead of reusing `actions`; `PvBaseModel>>actionsWithContext:` follows this pattern.

The main collaborators are `PulsarActionCollector`, which performs the pragma discovery and assembly, and `SpActionGroup`, which holds the groups and commands. Typical users are Pulsar views and models such as `PulsarBaseView`, `PulsarEditor` and `PvBaseModel`, which pass selected groups to toolbars, context menus and panel widgets. The trait owns the `actions` slot and its cache; users needing different collection semantics override `actions` and supply their own group.
"
Trait {
	#name : 'PulsarTActionContainer',
	#instVars : [
		'actions'
	],
	#category : 'Perspective-Model',
	#package : 'Perspective',
	#tag : 'Model'
}

{ #category : 'private' }
PulsarTActionContainer >> actions [

	^ actions ifNil: [ actions := PulsarActionCollector collectFor: self ]
]
