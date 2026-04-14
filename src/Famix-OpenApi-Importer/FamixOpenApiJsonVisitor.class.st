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

{ #category : 'private - json' }
FamixOpenApiJsonVisitor >> copyReferenceFrom: aDictionary to: anEntity [
	self copyValueAt: '$ref' from: aDictionary to: anEntity property: #ref
]

{ #category : 'private - model' }
FamixOpenApiJsonVisitor >> createEntryNamed: anEntryName key: aKey value: aValue [
	| entry keyString |
	keyString := aKey asString.
	entry := self newEntityNamed: anEntryName.
	self setProperty: #key on: entry to: keyString.
	self setNameOn: entry fromCandidates: { keyString. anEntryName asString }.
	aValue ifNotNil: [ self setProperty: #value on: entry to: aValue ].
	^ entry
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
	self copyValueAt: 'openapi' from: anApiNode to: api property: #openapi.
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
		valueAt: 'components'
		in: anApiNode
		ifPresent: [ :componentsNode | self visitComponentsNode: componentsNode forApi: api ].

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

{ #category : 'private - visiting' }
FamixOpenApiJsonVisitor >> visitMapNode: aMapNode forOwner: anOwner ownerProperty: anOwnerProperty entryNamed: anEntryName parseValueWith: aBlock [
	(self isDictionaryLike: aMapNode) ifFalse: [ ^ self ].

	aMapNode keysAndValuesDo: [ :rawKey :rawValue |
		| entry value |
		value := aBlock value: rawValue value: rawKey asString.
		entry := self createEntryNamed: anEntryName key: rawKey value: value.
		self add: entry toManyProperty: anOwnerProperty of: anOwner ]
]

{ #category : 'visiting' }
FamixOpenApiJsonVisitor >> visitCallbackNode: aCallbackNode named: aCallbackName [
	| callback |
	(self isDictionaryLike: aCallbackNode) ifFalse: [ ^ nil ].

	callback := self newEntityNamed: #Callback.
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

	components := self newEntityNamed: #Components.
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
				parseValueWith: [ :callbackNode :callbackName |
					self visitCallbackNode: callbackNode named: callbackName ] ].

	^ components
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
	| example |
	(self isDictionaryLike: anExampleNode) ifFalse: [ ^ nil ].

	example := self newEntityNamed: #Example.
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
	| header |
	(self isDictionaryLike: aHeaderNode) ifFalse: [ ^ nil ].

	header := self newEntityNamed: #Header.
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
FamixOpenApiJsonVisitor >> visitLinkNode: aLinkNode named: aLinkName [
	| link |
	(self isDictionaryLike: aLinkNode) ifFalse: [ ^ nil ].

	link := self newEntityNamed: #Link.
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

{ #category : 'visiting' }
FamixOpenApiJsonVisitor >> visitMediaTypeNode: aMediaTypeNode mediaType: aMediaTypeName [
	| mediaType |
	(self isDictionaryLike: aMediaTypeNode) ifFalse: [ ^ nil ].

	mediaType := self newEntityNamed: #MediaType.
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
FamixOpenApiJsonVisitor >> visitParameterNode: aParameterNode named: aParameterName [
	| parameter |
	(self isDictionaryLike: aParameterNode) ifFalse: [ ^ nil ].

	parameter := self newEntityNamed: #Parameter.
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

{ #category : 'visiting' }
FamixOpenApiJsonVisitor >> visitRequestBodyNode: aRequestBodyNode named: aRequestBodyName [
	| requestBody |
	(self isDictionaryLike: aRequestBodyNode) ifFalse: [ ^ nil ].

	requestBody := self newEntityNamed: #RequestBody.
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
FamixOpenApiJsonVisitor >> visitSchemaNode: aSchemaNode named: aSchemaName [
	| schema |
	(self isDictionaryLike: aSchemaNode) ifFalse: [ ^ nil ].

	schema := self newEntityNamed: #Schema.
	self copyReferenceFrom: aSchemaNode to: schema.
	self copyValueAt: 'title' from: aSchemaNode to: schema property: #title.
	self copyValueAt: 'type' from: aSchemaNode to: schema property: #type.
	self copyValueAt: 'format' from: aSchemaNode to: schema property: #format.
	self copyValueAt: 'description' from: aSchemaNode to: schema property: #description.
	self copyValueAt: 'readOnly' from: aSchemaNode to: schema property: #readOnly.
	self copyValueAt: 'example' from: aSchemaNode to: schema property: #example.
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
	| securityScheme |
	(self isDictionaryLike: aSecuritySchemeNode) ifFalse: [ ^ nil ].

	securityScheme := self newEntityNamed: #SecurityScheme.
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
FamixOpenApiJsonVisitor >> visitPathNode: aPathNode relativePath: aRelativePath [
	| path |
	(self isDictionaryLike: aPathNode) ifFalse: [ ^ nil ].

	path := self newEntityNamed: #Path.
	self copyReferenceFrom: aPathNode to: path.
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
	self visitOperationIn: aPathNode httpMethod: 'trace' relation: #trace forPath: path.

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
		entry := self createEntryNamed: #ResponseEntry key: responseKey value: response.
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
