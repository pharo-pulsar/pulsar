"
""This is an editor to edit a method whose body is a literal array of arrays (a table of rows) as a table.

Its model is a PulsarMethodTableModel. The method to be edited needs to be decorated with the <pulsarTableEditor: #(columnTitles...)> pragma.

It shows the rows in a column view and lets the user edit the selected row in a form below the table, add or remove rows, and save back to the method.""
"
Class {
	#name : 'PulsarMethodTableEditor',
	#superclass : 'PulsarEditor',
	#instVars : [
		'tablePresenter',
		'cellInputs',
		'cellLabels',
		'workingRows',
		'columnsBuilt',
		'formPresenter'
	],
	#category : 'Pulsar-Tool-FileEditor-View',
	#package : 'Pulsar-Tool-FileEditor',
	#tag : 'View'
}

{ #category : 'private' }
PulsarMethodTableEditor >> buildForm [
	"Build the row-editing form: one label and one text input per column."

	| formBox |
	cellLabels := OrderedCollection new.
	cellInputs := OrderedCollection new.
	formBox := SpBoxLayout newVertical.
	self model columnTitles withIndexDo: [ :eachTitle :index |
			| label input line |
			label := self newLabel label: eachTitle.
			input := self newTextInput.
			input whenTextChangedDo: [ :newText :oldText | self cellEdited: newText at: index ].
			line := SpBoxLayout newHorizontal
				        add: label width: 160;
				        add: input expand: true;
				        yourself.
			formBox add: line expand: false.
			cellLabels add: label.
			cellInputs add: input ].
	formPresenter := formBox
]

{ #category : 'private' }
PulsarMethodTableEditor >> cellEdited: newText at: index [
	"Update the selected row cell with the given text and refresh the table."

	| eachRow |
	self isUpdating ifTrue: [ ^ self ].
	eachRow := tablePresenter selectedItem.
	eachRow ifNil: [ ^ self ].
	eachRow at: index put: newText.
	tablePresenter refresh.
	self markDirtyIfNeeded
]

{ #category : 'accessing' }
PulsarMethodTableEditor >> cellInputs [

	^ cellInputs
]

{ #category : 'initialization' }
PulsarMethodTableEditor >> connectPresenters [

	tablePresenter whenSelectedItemChangedDo: [ :eachRow | self populateFormFor: eachRow ]
]

{ #category : 'layout' }
PulsarMethodTableEditor >> defaultLayout [

	^ SpBoxLayout newVertical
		  add: toolbarPresenter expand: false;
		  add: (self editorOverlayLayout
				   child: tablePresenter;
				   yourself)
		  expand: true;
		  add: formPresenter expand: false;
		  yourself
]

{ #category : 'private - definitions' }
PulsarMethodTableEditor >> defineActionsOn: aBuilder [

	<dockActions>
	aBuilder addGroup: #table with: [ :group |
			group
				priority: 5;
				name: 'Table';
				beDisplayedAsGroup;
				addActionWith: [ :anAction |
						anAction
							name: 'Add row';
							description: 'Add a new row to the table';
							iconName: 'plus';
							action: [ self doAddRow ] ];
				addActionWith: [ :anAction |
						anAction
							name: 'Remove row';
							description: 'Remove the selected row from the table';
							iconName: 'minus';
							action: [ self doRemoveRow ] ] ]
]

{ #category : 'actions' }
PulsarMethodTableEditor >> doAddRow [

	| newRow |
	newRow := Array new: self model columnTitles size withAll: ''.
	workingRows := workingRows copyWith: newRow.
	tablePresenter items: workingRows.
	self markDirty.
	tablePresenter selectItem: newRow
]

{ #category : 'actions' }
PulsarMethodTableEditor >> doRemoveRow [

	| eachRow index |
	eachRow := tablePresenter selectedItem.
	eachRow ifNil: [ ^ self ].
	index := workingRows indexOf: eachRow.
	index = 0 ifTrue: [ ^ self ].
	workingRows := workingRows copyWithoutIndex: index.
	tablePresenter items: workingRows.
	self markDirtyIfNeeded
]

{ #category : 'private - actions' }
PulsarMethodTableEditor >> doReset [

	self updatingWhile: [ self updatePresenter ]
]

{ #category : 'private - actions' }
PulsarMethodTableEditor >> doSubmit: aCollectionOfRows [
	"Compile the method with the given rows and refresh the editor on success."

	| result oldModel |
	oldModel := self model copy.
	result := self model updateWith: aCollectionOfRows.
	result ifTrue: [
			self unmarkDirty.
			self notifyModelChangedFrom: oldModel to: self model.
			self updatePresenter ].
	^ result
]

{ #category : 'private' }
PulsarMethodTableEditor >> ensureColumns [

	columnsBuilt ifTrue: [ ^ self ].
	columnsBuilt := true.
	tablePresenter addColumn: (SpIndexTableColumn title: '#').
	self model columnTitles withIndexDo: [ :eachTitle :index |
		tablePresenter addColumn: (SpStringTableColumn title: eachTitle evaluated: [ :eachRow | eachRow at: index ]) ].
	self buildForm
]

{ #category : 'initialization' }
PulsarMethodTableEditor >> initialize [

	columnsBuilt := false.
	super initialize
]

{ #category : 'initialization' }
PulsarMethodTableEditor >> initializeEditor [

	tablePresenter := self newEasyColumnView.
	tablePresenter addStyle: 'stList'
]

{ #category : 'initialization' }
PulsarMethodTableEditor >> initializePresenters [

	self addStyle: 'pulsarEditor'.
	toolbarPresenter := self instantiate: PulsarEditorToolbarPresenter.
	toolbarPresenter actions: self editorToolbarActions.
	self initializeEditor
]

{ #category : 'private - updating' }
PulsarMethodTableEditor >> markDirtyIfNeeded [

	workingRows = self model rows
		ifTrue: [ self unmarkDirty ]
		ifFalse: [ self markDirty ]
]

{ #category : 'private' }
PulsarMethodTableEditor >> populateFormFor: eachRow [
	"Fill the form inputs with the cells of the given row."

	self updatingWhile: [
		cellInputs withIndexDo: [ :eachInput :index | eachInput text: (eachRow ifNil: [ '' ] ifNotNil: [ eachRow at: index ]) ] ]
]

{ #category : 'private - actions' }
PulsarMethodTableEditor >> saveContent [

	^ self doSubmit: workingRows
]

{ #category : 'accessing' }
PulsarMethodTableEditor >> tablePresenter [

	^ tablePresenter
]

{ #category : 'initialization' }
PulsarMethodTableEditor >> updatePresenter [

	super updatePresenter.
	self model ifNil: [ ^ self ].
	self updatingWhile: [
			self ensureColumns.
			workingRows := self model rows collect: [ :eachRow | eachRow copy ].
			tablePresenter items: workingRows.
			self populateFormFor: nil ].
	self unmarkDirty
]

{ #category : 'accessing' }
PulsarMethodTableEditor >> workingRows [

	^ workingRows
]
