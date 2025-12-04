"
A base for all the models of the browser.
Is important that all models uses this trait to allow models to move on the system without having major problems.

Important methods: 
- `accept:` -> this will make your model part of the visit system. By default it just call `visitModel:`, override it as needed.
 
"
Trait {
	#name : 'AnObsoleteDockTModel',
	#category : 'Dock-Browser-Base',
	#package : 'Dock-Browser',
	#tag : 'Base'
}
