"
The entities the importer builds for a key of a node, derived from the keys of the source node (verified by import experiments, every version unless said): an OPDiscriminator at <schema>/discriminator when the schema has the key `discriminator` and no node of the document gives it (a string or a Swagger 2 object: rule swagger2Discriminator in Swagger 2, wrongShapeDiscriminator in OpenAPI 3 for a value that is not an object); an OPDiscriminatorMapping per key of the `mapping` object of an object discriminator (rule discriminatorMappingEntry); an OPExample at <node>/example for a media type or a parameter (the parameter the importer builds as an OPParameter) that has the key `example`, whatever its value, not for a header or a schema (rule scalarExample); an OPSecurityRequirementItem per key of a security requirement, even for an unknown scheme (rule securityRequirementItem); an OPSecurityScope per key of the `scopes` object of an OAuth flow (OpenAPI 3) or of an oauth2 scheme (Swagger 2) (rule securityScope).
"
Class {
	#name : 'FamixOpenApiKeyedEntities',
	#superclass : 'Object',
	#instVars : [
		'driver',
		'expectation'
	],
	#category : 'Famix-OpenApi-Validation',
	#package : 'Famix-OpenApi-Validation'
}

{ #category : 'instance creation' }
FamixOpenApiKeyedEntities class >> on: aSyntheticExpectations [

	^ self new
		  driver: aSyntheticExpectations;
		  yourself
]

{ #category : 'deriving' }
FamixOpenApiKeyedEntities >> derive [

	self deriveDiscriminators.
	self deriveExamples.
	self deriveRequirementItems.
	self deriveScopes
]

{ #category : 'deriving' }
FamixOpenApiKeyedEntities >> deriveDiscriminatorOf: aSchema [
	"An OPDiscriminator when no node of the document gives it, and the mapping entries"

	| pointer |
	(aSchema includesKey: 'discriminator') ifFalse: [ ^ self ].
	pointer := FamixOpenApiSourceNode
		           pointerOf: aSchema pointer
		           child: 'discriminator'.
	(driver expandedInventory hasObjectAt: pointer) ifFalse: [
		driver
			add: 'OPDiscriminator'
			at: pointer
			rule: (self discriminatorRuleOf: aSchema)
			origin: aSchema ].
	self deriveMappingOf: aSchema at: pointer
]

{ #category : 'deriving' }
FamixOpenApiKeyedEntities >> deriveDiscriminators [

	(driver eligibleNodesOf: 'Schema') do: [ :each |
		self deriveDiscriminatorOf: each ]
]

{ #category : 'deriving' }
FamixOpenApiKeyedEntities >> deriveExampleOf: anOwnerNode [

	(anOwnerNode includesKey: 'example') ifFalse: [ ^ self ].
	driver
		add: 'OPExample'
		at: (FamixOpenApiSourceNode
				 pointerOf: anOwnerNode pointer
				 child: 'example')
		rule: #scalarExample
		origin: anOwnerNode
]

{ #category : 'deriving' }
FamixOpenApiKeyedEntities >> deriveExamples [
	"The `example` of a media type, and of a parameter that the importer builds as an OPParameter"

	(driver eligibleNodesOf: 'MediaType') do: [ :each |
		self deriveExampleOf: each ].
	(driver eligibleNodesOf: 'Parameter')
		select: [ :each |
			(expectation expectedClassNamesFor: each) includes: 'OPParameter' ]
		thenDo: [ :each | self deriveExampleOf: each ]
]

{ #category : 'deriving' }
FamixOpenApiKeyedEntities >> deriveMappingOf: aSchema at: aDiscriminatorPointer [
	"One mapping entry per key of the mapping object of an object discriminator"

	| mapping base |
	mapping := (aSchema valueAt: 'discriminator') isDictionary ifTrue: [
		           (aSchema valueAt: 'discriminator')
			           at: 'mapping'
			           ifAbsent: [ nil ] ].
	mapping isDictionary ifFalse: [ ^ self ].
	base := FamixOpenApiSourceNode
		        pointerOf: aDiscriminatorPointer
		        child: 'mapping'.
	mapping keysDo: [ :key |
		driver
			add: 'OPDiscriminatorMapping'
			at: (FamixOpenApiSourceNode pointerOf: base child: key)
			rule: #discriminatorMappingEntry
			origin: aSchema ]
]

{ #category : 'deriving' }
FamixOpenApiKeyedEntities >> deriveRequirementItems [
	"One item per key of a security requirement, whatever the scheme"

	(driver eligibleNodesOf: 'SecurityRequirement') do: [ :each |
		each value keysDo: [ :key |
			driver
				add: 'OPSecurityRequirementItem'
				at: (FamixOpenApiSourceNode pointerOf: each pointer child: key)
				rule: #securityRequirementItem
				origin: each ] ]
]

{ #category : 'deriving' }
FamixOpenApiKeyedEntities >> deriveScopes [
	"The scopes of the OAuth flows (OpenAPI 3) and of the oauth2 schemes that hold their flow (Swagger 2)"

	(driver eligibleNodesOf: 'OAuthFlow') do: [ :each |
		self deriveScopesOf: each ].
	(driver eligibleNodesOf: 'SecurityScheme')
		select: [ :each |
			(expectation expectedClassNamesFor: each) includes: 'OPOAuthFlow' ]
		thenDo: [ :each | self deriveScopesOf: each ]
]

{ #category : 'deriving' }
FamixOpenApiKeyedEntities >> deriveScopesOf: anOwnerNode [
	"One scope per key of the scopes object, whatever the value"

	| scopes base |
	scopes := anOwnerNode valueAt: 'scopes'.
	scopes isDictionary ifFalse: [ ^ self ].
	base := FamixOpenApiSourceNode
		        pointerOf: anOwnerNode pointer
		        child: 'scopes'.
	scopes keysDo: [ :key |
		driver
			add: 'OPSecurityScope'
			at: (FamixOpenApiSourceNode pointerOf: base child: key)
			rule: #securityScope
			origin: anOwnerNode ]
]

{ #category : 'deriving' }
FamixOpenApiKeyedEntities >> discriminatorRuleOf: aSchema [

	^ aSchema version = #v2
		  ifTrue: [ #swagger2Discriminator ]
		  ifFalse: [ #wrongShapeDiscriminator ]
]

{ #category : 'deriving' }
FamixOpenApiKeyedEntities >> driver: aSyntheticExpectations [

	driver := aSyntheticExpectations.
	expectation := driver nodeExpectation
]
