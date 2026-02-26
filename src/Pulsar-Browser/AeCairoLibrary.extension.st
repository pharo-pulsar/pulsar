Extension { #name : 'AeCairoLibrary' }

{ #category : '*Pulsar-Browser' }
AeCairoLibrary >> macLibraryName [
	"since both Gtk and alexandrie both use Cairo, I need to be sure we are going to 
	use same library (this also applies to freetype, btw)"

	^ GMacLibraryFinder findLibrary: 'libcairo.2.dylib'
]
