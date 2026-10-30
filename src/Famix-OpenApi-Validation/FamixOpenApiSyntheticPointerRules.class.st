"
The documented exceptions of the reverse direction of the existence check: entities whose canonical pointer is not the pointer of a source node and that the importer builds on purpose (the rules are listed by #dataRules, with the versions they apply to and why). #ruleNameFor: answers the name of the rule that accepts an entity, nil when none does: the entity is then an #extraEntity. A rule does not accept an entity only for its pointer: it checks the source node the pointer derives from (the key of a scalar `example`, of a scope, of a mapping entry; the class of the entity; the version). The synthesised servers are NOT here: FamixOpenApiSynthesizedServers gives their urls and the check compares them.
"
Class {
	#name : 'FamixOpenApiSyntheticPointerRules',
	#superclass : 'Object',
	#instVars : [
		'inventory'
	],
	#category : 'Famix-OpenApi-Validation',
	#package : 'Famix-OpenApi-Validation'
}

{ #category : 'data' }
FamixOpenApiSyntheticPointerRules class >> dataDefaultMimeTypes [
	"The media types the importer uses when a Swagger 2 document declares no produces (response) or consumes (body parameter): one, any"

	^ #( '*/*' )
]

{ #category : 'data' }
FamixOpenApiSyntheticPointerRules class >> dataExampleOwners [
	"The spec objects whose `example` becomes an OPExample (a header's example does not)"

	^ #( 'Parameter' 'MediaType' )
]

{ #category : 'data' }
FamixOpenApiSyntheticPointerRules class >> dataRules [
	"Rows: rule name, versions, what the importer builds and why it has no source node"

	^ #( #( #cloneSubtree 'v2 v30 v31' 'Entity under the site of a $ref response or path item: the clone copies what its target holds (content, schema, headers, operations) at pointers below the site' )
	     #( #synthesizedServer 'v2 v30 v31' 'OPServer at #/servers/N: the default server of an OpenAPI 3 document without servers, the servers made from host, basePath and schemes in Swagger 2 (their urls are checked by FamixOpenApiSynthesizedServers)' )
	     #( #swagger2Components 'v2' 'OPComponents at #/components: Swagger 2 has no components, the importer builds them' )
	     #( #swagger2ParameterSchema 'v2' 'OPSchema at <parameter>/schema and <parameter>/schema/items...: the type, format and items of a typed parameter become a schema' )
	     #( #swagger2MediaType 'v2' 'OPMediaType at <response or body parameter>/content/<mime>: one per produces or consumes entry, all sharing the schema' )
	     #( #swagger2Discriminator 'v2' 'OPDiscriminator at <schema>/discriminator: the discriminator of Swagger 2 is a string, not an object' )
	     #( #swagger2FormDataRequestBody 'v2' 'Entities at <operation>/requestBody and below: the formData parameters become a request body' )
	     #( #securityScope 'v2 v30 v31' 'OPSecurityScope at <scheme or flow>/scopes/<name>: the keys of the scopes map' )
	     #( #securityRequirementItem 'v2 v30 v31' 'OPSecurityRequirementItem at <requirement>/<scheme name>: the keys of a security requirement' )
	     #( #discriminatorMappingEntry 'v30 v31' 'OPDiscriminatorMapping at <discriminator>/mapping/<key>: the keys of the mapping' )
	     #( #scalarExample 'v30 v31' 'OPExample at <parameter or media type>/example: built from the `example` value of the node' ) )
]

{ #category : 'instance creation' }
FamixOpenApiSyntheticPointerRules class >> on: aSourceInventory [

	^ self new
		  inventory: aSourceInventory;
		  yourself
]

{ #category : 'rules - swagger 2' }
FamixOpenApiSyntheticPointerRules >> declaredMimeTypesFor: aNode [
	"The list produces (response) or consumes (body parameter) of the nearest operation or root that has one"

	| key |
	key := (inventory siteSpecObjectOf: aNode) = 'Response'
		       ifTrue: [ 'produces' ]
		       ifFalse: [ 'consumes' ].
	^ (inventory ancestorsOf: aNode)
		  detect: [ :each | (each valueAt: key) isArray ]
		  ifFound: [ :each | each valueAt: key ]
		  ifNone: [ #(  ) ]
]

{ #category : 'rules' }
FamixOpenApiSyntheticPointerRules >> derivedRuleNameFor: anEntity [
	"Entities derived from a key of the node above their pointer"

	(self isSecurityScope: anEntity) ifTrue: [ ^ #securityScope ].
	(self isSecurityRequirementItem: anEntity) ifTrue: [
		^ #securityRequirementItem ].
	(self isDiscriminatorMapping: anEntity) ifTrue: [
		^ #discriminatorMappingEntry ].
	(self isScalarExample: anEntity) ifTrue: [ ^ #scalarExample ].
	^ self swagger2RuleNameFor: anEntity
]

{ #category : 'accessing' }
FamixOpenApiSyntheticPointerRules >> inventory: aSourceInventory [

	inventory := aSourceInventory
]

{ #category : 'rules - clones' }
FamixOpenApiSyntheticPointerRules >> isCloneSite: aReferenceNode [

	^ FamixOpenApiNodeExpectation dataCloneClassNames anySatisfy: [ :each |
		  each first = (inventory siteSpecObjectOf: aReferenceNode) ]
]

{ #category : 'rules - clones' }
FamixOpenApiSyntheticPointerRules >> isCloneSubtree: aPointer [
	"True when a $ref response or path item sits above aPointer: the clone holds copies of what its target holds"

	^ (inventory nodesAbovePointer: aPointer) anySatisfy: [ :each |
		  each isReference and: [ self isCloneSite: each ] ]
]

{ #category : 'rules - keys' }
FamixOpenApiSyntheticPointerRules >> isDiscriminatorMapping: anEntity [

	| owner |
	anEntity class == OPDiscriminatorMapping ifFalse: [ ^ false ].
	owner := self
		         ownerOfEntryAt: anEntity canonicalPointer
		         inMap: 'mapping'.
	^ owner isNotNil and: [ (inventory siteSpecObjectOf: owner) = 'Discriminator' ]
]

{ #category : 'rules - swagger 2' }
FamixOpenApiSyntheticPointerRules >> isFormDataRequestBody: aPointer [
	"True when aPointer is <operation>/requestBody or lies below it: the request body made from the formData parameters of a Swagger 2 operation"

	| pointer |
	pointer := aPointer.
	[ pointer isNotNil ] whileTrue: [
		(self isRequestBodyOfOperationAt: pointer) ifTrue: [ ^ true ].
		pointer := self parentPointerOf: pointer ].
	^ false
]

{ #category : 'rules - swagger 2' }
FamixOpenApiSyntheticPointerRules >> isRequestBodyOfOperationAt: aPointer [

	| operation |
	(aPointer includes: $/) ifFalse: [ ^ false ].
	(self keyOf: aPointer) = 'requestBody' ifFalse: [ ^ false ].
	operation := self nodeAt: (self parentPointerOf: aPointer).
	^ operation isNotNil and: [ (inventory siteSpecObjectOf: operation) = 'Operation' ]
]

{ #category : 'rules - keys' }
FamixOpenApiSyntheticPointerRules >> isScalarExample: anEntity [
	"An OPExample at <parameter or media type>/example, for a node that has an `example`"

	| owner |
	(anEntity class == OPExample and: [
		 (self keyOf: anEntity canonicalPointer) = 'example' ]) ifFalse: [
		^ false ].
	owner := self nodeAt:
		         (self parentPointerOf: anEntity canonicalPointer).
	^ owner isNotNil and: [
		  (self class dataExampleOwners includes: (inventory siteSpecObjectOf: owner))
			  and: [ owner includesKey: 'example' ] ]
]

{ #category : 'rules - keys' }
FamixOpenApiSyntheticPointerRules >> isSecurityRequirementItem: anEntity [
	"An item at <requirement>/<scheme name>"

	| requirement |
	anEntity class == OPSecurityRequirementItem ifFalse: [ ^ false ].
	requirement := self nodeAt:
		               (self parentPointerOf: anEntity canonicalPointer).
	^ requirement isNotNil and: [
		  (inventory siteSpecObjectOf: requirement) = 'SecurityRequirement' and: [
			  requirement includesKey: (self keyOf: anEntity canonicalPointer) ] ]
]

{ #category : 'rules - keys' }
FamixOpenApiSyntheticPointerRules >> isSecurityScope: anEntity [

	| owner |
	anEntity class == OPSecurityScope ifFalse: [ ^ false ].
	owner := self
		         ownerOfEntryAt: anEntity canonicalPointer
		         inMap: 'scopes'.
	^ owner isNotNil and: [
		  #( 'SecurityScheme' 'OAuthFlow' ) includes: (inventory siteSpecObjectOf: owner) ]
]

{ #category : 'rules - swagger 2' }
FamixOpenApiSyntheticPointerRules >> isSwagger2Components: anEntity [

	^ anEntity class == OPComponents and: [
		  anEntity canonicalPointer = '#/components' ]
]

{ #category : 'rules - swagger 2' }
FamixOpenApiSyntheticPointerRules >> isSwagger2Discriminator: anEntity [
	"An OPDiscriminator at <schema>/discriminator, for a schema whose discriminator is a string"

	| schema |
	(anEntity class == OPDiscriminator and: [
		 (self keyOf: anEntity canonicalPointer) = 'discriminator' ])
		ifFalse: [ ^ false ].
	schema := self nodeAt:
		          (self parentPointerOf: anEntity canonicalPointer).
	^ schema isNotNil and: [
		  (inventory siteSpecObjectOf: schema) = 'Schema' and: [
			  (schema valueAt: 'discriminator') isString ] ]
]

{ #category : 'rules - swagger 2' }
FamixOpenApiSyntheticPointerRules >> isSwagger2MediaType: anEntity [
	"An OPMediaType at <response or body parameter>/content/<mime>, for a mime type that the document declares (produces, consumes of the operation or of the root) or that is a default"

	| owner |
	anEntity class == OPMediaType ifFalse: [ ^ false ].
	owner := self ownerOfMediaTypeAt: anEntity canonicalPointer.
	^ owner isNotNil and: [
		  self
			  mimeTypes: owner
			  includes: (self keyOf: anEntity canonicalPointer) ]
]

{ #category : 'rules - swagger 2' }
FamixOpenApiSyntheticPointerRules >> isSwagger2ParameterSchema: anEntity [
	"An OPSchema at <parameter>/schema, or below it at <parameter>/schema/items... as deep as the items of the parameter"

	| pointer depth parameter |
	anEntity class == OPSchema ifFalse: [ ^ false ].
	pointer := anEntity canonicalPointer.
	depth := 0.
	[ (self keyOf: pointer) = 'items' ] whileTrue: [
		pointer := self parentPointerOf: pointer.
		depth := depth + 1 ].
	(self keyOf: pointer) = 'schema' ifFalse: [ ^ false ].
	parameter := self nodeAt: (self parentPointerOf: pointer).
	^ parameter isNotNil and: [
		  (inventory siteSpecObjectOf: parameter) = 'Parameter' and: [
			  (self itemsDepthOf: parameter) >= depth ] ]
]

{ #category : 'rules - servers' }
FamixOpenApiSyntheticPointerRules >> isSynthesizedServer: anEntity [
	"An OPServer at #/servers/N: the check compares their number and their urls"

	^ anEntity class == OPServer and: [
		  anEntity canonicalPointer isString and: [
			  anEntity canonicalPointer matchesRegex: '#/servers/\d+' ] ]
]

{ #category : 'rules - swagger 2' }
FamixOpenApiSyntheticPointerRules >> itemsDepthOf: aNode [
	"The number of nested items of the parameter aNode"

	| depth value |
	depth := 0.
	value := aNode value.
	[
	value isDictionary and: [
		(value at: 'items' ifAbsent: [ nil ]) isDictionary ] ] whileTrue: [
		value := value at: 'items'.
		depth := depth + 1 ].
	^ depth
]

{ #category : 'helpers' }
FamixOpenApiSyntheticPointerRules >> keyOf: aPointer [
	"The last token of the pointer, as the name it stands for"

	^ FamixOpenApiSourceNode unescapeToken: (aPointer copyAfterLast: $/)
]

{ #category : 'rules - swagger 2' }
FamixOpenApiSyntheticPointerRules >> mimeTypes: aNode includes: aString [
	"True when aString is one of the media types of the response (produces) or the body parameter aNode (consumes), declared by the operation above it or else by the root, or the default one when none is declared"

	| declared |
	declared := self declaredMimeTypesFor: aNode.
	^ declared isEmpty
		  ifTrue: [ self class dataDefaultMimeTypes includes: aString ]
		  ifFalse: [ declared includes: aString ]
]

{ #category : 'helpers' }
FamixOpenApiSyntheticPointerRules >> nodeAt: aPointer [
	"The node at aPointer, nil when there is none (also for a nil pointer)"

	^ aPointer ifNotNil: [ inventory nodeAt: aPointer ifAbsent: [ nil ] ]
]

{ #category : 'helpers' }
FamixOpenApiSyntheticPointerRules >> owner: aNode holds: aKey inMap: aFieldName [
	"Answer aNode when its map aFieldName has the key aKey, nil otherwise"

	| map |
	map := aNode valueAt: aFieldName.
	^ (map isDictionary and: [ map includesKey: aKey ])
		  ifTrue: [ aNode ]
		  ifFalse: [ nil ]
]

{ #category : 'helpers' }
FamixOpenApiSyntheticPointerRules >> ownerOfEntryAt: aPointer inMap: aFieldName [
	"aPointer is <owner>/<field>/<key>: the owner node when it holds a map aFieldName that has the key, else nil"

	| mapPointer owner |
	mapPointer := self parentPointerOf: aPointer.
	(mapPointer isNotNil and: [ (self keyOf: mapPointer) = aFieldName ])
		ifFalse: [ ^ nil ].
	owner := self nodeAt: (self parentPointerOf: mapPointer).
	owner ifNil: [ ^ nil ].
	^ self owner: owner holds: (self keyOf: aPointer) inMap: aFieldName
]

{ #category : 'rules - swagger 2' }
FamixOpenApiSyntheticPointerRules >> ownerOfMediaTypeAt: aPointer [
	"The response or parameter node of the pointer <owner>/content/<mime>, nil when it is another pointer"

	| contentPointer owner |
	contentPointer := self parentPointerOf: aPointer.
	(contentPointer isNotNil and: [
		 (self keyOf: contentPointer) = 'content' ]) ifFalse: [ ^ nil ].
	owner := self nodeAt: (self parentPointerOf: contentPointer).
	owner ifNil: [ ^ nil ].
	^ (#( 'Response' 'Parameter' ) includes: (inventory siteSpecObjectOf: owner))
		  ifTrue: [ owner ]
		  ifFalse: [ nil ]
]

{ #category : 'helpers' }
FamixOpenApiSyntheticPointerRules >> parentPointerOf: aPointer [
	"The pointer without its last token, nil for a pointer that has no token"

	(aPointer includes: $/) ifFalse: [ ^ nil ].
	^ aPointer copyUpToLast: $/
]

{ #category : 'rules' }
FamixOpenApiSyntheticPointerRules >> ruleNameFor: anEntity [
	"The name of the rule that accepts anEntity, which has no source node at its pointer; nil when no rule does"

	| pointer |
	pointer := anEntity canonicalPointer.
	pointer ifNil: [ ^ nil ].
	(self isCloneSubtree: pointer) ifTrue: [ ^ #cloneSubtree ].
	(self isSynthesizedServer: anEntity) ifTrue: [ ^ #synthesizedServer ].
	^ self derivedRuleNameFor: anEntity
]

{ #category : 'rules' }
FamixOpenApiSyntheticPointerRules >> swagger2RuleNameFor: anEntity [

	inventory version = #v2 ifFalse: [ ^ nil ].
	(self isSwagger2Components: anEntity) ifTrue: [
		^ #swagger2Components ].
	(self isSwagger2ParameterSchema: anEntity) ifTrue: [
		^ #swagger2ParameterSchema ].
	(self isSwagger2MediaType: anEntity) ifTrue: [ ^ #swagger2MediaType ].
	(self isSwagger2Discriminator: anEntity) ifTrue: [
		^ #swagger2Discriminator ].
	(self isFormDataRequestBody: anEntity canonicalPointer) ifTrue: [
		^ #swagger2FormDataRequestBody ].
	^ nil
]
