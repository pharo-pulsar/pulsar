Class {
	#name : #PvPackageActivatedAnnouncement,
	#superclass : #PvActivatedAnnouncement,
	#category : #'Perspective-Package-Model'
}

{ #category : #accessing }
PvPackageActivatedAnnouncement >> performSelector [

	^ #packageActivated:
]
