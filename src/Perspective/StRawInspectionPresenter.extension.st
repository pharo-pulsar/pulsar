Extension { #name : 'StRawInspectionPresenter' }

{ #category : '*Perspective' }
StRawInspectionPresenter >> insertPopover: aPresenter [

	aPresenter asPopover
		relativeTo: (attributeTable selectedRowPresenter ifNil: [ attributeTable ]);
		bePositionRight;
		popup
]
