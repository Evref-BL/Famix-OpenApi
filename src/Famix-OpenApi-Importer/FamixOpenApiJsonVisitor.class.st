Class {
	#name : 'FamixOpenApiJsonVisitor',
	#superclass : 'Object',
	#instVars : [
		'model'
	],
	#category : 'Famix-OpenApi-Importer',
	#package : 'Famix-OpenApi-Importer'
}

{ #category : 'private - model' }
FamixOpenApiJsonVisitor >> entityClassNamed: anEntityName [
	| generatedClassName |
	generatedClassName := (FamixOpenApiGenerator prefix asString , anEntityName asString) asSymbol.
	^ Smalltalk globals
		at: generatedClassName
		ifAbsent: [ self error: 'Missing generated class: ', generatedClassName asString ]
]

{ #category : 'private - json' }
FamixOpenApiJsonVisitor >> jsonValueAt: aJsonKey in: aDictionary ifAbsent: aBlock [
	(aDictionary includesKey: aJsonKey) ifTrue: [ ^ aDictionary at: aJsonKey ].
	(aDictionary includesKey: aJsonKey asSymbol) ifTrue: [ ^ aDictionary at: aJsonKey asSymbol ].
	^ aBlock value
]

{ #category : 'private - json' }
FamixOpenApiJsonVisitor >> copyValueAt: aJsonKey from: aDictionary to: anEntity property: aPropertyName [
	self
		valueAt: aJsonKey
		in: aDictionary
		ifPresent: [ :value | self setProperty: aPropertyName on: anEntity to: value ]
]

{ #category : 'private - naming' }
FamixOpenApiJsonVisitor >> firstNormalizedNameCandidateIn: aCollection [
	aCollection do: [ :each |
		| candidate |
		candidate := self normalizedNameCandidateFrom: each.
		candidate ifNotNil: [ ^ candidate ] ].
	^ nil
]

{ #category : 'private - testing' }
FamixOpenApiJsonVisitor >> isDictionaryLike: anObject [
	^ anObject respondsTo: #keysAndValuesDo:
]

{ #category : 'private - testing' }
FamixOpenApiJsonVisitor >> isSequenceLike: anObject [
	^ anObject isCollection and: [ anObject isString not ]
]

{ #category : 'private - writing' }
FamixOpenApiJsonVisitor >> add: aChildEntity toManyProperty: aPropertyName of: anEntity [
	| getter setter collection |
	getter := aPropertyName asSymbol.
	(anEntity respondsTo: getter) ifFalse: [ ^ self ].

	collection := anEntity perform: getter.
	collection ifNil: [
		setter := (aPropertyName asString , ':') asSymbol.
		(anEntity respondsTo: setter) ifTrue: [
			collection := OrderedCollection new.
			anEntity perform: setter with: collection ] ].

	collection ifNil: [ ^ self ].
	(collection respondsTo: #add:)
		ifTrue: [ collection add: aChildEntity ]
		ifFalse: [
			setter := (aPropertyName asString , ':') asSymbol.
			(anEntity respondsTo: setter)
				ifTrue: [ anEntity perform: setter with: (Array with: aChildEntity) ] ]
]

{ #category : 'private - model' }
FamixOpenApiJsonVisitor >> newEntityNamed: anEntityName [
	| entity |
	entity := (self entityClassNamed: anEntityName) new.
	model add: entity.
	self setProperty: #name on: entity to: anEntityName asString.
	^ entity
]

{ #category : 'private - model' }
FamixOpenApiJsonVisitor >> newModel [
	model := (self entityClassNamed: #Model) new
]

{ #category : 'private - writing' }
FamixOpenApiJsonVisitor >> setProperty: aPropertyName on: anEntity to: aValue [
	| setter |
	setter := (aPropertyName asString , ':') asSymbol.
	(anEntity respondsTo: setter) ifTrue: [ anEntity perform: setter with: aValue ]
]

{ #category : 'private - naming' }
FamixOpenApiJsonVisitor >> normalizedNameCandidateFrom: aValue [
	| candidate |
	aValue ifNil: [ ^ nil ].
	candidate := aValue asString trimBoth.
	candidate isEmpty ifTrue: [ ^ nil ].
	^ candidate
]

{ #category : 'private - naming' }
FamixOpenApiJsonVisitor >> operationNameForHttpMethod: anHttpMethod relativePath: aRelativePath [
	| normalizedMethod normalizedPath |
	normalizedMethod := self normalizedNameCandidateFrom: anHttpMethod.
	normalizedPath := self normalizedNameCandidateFrom: aRelativePath.
	normalizedMethod ifNotNil: [ normalizedMethod := normalizedMethod asUppercase ].
	normalizedMethod ifNil: [ ^ normalizedPath ].
	normalizedPath ifNil: [ ^ normalizedMethod ].
	^ normalizedMethod , ' ' , normalizedPath
]

{ #category : 'private - naming' }
FamixOpenApiJsonVisitor >> setNameOn: anEntity fromCandidates: aCollection [
	| candidate |
	candidate := self firstNormalizedNameCandidateIn: aCollection.
	candidate ifNotNil: [ self setProperty: #name on: anEntity to: candidate ]
]

{ #category : 'private - json' }
FamixOpenApiJsonVisitor >> valueAt: aJsonKey in: aDictionary ifPresent: aBlock [
	| value |
	(self isDictionaryLike: aDictionary) ifFalse: [ ^ self ].
	value := self
		jsonValueAt: aJsonKey
		in: aDictionary
		ifAbsent: [ ^ self ].
	value isNil ifFalse: [ aBlock value: value ]
]

{ #category : 'accessing' }
FamixOpenApiJsonVisitor >> model [
	^ model
]

{ #category : 'accessing' }
FamixOpenApiJsonVisitor >> model: aModel [
	model := aModel
]

{ #category : 'importing' }
FamixOpenApiJsonVisitor >> modelFromJsonFile: aPathOrFileReference [
	^ self modelFromJsonString: aPathOrFileReference asFileReference contents
]

{ #category : 'importing' }
FamixOpenApiJsonVisitor >> modelFromJsonString: aJsonString [
	| rootNode |
	self newModel.
	rootNode := NeoJSONReader fromString: aJsonString.
	self visitApiNode: rootNode.
	^ model
]

{ #category : 'visiting' }
FamixOpenApiJsonVisitor >> visitApiNode: anApiNode [
	| api infoTitle |
	(self isDictionaryLike: anApiNode) ifFalse: [ ^ nil ].

	api := self newEntityNamed: #Api.
	self copyValueAt: 'host' from: anApiNode to: api property: #host.
	self copyValueAt: 'basePath' from: anApiNode to: api property: #basePath.
	self copyValueAt: 'schemes' from: anApiNode to: api property: #schemes.
	self copyValueAt: 'consumes' from: anApiNode to: api property: #consumes.
	self copyValueAt: 'produces' from: anApiNode to: api property: #produces.

	self
		valueAt: 'info'
		in: anApiNode
		ifPresent: [ :infoNode |
			| info |
			info := self visitInfoNode: infoNode.
			info ifNotNil: [
				self setProperty: #info on: api to: info.
				infoTitle := (info respondsTo: #title) ifTrue: [ info title ] ] ].

	self
		valueAt: 'paths'
		in: anApiNode
		ifPresent: [ :pathsNode | self visitPathsNode: pathsNode forApi: api ].

	self
		valueAt: 'tags'
		in: anApiNode
		ifPresent: [ :tagsNode | self visitTagsNode: tagsNode forApi: api ].

	self
		setNameOn: api
		fromCandidates: {
				infoTitle.
				(self jsonValueAt: 'host' in: anApiNode ifAbsent: [ nil ]).
				(self jsonValueAt: 'basePath' in: anApiNode ifAbsent: [ nil ]).
				'Api' }.

	^ api
]

{ #category : 'visiting' }
FamixOpenApiJsonVisitor >> visitContactNode: aContactNode [
	| contact |
	(self isDictionaryLike: aContactNode) ifFalse: [ ^ nil ].

	contact := self newEntityNamed: #Contact.
	self copyValueAt: 'name' from: aContactNode to: contact property: #name.
	self copyValueAt: 'url' from: aContactNode to: contact property: #url.
	self copyValueAt: 'email' from: aContactNode to: contact property: #email.
	self
		setNameOn: contact
		fromCandidates: {
				(self jsonValueAt: 'name' in: aContactNode ifAbsent: [ nil ]).
				(self jsonValueAt: 'url' in: aContactNode ifAbsent: [ nil ]).
				(self jsonValueAt: 'email' in: aContactNode ifAbsent: [ nil ]).
				'Contact' }.
	^ contact
]

{ #category : 'visiting' }
FamixOpenApiJsonVisitor >> visitInfoNode: anInfoNode [
	| info |
	(self isDictionaryLike: anInfoNode) ifFalse: [ ^ nil ].

	info := self newEntityNamed: #Info.
	self copyValueAt: 'title' from: anInfoNode to: info property: #title.
	self copyValueAt: 'description' from: anInfoNode to: info property: #description.
	self copyValueAt: 'termsOfService' from: anInfoNode to: info property: #termsOfService.
	self copyValueAt: 'version' from: anInfoNode to: info property: #version.

	self
		valueAt: 'contact'
		in: anInfoNode
		ifPresent: [ :contactNode |
			| contact |
			contact := self visitContactNode: contactNode.
			contact ifNotNil: [ self setProperty: #contact on: info to: contact ] ].

	self
		valueAt: 'license'
		in: anInfoNode
		ifPresent: [ :licenseNode |
			| license |
			license := self visitLicenseNode: licenseNode.
			license ifNotNil: [ self setProperty: #license on: info to: license ] ].

	self
		setNameOn: info
		fromCandidates: {
				(self jsonValueAt: 'title' in: anInfoNode ifAbsent: [ nil ]).
				(self jsonValueAt: 'version' in: anInfoNode ifAbsent: [ nil ]).
				'Info' }.

	^ info
]

{ #category : 'visiting' }
FamixOpenApiJsonVisitor >> visitLicenseNode: aLicenseNode [
	| license |
	(self isDictionaryLike: aLicenseNode) ifFalse: [ ^ nil ].

	license := self newEntityNamed: #License.
	self copyValueAt: 'name' from: aLicenseNode to: license property: #name.
	self copyValueAt: 'url' from: aLicenseNode to: license property: #url.
	self
		setNameOn: license
		fromCandidates: {
				(self jsonValueAt: 'name' in: aLicenseNode ifAbsent: [ nil ]).
				(self jsonValueAt: 'url' in: aLicenseNode ifAbsent: [ nil ]).
				'License' }.
	^ license
]

{ #category : 'visiting' }
FamixOpenApiJsonVisitor >> visitOperationIn: aPathNode httpMethod: anHttpMethod relation: aRelationName forPath: aPath [
	self
		valueAt: anHttpMethod
		in: aPathNode
		ifPresent: [ :operationNode |
			| operation |
			operation := self
				visitOperationNode: operationNode
				httpMethod: anHttpMethod
				relativePath: ((aPath respondsTo: #relativePath) ifTrue: [ aPath relativePath ]).
			operation ifNotNil: [ self setProperty: aRelationName on: aPath to: operation ] ]
]

{ #category : 'visiting' }
FamixOpenApiJsonVisitor >> visitOperationNode: anOperationNode httpMethod: anHttpMethod relativePath: aRelativePath [
	| operation |
	(self isDictionaryLike: anOperationNode) ifFalse: [ ^ nil ].

	operation := self newEntityNamed: #Operation.
	self copyValueAt: 'tags' from: anOperationNode to: operation property: #tagReferences.
	self copyValueAt: 'summary' from: anOperationNode to: operation property: #summary.
	self copyValueAt: 'description' from: anOperationNode to: operation property: #description.
	self copyValueAt: 'operationId' from: anOperationNode to: operation property: #operationId.
	self copyValueAt: 'consumes' from: anOperationNode to: operation property: #consumes.
	self copyValueAt: 'produces' from: anOperationNode to: operation property: #produces.
	self copyValueAt: 'schemes' from: anOperationNode to: operation property: #schemes.
	self copyValueAt: 'deprecated' from: anOperationNode to: operation property: #deprecated.

	self
		valueAt: 'responses'
		in: anOperationNode
		ifPresent: [ :responsesNode | self visitResponsesNode: responsesNode forOperation: operation ].

	self
		setNameOn: operation
		fromCandidates: {
				(self jsonValueAt: 'operationId' in: anOperationNode ifAbsent: [ nil ]).
				(self jsonValueAt: 'summary' in: anOperationNode ifAbsent: [ nil ]).
				(self operationNameForHttpMethod: anHttpMethod relativePath: aRelativePath).
				'Operation' }.

	^ operation
]

{ #category : 'visiting' }
FamixOpenApiJsonVisitor >> visitPathNode: aPathNode relativePath: aRelativePath [
	| path |
	(self isDictionaryLike: aPathNode) ifFalse: [ ^ nil ].

	path := self newEntityNamed: #Path.
	self setProperty: #relativePath on: path to: aRelativePath.
	self copyValueAt: 'summary' from: aPathNode to: path property: #summary.
	self copyValueAt: 'description' from: aPathNode to: path property: #description.
	self setNameOn: path fromCandidates: { aRelativePath. 'Path' }.

	self visitOperationIn: aPathNode httpMethod: 'get' relation: #get forPath: path.
	self visitOperationIn: aPathNode httpMethod: 'put' relation: #put forPath: path.
	self visitOperationIn: aPathNode httpMethod: 'post' relation: #post forPath: path.
	self visitOperationIn: aPathNode httpMethod: 'delete' relation: #delete forPath: path.
	self visitOperationIn: aPathNode httpMethod: 'options' relation: #options forPath: path.
	self visitOperationIn: aPathNode httpMethod: 'head' relation: #head forPath: path.
	self visitOperationIn: aPathNode httpMethod: 'patch' relation: #patch forPath: path.

	^ path
]

{ #category : 'visiting' }
FamixOpenApiJsonVisitor >> visitPathsNode: aPathsNode forApi: anApi [
	(self isDictionaryLike: aPathsNode) ifFalse: [ ^ self ].

	aPathsNode keysAndValuesDo: [ :relativePath :pathNode |
		| path |
		path := self visitPathNode: pathNode relativePath: relativePath asString.
		path ifNotNil: [
			self add: path toManyProperty: #paths of: anApi.
			self setProperty: #api on: path to: anApi ] ]
]

{ #category : 'visiting' }
FamixOpenApiJsonVisitor >> visitResponseNode: aResponseNode responseKey: aResponseKey [
	| response |
	(self isDictionaryLike: aResponseNode) ifFalse: [ ^ nil ].

	response := self newEntityNamed: #Response.
	self copyValueAt: 'description' from: aResponseNode to: response property: #description.
	self
		setNameOn: response
		fromCandidates: {
				(self jsonValueAt: 'description' in: aResponseNode ifAbsent: [ nil ]).
				aResponseKey.
				'Response' }.
	^ response
]

{ #category : 'visiting' }
FamixOpenApiJsonVisitor >> visitResponsesNode: aResponsesNode forOperation: anOperation [
	(self isDictionaryLike: aResponsesNode) ifFalse: [ ^ self ].

	aResponsesNode keysAndValuesDo: [ :responseKey :responseNode |
		| entry keyString response |
		keyString := responseKey asString.
		entry := self newEntityNamed: #ResponseEntry.
		self setProperty: #key on: entry to: keyString.
		self setNameOn: entry fromCandidates: { keyString. 'ResponseEntry' }.
		response := self visitResponseNode: responseNode responseKey: keyString.
		response ifNotNil: [ self setProperty: #value on: entry to: response ].
		self add: entry toManyProperty: #responses of: anOperation ]
]

{ #category : 'visiting' }
FamixOpenApiJsonVisitor >> visitTagNode: aTagNode [
	| tag |
	(self isDictionaryLike: aTagNode) ifFalse: [ ^ nil ].

	tag := self newEntityNamed: #Tag.
	self copyValueAt: 'name' from: aTagNode to: tag property: #name.
	self copyValueAt: 'description' from: aTagNode to: tag property: #description.
	self
		setNameOn: tag
		fromCandidates: {
				(self jsonValueAt: 'name' in: aTagNode ifAbsent: [ nil ]).
				(self jsonValueAt: 'description' in: aTagNode ifAbsent: [ nil ]).
				'Tag' }.
	^ tag
]

{ #category : 'visiting' }
FamixOpenApiJsonVisitor >> visitTagsNode: aTagsNode forApi: anApi [
	(self isSequenceLike: aTagsNode) ifFalse: [ ^ self ].

	aTagsNode do: [ :tagNode |
		| tag |
		tag := self visitTagNode: tagNode.
		tag ifNotNil: [
			self add: tag toManyProperty: #tags of: anApi.
			self setProperty: #anApi on: tag to: anApi ] ]
]
