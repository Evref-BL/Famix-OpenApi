Class {
	#name : 'FamixOpenApiImporter',
	#superclass : 'Object',
	#instVars : [
		'generalReader',
		'model'
	],
	#category : 'Famix-OpenApi-Importer',
	#package : 'Famix-OpenApi-Importer'
}

{ #category : 'import - api' }
FamixOpenApiImporter >> configureReaderForApi: reader [

	reader mapInstVarsFor: OPApi .
	
	reader
		for: #ArrayOfApi
		customDo: [ :customMappting |
		customMappting listOfElementSchema: OPApi ].
	
]

{ #category : 'import - api' }
FamixOpenApiImporter >> configureReaderForPath: reader [

	reader mapInstVarsFor: OPPath .
	
	reader
		for: #ArrayOfPath
		customDo: [ :customMappting |
		customMappting listOfElementSchema: OPPath ]
]

{ #category : 'importing' }
FamixOpenApiImporter >> importApiFromJsonString: aJsonString [

	| api |
	api :=  self parseApiJsonString: aJsonString.
	
	(self importPaths: (NeoJSONWriter toString: api paths) ofApi: api).
	
	^ api 
]

{ #category : 'import - path' }
FamixOpenApiImporter >> importPaths: aJsonString ofApi: anOPApi [ 
	
	| data |
	data := NeoJSONReader fromString: aJsonString.
"	paths := self parsePathJsonString: aJsonString. "
	data keysAndValuesDo: [ :k :v | 
			|path|
			"path := model newPath name: k."
		].
	

	
	
	
	 
]

{ #category : 'initialization' }
FamixOpenApiImporter >> initReader [

	| configurators |
	generalReader := NeoJSONReader new.
	
	configurators := (self class allSelectors select: [ :m |
		                  m beginsWith: #configureReaderFor ]) asSet.

	configurators do: [ :configureReader |
		self perform: configureReader with: generalReader ]
]

{ #category : 'initialization' }
FamixOpenApiImporter >> initialize [
	super initialize.
	self initReader.
]

{ #category : 'accessing' }
FamixOpenApiImporter >> model [
	^ model 
]

{ #category : 'accessing' }
FamixOpenApiImporter >> model: aModelInstance [
	model := aModelInstance 
]

{ #category : 'importing' }
FamixOpenApiImporter >> modelFromJsonString: aJsonString [

	self model: OPModel new.
	self model add: (self importApiFromJsonString: aJsonString).
	^ self model
]

{ #category : 'parsing' }
FamixOpenApiImporter >> parseApiJsonString: aResult [

	| reader |
	reader := generalReader on: aResult readStream.

	^ reader nextAs: OPApi 
]

{ #category : 'parsing' }
FamixOpenApiImporter >> parsePathJsonString: aResult [ 
	
	| reader |
	reader := generalReader on: aResult readStream.

	^ reader nextAs: OPPath 
]
