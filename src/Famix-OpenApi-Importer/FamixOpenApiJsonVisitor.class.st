Class {
	#name : 'FamixOpenApiJsonVisitor',
	#superclass : 'Object',
	#instVars : [
		'model',
		'referenceIndex'
	],
	#category : 'Famix-OpenApi-Importer',
	#package : 'Famix-OpenApi-Importer'
}

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

{ #category : 'private - references' }
FamixOpenApiJsonVisitor >> componentOwnerPropertyForSection: aSectionName [
	aSectionName = 'schemas' ifTrue: [ ^ #schemas ].
	aSectionName = 'responses' ifTrue: [ ^ #responses ].
	aSectionName = 'parameters' ifTrue: [ ^ #parameters ].
	aSectionName = 'requestBodies' ifTrue: [ ^ #requestBodies ].
	aSectionName = 'headers' ifTrue: [ ^ #headers ].
	aSectionName = 'examples' ifTrue: [ ^ #examples ].
	aSectionName = 'links' ifTrue: [ ^ #links ].
	aSectionName = 'callbacks' ifTrue: [ ^ #callbacks ].
	aSectionName = 'securitySchemes' ifTrue: [ ^ #securitySchemes ].
	^ nil
]

{ #category : 'private - references' }
FamixOpenApiJsonVisitor >> componentReferenceForSection: aSectionName key: aKey [
	^ '#/components/' , aSectionName , '/' , (self escapeJsonPointerToken: aKey asString)
]

{ #category : 'private - references' }
FamixOpenApiJsonVisitor >> componentValueForSection: aSectionName key: aKey [
	| components entries matchingEntry ownerProperty |
	components := self firstEntityNamed: #Components.
	components ifNil: [ ^ nil ].
	ownerProperty := self componentOwnerPropertyForSection: aSectionName.
	ownerProperty ifNil: [ ^ nil ].
	(components respondsTo: ownerProperty) ifFalse: [ ^ nil ].
	entries := components perform: ownerProperty.
	entries ifNil: [ ^ nil ].
	matchingEntry := entries
		detect: [ :each |
			(each respondsTo: #key)
				and: [ each key asString = aKey asString ] ]
		ifNone: [ nil ].
	matchingEntry ifNil: [ ^ nil ].
	^ (matchingEntry respondsTo: #value)
		ifTrue: [ matchingEntry value ]
		ifFalse: [ nil ]
]

{ #category : 'private - json' }
FamixOpenApiJsonVisitor >> copyReferenceFrom: aDictionary to: anEntity [
	| reference |
	reference := self
		jsonValueAt: '$ref'
		in: aDictionary
		ifAbsent: [ ^ self ].
	self setProperty: #ref on: anEntity to: reference.
	self registerEntity: anEntity forReference: reference
]

{ #category : 'private - json' }
FamixOpenApiJsonVisitor >> copyValueAt: aJsonKey from: aDictionary to: anEntity property: aPropertyName [
	self
		valueAt: aJsonKey
		in: aDictionary
		ifPresent: [ :value | self setProperty: aPropertyName on: anEntity to: value ]
]

{ #category : 'private - model' }
FamixOpenApiJsonVisitor >> createEntryNamed: anEntryName key: aKey value: aValue [
	^ self createEntryNamed: anEntryName key: aKey value: aValue sourceNode: nil
]

{ #category : 'private - model' }
FamixOpenApiJsonVisitor >> createEntryNamed: anEntryName key: aKey value: aValue sourceNode: aSourceNode [
	| entry keyString |
	keyString := aKey asString.
	entry := self newEntityNamed: anEntryName.
	self setSourceTextOn: entry fromJsonNode: aSourceNode.
	self setProperty: #key on: entry to: keyString.
	self setNameOn: entry fromCandidates: { keyString. anEntryName asString }.
	aValue ifNotNil: [ self setProperty: #value on: entry to: aValue ].
	^ entry
]

{ #category : 'private - references' }
FamixOpenApiJsonVisitor >> ensureReference: aReference onEntity: anEntity [
	| currentReference |
	(anEntity respondsTo: #ref) ifFalse: [ ^ self ].
	currentReference := anEntity perform: #ref.
	(currentReference isNil or: [ currentReference asString isEmpty ])
		ifTrue: [ self setProperty: #ref on: anEntity to: aReference ]
]

{ #category : 'private - model' }
FamixOpenApiJsonVisitor >> entityClassNamed: anEntityName [
	| generatedClassName |
	generatedClassName := (FamixOpenApiGenerator prefix asString , anEntityName asString) asSymbol.
	^ Smalltalk globals
		at: generatedClassName
		ifAbsent: [ self error: 'Missing generated class: ', generatedClassName asString ]
]

{ #category : 'private - references' }
FamixOpenApiJsonVisitor >> escapeJsonPointerToken: aToken [
	^ (aToken asString copyReplaceAll: '~' with: '~0')
		copyReplaceAll: '/' with: '~1'
]

{ #category : 'private - model' }
FamixOpenApiJsonVisitor >> firstEntityNamed: anEntityName [
	| entities entityClass |
	entityClass := self entityClassNamed: anEntityName.
	entities := model allWithType: entityClass.
	entities isEmpty ifTrue: [ ^ nil ].
	^ entities anyOne
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

{ #category : 'private - references' }
FamixOpenApiJsonVisitor >> isEntity: anEntity compatibleWith: anEntityName [
	| expectedClass |
	anEntityName ifNil: [ ^ true ].
	anEntity ifNil: [ ^ false ].
	expectedClass := self entityClassNamed: anEntityName.
	^ anEntity class = expectedClass
]

{ #category : 'private - testing' }
FamixOpenApiJsonVisitor >> isSequenceLike: anObject [
	^ anObject isCollection and: [ anObject isString not ]
]

{ #category : 'private - references' }
FamixOpenApiJsonVisitor >> jsonPointerTokensFromReference: aReference [
	| body tokens |
	aReference ifNil: [ ^ #() ].
	(aReference asString beginsWith: '#/') ifFalse: [ ^ #() ].
	body := aReference asString allButFirst: 2.
	body isEmpty ifTrue: [ ^ #() ].
	tokens := body findTokens: '/'.
	^ tokens collect: [ :each | self unescapeJsonPointerToken: each ]
]

{ #category : 'private - json' }
FamixOpenApiJsonVisitor >> jsonValueAt: aJsonKey in: aDictionary ifAbsent: aBlock [
	(aDictionary includesKey: aJsonKey) ifTrue: [ ^ aDictionary at: aJsonKey ].
	(aDictionary includesKey: aJsonKey asSymbol) ifTrue: [ ^ aDictionary at: aJsonKey asSymbol ].
	^ aBlock value
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

{ #category : 'private - model' }
FamixOpenApiJsonVisitor >> newEntityNamed: anEntityName [
	| entity |
	entity := (self entityClassNamed: anEntityName) new.
	model add: entity.
	self setProperty: #name on: entity to: anEntityName asString.
	^ entity
]

{ #category : 'private - model' }
FamixOpenApiJsonVisitor >> newEntityNamed: anEntityName fromJsonNode: aJsonNode [
	| entity |
	entity := self newEntityNamed: anEntityName.
	self setSourceTextOn: entity fromJsonNode: aJsonNode.
	^ entity
]

{ #category : 'private - model' }
FamixOpenApiJsonVisitor >> newModel [
	model := (self entityClassNamed: #Model) new.
	referenceIndex := Dictionary new
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

{ #category : 'private - references' }
FamixOpenApiJsonVisitor >> pathReferenceForRelativePath: aRelativePath [
	^ '#/paths/' , (self escapeJsonPointerToken: aRelativePath asString)
]

{ #category : 'private - references' }
FamixOpenApiJsonVisitor >> pathWithRelativePath: aRelativePath [
	| api paths |
	api := self firstEntityNamed: #Api.
	api ifNil: [ ^ nil ].
	(api respondsTo: #paths) ifFalse: [ ^ nil ].
	paths := api paths.
	paths ifNil: [ ^ nil ].
	^ paths
		detect: [ :each |
			(each respondsTo: #relativePath)
				and: [ each relativePath asString = aRelativePath asString ] ]
		ifNone: [ nil ]
]

{ #category : 'private - references' }
FamixOpenApiJsonVisitor >> registerComponentValue: anEntity section: aSectionName key: aKey [
	| reference |
	reference := self componentReferenceForSection: aSectionName key: aKey.
	self registerEntity: anEntity forReference: reference.
	self ensureReference: reference onEntity: anEntity
]

{ #category : 'private - references' }
FamixOpenApiJsonVisitor >> registerEntity: anEntity forReference: aReference [
	| normalizedReference |
	anEntity ifNil: [ ^ self ].
	aReference ifNil: [ ^ self ].
	normalizedReference := aReference asString trimBoth.
	normalizedReference isEmpty ifTrue: [ ^ self ].
	referenceIndex at: normalizedReference put: anEntity
]

{ #category : 'private - references' }
FamixOpenApiJsonVisitor >> resolveReference: aReference expectedEntity: anEntityName [
	| normalizedReference resolved |
	aReference ifNil: [ ^ nil ].
	normalizedReference := aReference asString trimBoth.
	normalizedReference isEmpty ifTrue: [ ^ nil ].
	resolved := referenceIndex at: normalizedReference ifAbsent: [ nil ].
	resolved ifNil: [ resolved := self resolveReferenceByPath: normalizedReference ].
	(self isEntity: resolved compatibleWith: anEntityName) ifFalse: [ ^ nil ].
	resolved ifNotNil: [ self registerEntity: resolved forReference: normalizedReference ].
	^ resolved
]

{ #category : 'private - references' }
FamixOpenApiJsonVisitor >> resolveReferenceByPath: aReference [
	| key section tokens |
	tokens := self jsonPointerTokensFromReference: aReference.
	tokens size >= 3 ifTrue: [
		(tokens first = 'components') ifTrue: [
			section := tokens second.
			key := tokens third.
			^ self componentValueForSection: section key: key ] ].
	tokens size >= 2 ifTrue: [
		(tokens first = 'paths') ifTrue: [ ^ self pathWithRelativePath: tokens second ] ].
	^ nil
]

{ #category : 'private - references' }
FamixOpenApiJsonVisitor >> resolveReferenceIn: aNode expectedEntity: anEntityName [
	| reference |
	(self isDictionaryLike: aNode) ifFalse: [ ^ nil ].
	reference := self
		jsonValueAt: '$ref'
		in: aNode
		ifAbsent: [ ^ nil ].
	^ self resolveReference: reference expectedEntity: anEntityName
]

{ #category : 'private - visiting' }
FamixOpenApiJsonVisitor >> schemaRequiredPropertyNamesFrom: aSchemaNode [
	| requiredNames |
	requiredNames := Set new.
	self
		valueAt: 'required'
		in: aSchemaNode
		ifPresent: [ :requiredNode |
			(self isSequenceLike: requiredNode) ifTrue: [
				requiredNode do: [ :requiredName |
					requiredNames add: requiredName asString ] ] ].
	^ requiredNames
]

{ #category : 'private - naming' }
FamixOpenApiJsonVisitor >> setNameOn: anEntity fromCandidates: aCollection [
	| candidate |
	candidate := self firstNormalizedNameCandidateIn: aCollection.
	candidate ifNotNil: [ self setProperty: #name on: anEntity to: candidate ]
]

{ #category : 'private - writing' }
FamixOpenApiJsonVisitor >> setProperty: aPropertyName on: anEntity to: aValue [
	| setter |
	setter := (aPropertyName asString , ':') asSymbol.
	(anEntity respondsTo: setter) ifTrue: [ anEntity perform: setter with: aValue ]
]

{ #category : 'private - json' }
FamixOpenApiJsonVisitor >> setSourceTextOn: anEntity fromJsonNode: aJsonNode [
	| sourceText |
	sourceText := self sourceTextFromJsonNode: aJsonNode.
	sourceText ifNotNil: [ self setProperty: #sourceText on: anEntity to: sourceText ]
]

{ #category : 'private - json' }
FamixOpenApiJsonVisitor >> sourceTextFromJsonNode: aJsonNode [
	aJsonNode ifNil: [ ^ nil ].
	^ [ NeoJSONWriter toString: aJsonNode ]
		on: Error
		do: [ nil ]
]

{ #category : 'private - references' }
FamixOpenApiJsonVisitor >> unescapeJsonPointerToken: aToken [
	^ (aToken asString copyReplaceAll: '~1' with: '/')
		copyReplaceAll: '~0' with: '~'
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

{ #category : 'visiting' }
FamixOpenApiJsonVisitor >> visitApiNode: anApiNode [
	| api infoTitle |
	(self isDictionaryLike: anApiNode) ifFalse: [ ^ nil ].

	api := self newEntityNamed: #Api fromJsonNode: anApiNode.
	self copyValueAt: 'openapi' from: anApiNode to: api property: #openapi.
	self copyValueAt: 'host' from: anApiNode to: api property: #host.
	self copyValueAt: 'basePath' from: anApiNode to: api property: #basePath.
	self copyValueAt: 'schemes' from: anApiNode to: api property: #schemes.
	self copyValueAt: 'consumes' from: anApiNode to: api property: #consumes.
	self copyValueAt: 'produces' from: anApiNode to: api property: #produces.

	self
		valueAt: 'components'
		in: anApiNode
		ifPresent: [ :componentsNode | self visitComponentsNode: componentsNode forApi: api ].

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
FamixOpenApiJsonVisitor >> visitCallbackNode: aCallbackNode named: aCallbackName [
	| callback resolvedReference |
	(self isDictionaryLike: aCallbackNode) ifFalse: [ ^ nil ].
	resolvedReference := self resolveReferenceIn: aCallbackNode expectedEntity: #Callback.
	resolvedReference ifNotNil: [ ^ resolvedReference ].

	callback := self newEntityNamed: #Callback fromJsonNode: aCallbackNode.
	self copyReferenceFrom: aCallbackNode to: callback.
	self
		setNameOn: callback
		fromCandidates: {
				aCallbackName.
				(self jsonValueAt: '$ref' in: aCallbackNode ifAbsent: [ nil ]).
				'Callback' }.
	^ callback
]

{ #category : 'visiting' }
FamixOpenApiJsonVisitor >> visitComponentsNode: aComponentsNode forApi: anApi [
	| components |
	(self isDictionaryLike: aComponentsNode) ifFalse: [ ^ nil ].

	components := self newEntityNamed: #Components fromJsonNode: aComponentsNode.
	self setProperty: #api on: components to: anApi.
	self setProperty: #components on: anApi to: components.
	self setNameOn: components fromCandidates: { 'components' }.

	self
		valueAt: 'schemas'
		in: aComponentsNode
		ifPresent: [ :schemasNode |
			self
				visitMapNode: schemasNode
				forOwner: components
				ownerProperty: #schemas
				entryNamed: #SchemaEntry
				componentSection: 'schemas'
				parseValueWith: [ :schemaNode :schemaName |
					self visitSchemaNode: schemaNode named: schemaName ] ].

	self
		valueAt: 'responses'
		in: aComponentsNode
		ifPresent: [ :responsesNode |
			self
				visitMapNode: responsesNode
				forOwner: components
				ownerProperty: #responses
				entryNamed: #ResponseDefinitionEntry
				componentSection: 'responses'
				parseValueWith: [ :responseNode :responseName |
					self visitResponseNode: responseNode responseKey: responseName ] ].

	self
		valueAt: 'parameters'
		in: aComponentsNode
		ifPresent: [ :parametersNode |
			self
				visitMapNode: parametersNode
				forOwner: components
				ownerProperty: #parameters
				entryNamed: #ParameterEntry
				componentSection: 'parameters'
				parseValueWith: [ :parameterNode :parameterName |
					self visitParameterNode: parameterNode named: parameterName ] ].

	self
		valueAt: 'requestBodies'
		in: aComponentsNode
		ifPresent: [ :requestBodiesNode |
			self
				visitMapNode: requestBodiesNode
				forOwner: components
				ownerProperty: #requestBodies
				entryNamed: #RequestBodyEntry
				componentSection: 'requestBodies'
				parseValueWith: [ :requestBodyNode :requestBodyName |
					self visitRequestBodyNode: requestBodyNode named: requestBodyName ] ].

	self
		valueAt: 'securitySchemes'
		in: aComponentsNode
		ifPresent: [ :securitySchemesNode |
			self
				visitMapNode: securitySchemesNode
				forOwner: components
				ownerProperty: #securitySchemes
				entryNamed: #SecuritySchemeEntry
				componentSection: 'securitySchemes'
				parseValueWith: [ :securitySchemeNode :securitySchemeName |
					self visitSecuritySchemeNode: securitySchemeNode named: securitySchemeName ] ].

	self
		valueAt: 'headers'
		in: aComponentsNode
		ifPresent: [ :headersNode |
			self
				visitMapNode: headersNode
				forOwner: components
				ownerProperty: #headers
				entryNamed: #HeaderEntry
				componentSection: 'headers'
				parseValueWith: [ :headerNode :headerName |
					self visitHeaderNode: headerNode named: headerName ] ].

	self
		valueAt: 'examples'
		in: aComponentsNode
		ifPresent: [ :examplesNode |
			self
				visitMapNode: examplesNode
				forOwner: components
				ownerProperty: #examples
				entryNamed: #ExampleEntry
				componentSection: 'examples'
				parseValueWith: [ :exampleNode :exampleName |
					self visitExampleNode: exampleNode named: exampleName ] ].

	self
		valueAt: 'links'
		in: aComponentsNode
		ifPresent: [ :linksNode |
			self
				visitMapNode: linksNode
				forOwner: components
				ownerProperty: #links
				entryNamed: #LinkEntry
				componentSection: 'links'
				parseValueWith: [ :linkNode :linkName |
					self visitLinkNode: linkNode named: linkName ] ].

	self
		valueAt: 'callbacks'
		in: aComponentsNode
		ifPresent: [ :callbacksNode |
			self
				visitMapNode: callbacksNode
				forOwner: components
				ownerProperty: #callbacks
				entryNamed: #CallbackEntry
				componentSection: 'callbacks'
				parseValueWith: [ :callbackNode :callbackName |
					self visitCallbackNode: callbackNode named: callbackName ] ].

	^ components
]

{ #category : 'visiting' }
FamixOpenApiJsonVisitor >> visitContactNode: aContactNode [
	| contact |
	(self isDictionaryLike: aContactNode) ifFalse: [ ^ nil ].

	contact := self newEntityNamed: #Contact fromJsonNode: aContactNode.
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
FamixOpenApiJsonVisitor >> visitContentNode: aContentNode forContainer: aContainer [
	self
		visitMapNode: aContentNode
		forOwner: aContainer
		ownerProperty: #content
		entryNamed: #MediaTypeEntry
		parseValueWith: [ :mediaTypeNode :mediaTypeName |
			self visitMediaTypeNode: mediaTypeNode mediaType: mediaTypeName ]
]

{ #category : 'visiting' }
FamixOpenApiJsonVisitor >> visitExampleNode: anExampleNode named: anExampleName [
	| example resolvedReference |
	(self isDictionaryLike: anExampleNode) ifFalse: [ ^ nil ].
	resolvedReference := self resolveReferenceIn: anExampleNode expectedEntity: #Example.
	resolvedReference ifNotNil: [ ^ resolvedReference ].

	example := self newEntityNamed: #Example fromJsonNode: anExampleNode.
	self copyReferenceFrom: anExampleNode to: example.
	self copyValueAt: 'value' from: anExampleNode to: example property: #value.
	self
		setNameOn: example
		fromCandidates: {
				anExampleName.
				(self jsonValueAt: 'summary' in: anExampleNode ifAbsent: [ nil ]).
				(self jsonValueAt: '$ref' in: anExampleNode ifAbsent: [ nil ]).
				'Example' }.
	^ example
]

{ #category : 'visiting' }
FamixOpenApiJsonVisitor >> visitHeaderNode: aHeaderNode named: aHeaderName [
	| header resolvedReference |
	(self isDictionaryLike: aHeaderNode) ifFalse: [ ^ nil ].
	resolvedReference := self resolveReferenceIn: aHeaderNode expectedEntity: #Header.
	resolvedReference ifNotNil: [ ^ resolvedReference ].

	header := self newEntityNamed: #Header fromJsonNode: aHeaderNode.
	self copyReferenceFrom: aHeaderNode to: header.
	self copyValueAt: 'description' from: aHeaderNode to: header property: #description.
	self
		valueAt: 'schema'
		in: aHeaderNode
		ifPresent: [ :schemaNode |
			| schema |
			schema := self visitSchemaNode: schemaNode named: nil.
			schema ifNotNil: [ self setProperty: #schema on: header to: schema ] ].
	self
		setNameOn: header
		fromCandidates: {
				aHeaderName.
				(self jsonValueAt: '$ref' in: aHeaderNode ifAbsent: [ nil ]).
				'Header' }.
	^ header
]

{ #category : 'visiting' }
FamixOpenApiJsonVisitor >> visitInfoNode: anInfoNode [
	| info |
	(self isDictionaryLike: anInfoNode) ifFalse: [ ^ nil ].

	info := self newEntityNamed: #Info fromJsonNode: anInfoNode.
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

	license := self newEntityNamed: #License fromJsonNode: aLicenseNode.
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
FamixOpenApiJsonVisitor >> visitLinkNode: aLinkNode named: aLinkName [
	| link resolvedReference |
	(self isDictionaryLike: aLinkNode) ifFalse: [ ^ nil ].
	resolvedReference := self resolveReferenceIn: aLinkNode expectedEntity: #Link.
	resolvedReference ifNotNil: [ ^ resolvedReference ].

	link := self newEntityNamed: #Link fromJsonNode: aLinkNode.
	self copyReferenceFrom: aLinkNode to: link.
	self copyValueAt: 'operationRef' from: aLinkNode to: link property: #operationRef.
	self copyValueAt: 'operationId' from: aLinkNode to: link property: #operationId.
	self copyValueAt: 'requestBody' from: aLinkNode to: link property: #requestBody.
	self copyValueAt: 'description' from: aLinkNode to: link property: #description.
	self
		setNameOn: link
		fromCandidates: {
				aLinkName.
				(self jsonValueAt: 'operationId' in: aLinkNode ifAbsent: [ nil ]).
				(self jsonValueAt: 'operationRef' in: aLinkNode ifAbsent: [ nil ]).
				(self jsonValueAt: '$ref' in: aLinkNode ifAbsent: [ nil ]).
				'Link' }.
	^ link
]

{ #category : 'private - visiting' }
FamixOpenApiJsonVisitor >> visitMapNode: aMapNode forOwner: anOwner ownerProperty: anOwnerProperty entryNamed: anEntryName componentSection: aSectionName parseValueWith: aBlock [
	(self isDictionaryLike: aMapNode) ifFalse: [ ^ self ].

	aMapNode keysAndValuesDo: [ :rawKey :rawValue |
		| entry keyString value |
		keyString := rawKey asString.
		value := aBlock value: rawValue value: keyString.
		value ifNotNil: [ self registerComponentValue: value section: aSectionName key: keyString ].
		entry := self createEntryNamed: anEntryName key: rawKey value: value sourceNode: rawValue.
		self add: entry toManyProperty: anOwnerProperty of: anOwner ]
]

{ #category : 'private - visiting' }
FamixOpenApiJsonVisitor >> visitMapNode: aMapNode forOwner: anOwner ownerProperty: anOwnerProperty entryNamed: anEntryName parseValueWith: aBlock [
	(self isDictionaryLike: aMapNode) ifFalse: [ ^ self ].

	aMapNode keysAndValuesDo: [ :rawKey :rawValue |
		| entry value |
		value := aBlock value: rawValue value: rawKey asString.
		entry := self createEntryNamed: anEntryName key: rawKey value: value sourceNode: rawValue.
		self add: entry toManyProperty: anOwnerProperty of: anOwner ]
]

{ #category : 'visiting' }
FamixOpenApiJsonVisitor >> visitMediaTypeNode: aMediaTypeNode mediaType: aMediaTypeName [
	| mediaType |
	(self isDictionaryLike: aMediaTypeNode) ifFalse: [ ^ nil ].

	mediaType := self newEntityNamed: #MediaType fromJsonNode: aMediaTypeNode.
	self copyValueAt: 'example' from: aMediaTypeNode to: mediaType property: #example.
	self
		valueAt: 'schema'
		in: aMediaTypeNode
		ifPresent: [ :schemaNode |
			| schema |
			schema := self visitSchemaNode: schemaNode named: nil.
			schema ifNotNil: [ self setProperty: #schema on: mediaType to: schema ] ].
	self
		valueAt: 'examples'
		in: aMediaTypeNode
		ifPresent: [ :examplesNode |
			self
				visitMapNode: examplesNode
				forOwner: mediaType
				ownerProperty: #examples
				entryNamed: #ExampleEntry
				parseValueWith: [ :exampleNode :exampleName |
					self visitExampleNode: exampleNode named: exampleName ] ].
	self setNameOn: mediaType fromCandidates: { aMediaTypeName. 'MediaType' }.
	^ mediaType
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

	operation := self newEntityNamed: #Operation fromJsonNode: anOperationNode.
	self copyValueAt: 'tags' from: anOperationNode to: operation property: #tagReferences.
	self copyValueAt: 'summary' from: anOperationNode to: operation property: #summary.
	self copyValueAt: 'description' from: anOperationNode to: operation property: #description.
	self copyValueAt: 'operationId' from: anOperationNode to: operation property: #operationId.
	self copyValueAt: 'consumes' from: anOperationNode to: operation property: #consumes.
	self copyValueAt: 'produces' from: anOperationNode to: operation property: #produces.
	self copyValueAt: 'schemes' from: anOperationNode to: operation property: #schemes.
	self copyValueAt: 'deprecated' from: anOperationNode to: operation property: #deprecated.

	self
		valueAt: 'parameters'
		in: anOperationNode
		ifPresent: [ :parametersNode |
			self visitParametersNode: parametersNode forOwner: operation ].

	self
		valueAt: 'responses'
		in: anOperationNode
		ifPresent: [ :responsesNode | self visitResponsesNode: responsesNode forOperation: operation ].

	self
		valueAt: 'requestBody'
		in: anOperationNode
		ifPresent: [ :requestBodyNode |
			| requestBody |
			requestBody := self visitRequestBodyNode: requestBodyNode named: nil.
			requestBody ifNotNil: [ self setProperty: #requestBody on: operation to: requestBody ] ].

	self
		valueAt: 'callbacks'
		in: anOperationNode
		ifPresent: [ :callbacksNode |
			self
				visitMapNode: callbacksNode
				forOwner: operation
				ownerProperty: #callbacks
				entryNamed: #CallbackEntry
				parseValueWith: [ :callbackNode :callbackName |
					self visitCallbackNode: callbackNode named: callbackName ] ].

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
FamixOpenApiJsonVisitor >> visitParameterNode: aParameterNode named: aParameterName [
	| parameter resolvedReference |
	(self isDictionaryLike: aParameterNode) ifFalse: [ ^ nil ].
	resolvedReference := self resolveReferenceIn: aParameterNode expectedEntity: #Parameter.
	resolvedReference ifNotNil: [ ^ resolvedReference ].

	parameter := self newEntityNamed: #Parameter fromJsonNode: aParameterNode.
	self copyReferenceFrom: aParameterNode to: parameter.
	self copyValueAt: 'name' from: aParameterNode to: parameter property: #name.
	self copyValueAt: 'in' from: aParameterNode to: parameter property: #location.
	self copyValueAt: 'required' from: aParameterNode to: parameter property: #required.
	self copyValueAt: 'description' from: aParameterNode to: parameter property: #description.
	self
		valueAt: 'schema'
		in: aParameterNode
		ifPresent: [ :schemaNode |
			| schema |
			schema := self visitSchemaNode: schemaNode named: nil.
			schema ifNotNil: [ self setProperty: #schema on: parameter to: schema ] ].
	self
		setNameOn: parameter
		fromCandidates: {
				(self jsonValueAt: 'name' in: aParameterNode ifAbsent: [ nil ]).
				aParameterName.
				(self jsonValueAt: '$ref' in: aParameterNode ifAbsent: [ nil ]).
				'Parameter' }.
	^ parameter
]

{ #category : 'private - visiting' }
FamixOpenApiJsonVisitor >> visitParametersNode: aParametersNode forOwner: anOwner [
	(self isSequenceLike: aParametersNode) ifFalse: [ ^ self ].

	aParametersNode do: [ :parameterNode |
		| parameter |
		parameter := self visitParameterNode: parameterNode named: nil.
		parameter ifNotNil: [
			self add: parameter toManyProperty: #parameters of: anOwner.
			((parameter respondsTo: #declaringContext)
				and: [ parameter declaringContext notNil ])
				ifFalse: [ self setProperty: #declaringContext on: parameter to: anOwner ] ] ]
]

{ #category : 'visiting' }
FamixOpenApiJsonVisitor >> visitPathNode: aPathNode relativePath: aRelativePath [
	| path resolvedReference |
	(self isDictionaryLike: aPathNode) ifFalse: [ ^ nil ].
	resolvedReference := self resolveReferenceIn: aPathNode expectedEntity: #Path.
	resolvedReference ifNotNil: [ ^ resolvedReference ].

	path := self newEntityNamed: #Path fromJsonNode: aPathNode.
	self copyReferenceFrom: aPathNode to: path.
	self setProperty: #relativePath on: path to: aRelativePath.
	self copyValueAt: 'summary' from: aPathNode to: path property: #summary.
	self copyValueAt: 'description' from: aPathNode to: path property: #description.
	self setNameOn: path fromCandidates: { aRelativePath. 'Path' }.

	self
		valueAt: 'parameters'
		in: aPathNode
		ifPresent: [ :parametersNode |
			self visitParametersNode: parametersNode forOwner: path ].

	self visitOperationIn: aPathNode httpMethod: 'get' relation: #get forPath: path.
	self visitOperationIn: aPathNode httpMethod: 'put' relation: #put forPath: path.
	self visitOperationIn: aPathNode httpMethod: 'post' relation: #post forPath: path.
	self visitOperationIn: aPathNode httpMethod: 'delete' relation: #delete forPath: path.
	self visitOperationIn: aPathNode httpMethod: 'options' relation: #options forPath: path.
	self visitOperationIn: aPathNode httpMethod: 'head' relation: #head forPath: path.
	self visitOperationIn: aPathNode httpMethod: 'patch' relation: #patch forPath: path.
	self visitOperationIn: aPathNode httpMethod: 'trace' relation: #trace forPath: path.

	^ path
]

{ #category : 'visiting' }
FamixOpenApiJsonVisitor >> visitPathsNode: aPathsNode forApi: anApi [
	(self isDictionaryLike: aPathsNode) ifFalse: [ ^ self ].

	aPathsNode keysAndValuesDo: [ :relativePath :pathNode |
		| path pathReference relativePathString |
		path := self visitPathNode: pathNode relativePath: relativePath asString.
		path ifNotNil: [
			relativePathString := relativePath asString.
			pathReference := self pathReferenceForRelativePath: relativePathString.
			self registerEntity: path forReference: pathReference.
			self ensureReference: pathReference onEntity: path.
			self add: path toManyProperty: #paths of: anApi.
			self setProperty: #api on: path to: anApi ] ]
]

{ #category : 'private - visiting' }
FamixOpenApiJsonVisitor >> visitPropertiesNode: aPropertiesNode requiredNames: requiredNames forSchema: aSchema [
	(self isDictionaryLike: aPropertiesNode) ifFalse: [ ^ self ].

	aPropertiesNode keysAndValuesDo: [ :propertyName :propertyNode |
		| property |
		property := self
			visitPropertyNode: propertyNode
			named: propertyName asString
			isRequired: (requiredNames includes: propertyName asString).
		property ifNotNil: [
			self add: property toManyProperty: #properties of: aSchema.
			self setProperty: #schema on: property to: aSchema ] ]
]

{ #category : 'visiting' }
FamixOpenApiJsonVisitor >> visitPropertyNode: aPropertyNode named: aPropertyName isRequired: aBoolean [
	| property |
	(self isDictionaryLike: aPropertyNode) ifFalse: [ ^ nil ].

	property := self newEntityNamed: #Property fromJsonNode: aPropertyNode.
	self setProperty: #required on: property to: aBoolean.
	self
		setNameOn: property
		fromCandidates: {
				aPropertyName.
				(self jsonValueAt: 'title' in: aPropertyNode ifAbsent: [ nil ]).
				(self jsonValueAt: '$ref' in: aPropertyNode ifAbsent: [ nil ]).
				'Property' }.
	^ property
]

{ #category : 'visiting' }
FamixOpenApiJsonVisitor >> visitRequestBodyNode: aRequestBodyNode named: aRequestBodyName [
	| requestBody resolvedReference |
	(self isDictionaryLike: aRequestBodyNode) ifFalse: [ ^ nil ].
	resolvedReference := self resolveReferenceIn: aRequestBodyNode expectedEntity: #RequestBody.
	resolvedReference ifNotNil: [ ^ resolvedReference ].

	requestBody := self newEntityNamed: #RequestBody fromJsonNode: aRequestBodyNode.
	self copyReferenceFrom: aRequestBodyNode to: requestBody.
	self copyValueAt: 'description' from: aRequestBodyNode to: requestBody property: #description.
	self copyValueAt: 'required' from: aRequestBodyNode to: requestBody property: #required.
	self
		valueAt: 'content'
		in: aRequestBodyNode
		ifPresent: [ :contentNode | self visitContentNode: contentNode forContainer: requestBody ].
	self
		setNameOn: requestBody
		fromCandidates: {
				aRequestBodyName.
				(self jsonValueAt: 'description' in: aRequestBodyNode ifAbsent: [ nil ]).
				(self jsonValueAt: '$ref' in: aRequestBodyNode ifAbsent: [ nil ]).
				'RequestBody' }.
	^ requestBody
]

{ #category : 'visiting' }
FamixOpenApiJsonVisitor >> visitResponseNode: aResponseNode responseKey: aResponseKey [
	| resolvedReference response |
	(self isDictionaryLike: aResponseNode) ifFalse: [ ^ nil ].
	resolvedReference := self resolveReferenceIn: aResponseNode expectedEntity: #Response.
	resolvedReference ifNotNil: [ ^ resolvedReference ].

	response := self newEntityNamed: #Response fromJsonNode: aResponseNode.
	self copyReferenceFrom: aResponseNode to: response.
	self copyValueAt: 'description' from: aResponseNode to: response property: #description.
	self
		valueAt: 'content'
		in: aResponseNode
		ifPresent: [ :contentNode | self visitContentNode: contentNode forContainer: response ].
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
		| entry response |
		response := self visitResponseNode: responseNode responseKey: responseKey asString.
		entry := self createEntryNamed: #ResponseEntry key: responseKey value: response sourceNode: responseNode.
		self add: entry toManyProperty: #responses of: anOperation ]
]

{ #category : 'visiting' }
FamixOpenApiJsonVisitor >> visitSchemaNode: aSchemaNode named: aSchemaName [
	| requiredPropertyNames resolvedReference schema |
	(self isDictionaryLike: aSchemaNode) ifFalse: [ ^ nil ].
	resolvedReference := self resolveReferenceIn: aSchemaNode expectedEntity: #Schema.
	resolvedReference ifNotNil: [ ^ resolvedReference ].

	schema := self newEntityNamed: #Schema fromJsonNode: aSchemaNode.
	self copyReferenceFrom: aSchemaNode to: schema.
	self copyValueAt: 'title' from: aSchemaNode to: schema property: #title.
	self copyValueAt: 'type' from: aSchemaNode to: schema property: #type.
	self copyValueAt: 'format' from: aSchemaNode to: schema property: #format.
	self copyValueAt: 'description' from: aSchemaNode to: schema property: #description.
	self copyValueAt: 'readOnly' from: aSchemaNode to: schema property: #readOnly.
	self copyValueAt: 'example' from: aSchemaNode to: schema property: #example.
	requiredPropertyNames := self schemaRequiredPropertyNamesFrom: aSchemaNode.
	self
		valueAt: 'properties'
		in: aSchemaNode
		ifPresent: [ :propertiesNode |
			self
				visitPropertiesNode: propertiesNode
				requiredNames: requiredPropertyNames
				forSchema: schema ].
	self
		valueAt: 'items'
		in: aSchemaNode
		ifPresent: [ :itemsNode |
			| itemsSchema |
			itemsSchema := self visitSchemaNode: itemsNode named: nil.
			itemsSchema ifNotNil: [ self setProperty: #items on: schema to: itemsSchema ] ].
	self
		setNameOn: schema
		fromCandidates: {
				(self jsonValueAt: 'title' in: aSchemaNode ifAbsent: [ nil ]).
				aSchemaName.
				(self jsonValueAt: '$ref' in: aSchemaNode ifAbsent: [ nil ]).
				'Schema' }.
	^ schema
]

{ #category : 'visiting' }
FamixOpenApiJsonVisitor >> visitSecuritySchemeNode: aSecuritySchemeNode named: aSecuritySchemeName [
	| resolvedReference securityScheme |
	(self isDictionaryLike: aSecuritySchemeNode) ifFalse: [ ^ nil ].
	resolvedReference := self resolveReferenceIn: aSecuritySchemeNode expectedEntity: #SecurityScheme.
	resolvedReference ifNotNil: [ ^ resolvedReference ].

	securityScheme := self newEntityNamed: #SecurityScheme fromJsonNode: aSecuritySchemeNode.
	self copyReferenceFrom: aSecuritySchemeNode to: securityScheme.
	self copyValueAt: 'name' from: aSecuritySchemeNode to: securityScheme property: #name.
	self copyValueAt: 'type' from: aSecuritySchemeNode to: securityScheme property: #type.
	self copyValueAt: 'description' from: aSecuritySchemeNode to: securityScheme property: #description.
	self copyValueAt: 'in' from: aSecuritySchemeNode to: securityScheme property: #location.
	self copyValueAt: 'scheme' from: aSecuritySchemeNode to: securityScheme property: #scheme.
	self copyValueAt: 'bearerFormat' from: aSecuritySchemeNode to: securityScheme property: #bearerFormat.
	self copyValueAt: 'openIdConnectUrl' from: aSecuritySchemeNode to: securityScheme property: #openIdConnectUrl.
	self copyValueAt: 'flow' from: aSecuritySchemeNode to: securityScheme property: #flow.
	self copyValueAt: 'authorizationUrl' from: aSecuritySchemeNode to: securityScheme property: #authorizationUrl.
	self copyValueAt: 'tokenUrl' from: aSecuritySchemeNode to: securityScheme property: #tokenUrl.
	self
		setNameOn: securityScheme
		fromCandidates: {
				(self jsonValueAt: 'name' in: aSecuritySchemeNode ifAbsent: [ nil ]).
				aSecuritySchemeName.
				(self jsonValueAt: 'type' in: aSecuritySchemeNode ifAbsent: [ nil ]).
				(self jsonValueAt: '$ref' in: aSecuritySchemeNode ifAbsent: [ nil ]).
				'SecurityScheme' }.
	^ securityScheme
]

{ #category : 'visiting' }
FamixOpenApiJsonVisitor >> visitTagNode: aTagNode [
	| tag |
	(self isDictionaryLike: aTagNode) ifFalse: [ ^ nil ].

	tag := self newEntityNamed: #Tag fromJsonNode: aTagNode.
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
