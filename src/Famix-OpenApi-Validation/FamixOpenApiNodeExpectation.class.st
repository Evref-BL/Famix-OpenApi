"
What the importer builds at the pointer of a node of a source document: the names of the OP classes (one per family) of the entities that should sit at that pointer. It starts from FamixOpenApiSpecEntityTable and applies the context rules established by experiments on the importer (each one is a method here, with its reason):
- a $ref parameter, header, link, example, callback or requestBody has NO entity at its use site (the target is shared); a $ref response or path item gives a CLONE entity (OPResponse, OPPath) at the site, except for the entries of the components, which are aliases without entity (the importer reports #componentAlias);
- a pure $ref schema gives no entity at its place, except in the components (an alias: an OPSchema with ref set) and as a property (an OPProperty without schema); in OpenAPI 3.1 a $ref next to other keys is a schema of its own (an OPSchema);
- an unresolved $ref gives an OPReference at the site, in addition to what the same $ref would give when resolved (but a response gives only the OPReference, and a components entry other than a schema gives nothing);
- a property gives an OPProperty and its schema an OPSchema at the same pointer; a boolean schema gives an OPSchema only as a components entry and an OPProperty only as a property;
- Swagger 2: a body parameter of an operation gives an OPRequestBody (the first one only, a $ref to a body parameter too), a body or formData parameter of a path item or a formData parameter gives nothing at all, the ones of '#/parameters' stay OPParameter;
- the schemas below the 3.1 keywords the importer does not read ($defs, if, then, else, contains, patternProperties...) give nothing, as the ones of a body parameter that is dropped.
- an oauth2 security scheme of Swagger 2 also gives an OPOAuthFlow at its own pointer (OpenAPI 3 has the flows as nodes).
The expectation is for a model imported with mergesInlineSchemas = false.
"
Class {
	#name : 'FamixOpenApiNodeExpectation',
	#superclass : 'Object',
	#instVars : [
		'inventory',
		'componentContainers'
	],
	#category : 'Famix-OpenApi-Validation',
	#package : 'Famix-OpenApi-Validation'
}

