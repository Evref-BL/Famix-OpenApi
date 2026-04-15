Extension { #name : 'OPOperation' }

{ #category : '*Famix-OpenAPI-Model-Extension' }
OPOperation >> allParameters [
	"return the Operation Parameters plus its path parameter is defined. The operation override the parameter from the path"
		
	|parameters|
	self flag: 'TODO'. 
	
	^ self parameters,  (self path parameters select: [:p | 
			|names|
			names := self parameters collect: #name.
			(names includes: p name)not ])
	
]