{ #category : 'data' }
FamixOpenApiNodeExpectation class >> dataCloneClassNames [
	"Rows: spec object, OP class of the clone that a resolved $ref gives at its site (not for a components entry)"

	^ #( #( 'Response' 'OPResponse' ) #( 'PathItem' 'OPPath' ) )
]

{ #category : 'data' }
FamixOpenApiNodeExpectation class >> dataOpenApiSections [
	"The maps of the components of OpenAPI 3: their entries are the components, and an entry that is only a $ref is an alias"

	^ #( 'schemas' 'responses' 'parameters' 'examples' 'requestBodies'
	     'headers' 'securitySchemes' 'links' 'callbacks' 'pathItems' )
]

{ #category : 'data' }
FamixOpenApiNodeExpectation class >> dataSwagger2Sections [
	"The maps of the root of a Swagger 2 document that play the role of the components"

	^ #( 'definitions' 'parameters' 'responses' 'securityDefinitions' )
]

{ #category : 'data' }
FamixOpenApiNodeExpectation class >> dataUnimportedSchemaFields [
	"Fields of a schema (OpenAPI 3.1 keywords) whose schemas the importer does not read: a node there, and everything below it, has no entity. It is a limit of the importer, documented here and not a gap of the checker"

	^ #( 'patternProperties' 'if' 'then' 'else' 'contains' 'propertyNames'
	     'unevaluatedProperties' 'unevaluatedItems' 'dependentSchemas'
	     '$defs' 'contentSchema' )
]

{ #category : 'instance creation' }
FamixOpenApiNodeExpectation class >> on: aSourceInventory [

	^ self new
		  inventory: aSourceInventory;
		  yourself
]

{ #category : 'expectations - objects' }
FamixOpenApiNodeExpectation >> classNamesOfObject: aNode [
	"A node that is not a reference (or whose $ref is not a string, which the importer reads as an object)"

	| spec |
	spec := inventory siteSpecObjectOf: aNode.
	spec = 'Schema' ifTrue: [ ^ self classNamesOfSchema: aNode ].
	(spec = 'Parameter' and: [ aNode version = #v2 ]) ifTrue: [
		^ self classNamesOfSwagger2Parameter: aNode ].
	(spec = 'SecurityScheme' and: [ aNode version = #v2 ]) ifTrue: [
		^ self classNamesOfSwagger2SecurityScheme: aNode ].
	^ self tableClassNamesOf: aNode
]

{ #category : 'expectations - references' }
FamixOpenApiNodeExpectation >> classNamesOfReference: aNode [
	"A node whose $ref is a string: what the same $ref gives when resolved, and an OPReference more when it is not"

	| resolved |
	resolved := self classNamesOfResolvedReference: aNode.
	^ (self isResolved: aNode)
		  ifTrue: [ resolved ]
		  ifFalse: [
		  self classNamesOfUnresolvedReference: aNode given: resolved ]
]

{ #category : 'expectations - references' }
FamixOpenApiNodeExpectation >> classNamesOfResolvedReference: aNode [
	"The entities at the site of a $ref whose target exists"

	| spec |
	spec := inventory siteSpecObjectOf: aNode.
	spec = 'Schema' ifTrue: [ ^ self classNamesOfSchemaReference: aNode ].
	(self isComponentEntry: aNode) ifTrue: [ ^ #(  ) ].
	(spec = 'Parameter' and: [ aNode version = #v2 ]) ifTrue: [
		^ self requestBodyNamesOfBody: aNode ].
	^ self cloneClassNamesOf: spec
]

{ #category : 'expectations - objects' }
FamixOpenApiNodeExpectation >> classNamesOfSchema: aNode [
	"A property gives an OPProperty; the schema gives an OPSchema, a boolean schema only in the components"

	^ Array streamContents: [ :stream |
		  (self isPropertyEntry: aNode) ifTrue: [
			  stream nextPut: 'OPProperty' ].
		  (aNode value isDictionary or: [ self isComponentEntry: aNode ])
			  ifTrue: [ stream nextPut: 'OPSchema' ] ]
]

{ #category : 'expectations - references' }
FamixOpenApiNodeExpectation >> classNamesOfSchemaReference: aNode [
	"A property gives its OPProperty; the OPSchema exists for an alias in the components and for a 3.1 schema that has keys beside its $ref"

	^ Array streamContents: [ :stream |
		  (self isPropertyEntry: aNode) ifTrue: [
			  stream nextPut: 'OPProperty' ].
		  ((self isComponentEntry: aNode) or: [
			   (self isPureReference: aNode) not ]) ifTrue: [
			  stream nextPut: 'OPSchema' ] ]
]

{ #category : 'expectations - objects' }
FamixOpenApiNodeExpectation >> classNamesOfSwagger2Parameter: aNode [
	"In '#/parameters' every parameter is an OPParameter. In a path item or an operation a formData parameter gives nothing, a body parameter an OPRequestBody when it is the first one of an operation (nothing otherwise), the others an OPParameter"

	| location |
	(self isComponentEntry: aNode) ifTrue: [ ^ #( 'OPParameter' ) ].
	location := aNode valueAt: 'in'.
	location = 'formData' ifTrue: [ ^ #(  ) ].
	location = 'body' ifTrue: [ ^ self requestBodyNamesOfBody: aNode ].
	^ #( 'OPParameter' )
]

{ #category : 'expectations - objects' }
FamixOpenApiNodeExpectation >> classNamesOfSwagger2SecurityScheme: aNode [
	"An oauth2 scheme of Swagger 2 holds its flow itself: the importer builds an OPOAuthFlow at the same pointer (OpenAPI 3 has the flows as nodes)"

	^ (aNode valueAt: 'type') = 'oauth2'
		  ifTrue: [ #( 'OPSecurityScheme' 'OPOAuthFlow' ) ]
		  ifFalse: [ #( 'OPSecurityScheme' ) ]
]

{ #category : 'expectations - references' }
FamixOpenApiNodeExpectation >> classNamesOfUnresolvedReference: aNode given: aResolvedCollection [
	"An unresolved $ref of a components entry that is not a schema is reported as #componentAlias and gives nothing; an unresolved response gives only the OPReference, the other ones give it besides what they give when resolved"

	| spec |
	spec := inventory siteSpecObjectOf: aNode.
	(spec ~= 'Schema' and: [ self isComponentEntry: aNode ]) ifTrue: [
		^ #(  ) ].
	spec = 'Response' ifTrue: [ ^ #( 'OPReference' ) ].
	^ aResolvedCollection , #( 'OPReference' )
]

{ #category : 'expectations - references' }
FamixOpenApiNodeExpectation >> cloneClassNamesOf: aSpecObjectName [
	"The clone a resolved $ref gives at its site (a response, a path item); nothing for the objects that are shared"

	^ (self class dataCloneClassNames
		   detect: [ :each | each first = aSpecObjectName ]
		   ifNone: [ nil ])
		  ifNil: [ #(  ) ]
		  ifNotNil: [ :row | { row second } ]
]

{ #category : 'private' }
FamixOpenApiNodeExpectation >> componentContainerPointers [
	"The pointers of the maps whose entries are components"

	^ inventory version = #v2
		  ifTrue: [
		  self class dataSwagger2Sections collect: [ :each | '#/' , each ] ]
		  ifFalse: [
			  self class dataOpenApiSections collect: [ :each |
				  '#/components/' , each ] ]
]

{ #category : 'expectations' }
FamixOpenApiNodeExpectation >> expectedClassNamesFor: aNode [
	"The names of the OP classes of the entities that should sit at the pointer of aNode, one per family; an empty Array when there is none"

	(aNode isWrongShape or: [ self isDropped: aNode ]) ifTrue: [ ^ #(  ) ].
	^ aNode referenceText
		  ifNil: [ self classNamesOfObject: aNode ]
		  ifNotNil: [ self classNamesOfReference: aNode ]
]

{ #category : 'swagger 2' }
FamixOpenApiNodeExpectation >> firstBodyParameterOf: aContainerPointer [

	^ (inventory childrenOf: aContainerPointer)
		  detect: [ :each | self isBodyParameter: each ]
		  ifNone: [ nil ]
]

{ #category : 'accessing' }
FamixOpenApiNodeExpectation >> inventory: aSourceInventory [

	inventory := aSourceInventory.
	componentContainers := self componentContainerPointers
]

{ #category : 'swagger 2' }
FamixOpenApiNodeExpectation >> isBodyParameter: aNode [
	"A parameter located in the body, or a $ref to one"

	| parameter |
	parameter := aNode isReference
		             ifTrue: [ self targetOf: aNode ]
		             ifFalse: [ aNode ].
	^ parameter isNotNil and: [
		  (inventory siteSpecObjectOf: parameter) = 'Parameter' and: [
			  (parameter valueAt: 'in') = 'body' ] ]
]

{ #category : 'testing' }
FamixOpenApiNodeExpectation >> isComponentEntry: aNode [
	"True for an entry of a map of the components (of '#/definitions', '#/parameters'... in Swagger 2)"

	^ componentContainers includes: aNode parentPointer
]

{ #category : 'dropped' }
FamixOpenApiNodeExpectation >> isDropRoot: aNode [
	"A schema in a field of a 3.1 schema that the importer does not read, or an inline Swagger 2 body parameter that is not the request body of its operation"

	^ ((inventory siteSpecObjectOf: aNode) = 'Schema' and: [
		   self class dataUnimportedSchemaFields includes:
			   (inventory fieldOf: aNode) ]) or: [
		  self isDroppedBodyParameter: aNode ]
]

{ #category : 'dropped' }
FamixOpenApiNodeExpectation >> isDropped: aNode [
	"True when aNode, or a node above it, is something the importer does not read: it gives no entity"

	^ (self isDropRoot: aNode) or: [
		  (inventory ancestorsOf: aNode) anySatisfy: [ :each |
			  self isDropRoot: each ] ]
]

{ #category : 'dropped' }
FamixOpenApiNodeExpectation >> isDroppedBodyParameter: aNode [

	^ aNode version = #v2 and: [
		  (inventory siteSpecObjectOf: aNode) = 'Parameter' and: [
			  aNode isReference not and: [
				  (aNode valueAt: 'in') = 'body' and: [
					  (self isComponentEntry: aNode) not and: [
						  (self isFirstBodyParameter: aNode) not ] ] ] ] ]
]

{ #category : 'swagger 2' }
FamixOpenApiNodeExpectation >> isFirstBodyParameter: aNode [
	"True when aNode (a parameter or a $ref to one) is the first body parameter of its operation: the only one that gives a request body. A body parameter of a path item gives none"

	| owner |
	owner := inventory ownerOf: aNode.
	^ (inventory siteSpecObjectOf: owner) = 'Operation' and: [
		  (self firstBodyParameterOf: aNode parentPointer) == aNode ]
]

{ #category : 'testing' }
FamixOpenApiNodeExpectation >> isPropertyEntry: aNode [
	"True for an entry of the properties of a schema"

	^ (inventory fieldOf: aNode) = 'properties' and: [
		  (inventory siteSpecObjectOf: aNode) = 'Schema' ]
]

{ #category : 'testing' }
FamixOpenApiNodeExpectation >> isPureReference: aNode [
	"A schema that only designates another one: in OpenAPI 3.1 it has no other key, in Swagger 2 and 3.0 the keys beside the $ref are ignored"

	^ aNode version ~= #v31 or: [ aNode hasKeysBesideReference not ]
]

{ #category : 'references' }
FamixOpenApiNodeExpectation >> isResolved: aReferenceNode [

	^ (self targetOf: aReferenceNode) isNotNil
]

{ #category : 'references' }
FamixOpenApiNodeExpectation >> nodeForReference: aText [
	"A local reference is a pointer in a URI fragment: it may be percent-encoded"

	(aText beginsWith: '#') ifFalse: [ ^ nil ].
	^ inventory nodeAt: aText ifAbsent: [
		  inventory
			  nodeAt: (ZnPercentEncoder new decode: aText)
			  ifAbsent: [ nil ] ]
]

{ #category : 'expectations - objects' }
FamixOpenApiNodeExpectation >> requestBodyNamesOfBody: aNode [
	"The OPRequestBody of the first body parameter of an operation (a parameter or a $ref to one), nothing for the others"

	^ (self isFirstBodyParameter: aNode)
		  ifTrue: [ #( 'OPRequestBody' ) ]
		  ifFalse: [ #(  ) ]
]

{ #category : 'expectations - objects' }
FamixOpenApiNodeExpectation >> tableClassNamesOf: aNode [

	^ (FamixOpenApiSpecEntityTable
		   classNameFor: (inventory siteSpecObjectOf: aNode)
		   version: aNode version)
		  ifNil: [ #(  ) ]
		  ifNotNil: [ :name | { name } ]
]

{ #category : 'references' }
FamixOpenApiNodeExpectation >> targetOf: aReferenceNode [
	"The node the local $ref designates, nil for an external or unresolved one"

	^ aReferenceNode referenceText ifNotNil: [ :text |
		  self nodeForReference: text ]
]
