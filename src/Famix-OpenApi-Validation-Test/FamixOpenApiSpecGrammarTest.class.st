"
I test FamixOpenApiSpecGrammar: every field of FamixOpenApiSpecFieldTable has an edge of a compatible kind (so that a new non-scalar field of the table without an edge makes me fail), every edge points to a spec object of its version, and the key lookup (fixed, extension, patterned, unknown) behaves.
"
Class {
	#name : 'FamixOpenApiSpecGrammarTest',
	#superclass : 'TestCase',
	#category : 'Famix-OpenApi-Validation-Test',
	#package : 'Famix-OpenApi-Validation-Test'
}

{ #category : 'helpers' }
FamixOpenApiSpecGrammarTest >> acceptedEdgeKindsFor: aFieldKind [
	"The kinds of grammar edge that fit a field of the table of kind aFieldKind. A map field may be an #object edge (Swagger 2 scopes and the patterned fields); an any field is free"

	aFieldKind = #scalar ifTrue: [ ^ #( #scalar #any ) ].
	aFieldKind = #object ifTrue: [ ^ #( #object ) ].
	aFieldKind = #reference ifTrue: [ ^ #( #reference ) ].
	aFieldKind = #map ifTrue: [
		^ #( #map #mapOfScalars #mapOfAny #mapOfArrays #object ) ].
	aFieldKind = #array ifTrue: [ ^ #( #array #arrayOfScalars
		     #any ) ].
	^ #( #any #object #map #array #arrayOfScalars #mapOfScalars
	     #mapOfAny )
]

{ #category : 'helpers' }
FamixOpenApiSpecGrammarTest >> edgeFor: aFieldName of: aSpecObject in: aVersion [

	^ FamixOpenApiSpecGrammar
		  edgeFor: aSpecObject
		  field: aFieldName
		  in: aVersion
]

{ #category : 'helpers' }
FamixOpenApiSpecGrammarTest >> edgeForKey: aKey of: aSpecObject in: aVersion [

	^ FamixOpenApiSpecGrammar
		  edgeForKey: aKey
		  in: aSpecObject
		  version: aVersion
]

{ #category : 'helpers' }
FamixOpenApiSpecGrammarTest >> field: aField hasEdgeIn: aVersion [

	| edge |
	edge := FamixOpenApiSpecGrammar
		        edgeFor: aField specObject
		        field: aField name
		        in: aVersion.
	^ edge isUnknown not and: [
		  (self acceptedEdgeKindsFor: aField kind) includes: edge kind ]
]

{ #category : 'helpers' }
FamixOpenApiSpecGrammarTest >> fieldsWithoutEdgeAmong: aFieldCollection [
	"Answer a description of every (field, version) of aFieldCollection that has no edge of a compatible kind in the grammar"

	^ Array streamContents: [ :stream |
		  aFieldCollection do: [ :field |
			  field versions do: [ :version |
				  (self field: field hasEdgeIn: version) ifFalse: [
					  stream nextPut: ('<1s>.<2s> <3s>'
							   expandMacrosWith: field specObject
							   with: field name
							   with: version) ] ] ] ]
]

{ #category : 'helpers' }
FamixOpenApiSpecGrammarTest >> tableHasNonScalar: aFieldName of: aSpecObject in: aVersion [

	^ (FamixOpenApiSpecFieldTable fieldsFor: aSpecObject in: aVersion)
		  anySatisfy: [ :field |
		  field name = aFieldName and: [ field kind ~= #scalar ] ]
]

{ #category : 'tests' }
FamixOpenApiSpecGrammarTest >> testANewNonScalarFieldWithoutEdgeIsDetected [

	| newField |
	newField := FamixOpenApiSpecField
		            fromRow:
		            #( 'brandNewChild' object #( v30 v2 ) structural
		               false '' )
		            specObject: 'Operation'.
	self
		assert: (self fieldsWithoutEdgeAmong: { newField })
		equals:
		#( 'Operation.brandNewChild v30' 'Operation.brandNewChild v2' )
]

{ #category : 'tests' }
FamixOpenApiSpecGrammarTest >> testAnEdgeOfTheWrongKindIsDetected [
	"Schema.properties is a map edge: a table field of kind array with that name does not fit"

	| arrayProperties |
	arrayProperties := FamixOpenApiSpecField
		                   fromRow:
		                   #( 'properties' array #( v30 ) structural
		                      false '' )
		                   specObject: 'Schema'.
	self
		assert: (self fieldsWithoutEdgeAmong: { arrayProperties })
		equals: #( 'Schema.properties v30' )
]

{ #category : 'tests' }
FamixOpenApiSpecGrammarTest >> testChildShapesOfTheMainFields [

	self
		assert:
		(self edgeFor: 'requestBody' of: 'Operation' in: #v30) printString
		equals: 'Operation.requestBody -> #object RequestBody'.
	self
		assert:
		(self edgeFor: 'schemas' of: 'Components' in: #v31) printString
		equals: 'Components.schemas -> #map Schema'.
	self
		assert: (self edgeFor: 'allOf' of: 'Schema' in: #v2) printString
		equals: 'Schema.allOf -> #array Schema'.
	self
		assert:
		(self edgeFor: 'definitions' of: 'Swagger' in: #v2) printString
		equals: 'Swagger.definitions -> #map Schema'.
	self
		assert: (self edgeFor: 'items' of: 'Parameter' in: #v2) printString
		equals: 'Parameter.items -> #object Items'.
	self
		assert: (self edgeFor: 'items' of: 'Items' in: #v2) printString
		equals: 'Items.items -> #object Items'.
	self
		assert: (self edgeFor: 'required' of: 'Schema' in: #v30) kind
		equals: #arrayOfScalars.
	self
		assert:
		(self edgeFor: 'dependentRequired' of: 'Schema' in: #v31) kind
		equals: #mapOfArrays.
	self
		assert: (self edgeFor: 'example' of: 'Schema' in: #v30) kind
		equals: #any
]

{ #category : 'tests' }
FamixOpenApiSpecGrammarTest >> testEdgeCountsPerVersion [
	"Non-scalar edges (declared and x-* extension) and declared edges alone"

	self assert: (FamixOpenApiSpecGrammar edgeCountIn: #v30) equals: 114.
	self
		assert: (FamixOpenApiSpecGrammar declaredEdgeCountIn: #v30)
		equals: 87.
	self assert: (FamixOpenApiSpecGrammar edgeCountIn: #v31) equals: 135.
	self
		assert: (FamixOpenApiSpecGrammar declaredEdgeCountIn: #v31)
		equals: 107.
	self assert: (FamixOpenApiSpecGrammar edgeCountIn: #v2) equals: 80.
	self
		assert: (FamixOpenApiSpecGrammar declaredEdgeCountIn: #v2)
		equals: 63
]

{ #category : 'tests' }
FamixOpenApiSpecGrammarTest >> testEdgeVersionsAreTheOnesOfTheFieldRows [
	"A declared edge exists in exactly the versions where the table has a non-scalar field of that name (Schema.discriminator is a scalar of Swagger 2)"

	| wrong |
	wrong := FamixOpenApiSpecGrammar declaredEdges select: [ :edge |
		         edge specObject ~= 'Scopes' and: [
			         #( #v30 #v31 #v2 ) anySatisfy: [ :version |
				         (self
					          tableHasNonScalar: edge name
					          of: edge specObject
					          in: version) ~= (edge appliesIn: version) ] ] ].
	self assert: wrong isEmpty
]

{ #category : 'tests' }
FamixOpenApiSpecGrammarTest >> testEveryDeclaredEdgeHasAFieldOfTheTableExceptScopes [
	"The only grammar-only edge is the patterned scope name of the Swagger 2 Scopes object"

	| wrong |
	wrong := FamixOpenApiSpecGrammar declaredEdges select: [ :edge |
		         edge specObject ~= 'Scopes' and: [
			         edge versions anySatisfy: [ :version |
				         (FamixOpenApiSpecFieldTable
					          fieldsFor: edge specObject
					          in: version) noneSatisfy: [ :field |
					         field name = edge name ] ] ] ].
	self assert: wrong isEmpty
]

{ #category : 'tests' }
FamixOpenApiSpecGrammarTest >> testEveryDeclaredTargetIsASpecObjectOfItsVersions [

	| wrong |
	wrong := FamixOpenApiSpecGrammar declaredEdges select: [ :edge |
		         edge target isNotNil and: [
			         edge versions anySatisfy: [ :version |
				         ((FamixOpenApiSpecFieldTable objectNamesIn: version)
					          includes: edge target) not ] ] ].
	self assert: wrong isEmpty
]

{ #category : 'tests' }
FamixOpenApiSpecGrammarTest >> testEveryFieldOfTheTableHasAnEdge [
	"The completeness test: a non-scalar field added to the table without a grammar edge makes it fail"

	self
		assert:
		(self fieldsWithoutEdgeAmong: FamixOpenApiSpecFieldTable allFields)
		equals: #(  )
]

{ #category : 'tests' }
FamixOpenApiSpecGrammarTest >> testEveryScalarFieldIsScalarOrAny [

	| wrong |
	wrong := FamixOpenApiSpecFieldTable allFields select: [ :field |
		         field kind = #scalar and: [
			         field versions anySatisfy: [ :version |
				         (#( #scalar #any ) includes: (FamixOpenApiSpecGrammar
						           edgeFor: field specObject
						           field: field name
						           in: version) kind) not ] ] ].
	self assert: wrong isEmpty
]

{ #category : 'tests' }
FamixOpenApiSpecGrammarTest >> testExtensionsAndUnknownKeys [

	self assert:
		(self edgeForKey: 'x-internal' of: 'Operation' in: #v30) isExtension.
	self
		assert:
		(self edgeForKey: 'x-internal' of: 'Operation' in: #v30) kind
		equals: #any.
	self assert:
		(self edgeForKey: 'x-internal' of: 'Responses' in: #v2) isExtension.
	self assert:
		(self edgeForKey: 'x-nope' of: 'Discriminator' in: #v30) isUnknown.
	self assert:
		(self edgeForKey: 'x-ok' of: 'Discriminator' in: #v31) isExtension.
	self assert:
		(self edgeForKey: 'bogus' of: 'Operation' in: #v30) isUnknown.
	self
		assert: (self edgeForKey: 'summary' of: 'Operation' in: #v30) kind
		equals: #scalar.
	self assert:
		(self edgeForKey: 'anything' of: 'NoSuchObject' in: #v30) isUnknown.
	self assert:
		(self edgeForKey: 'anything' of: 'Schema' in: #unknownVersion)
			isUnknown
]

{ #category : 'tests' }
FamixOpenApiSpecGrammarTest >> testPatternedFields [

	self
		assert:
		(self edgeForKey: '/pets/{id}' of: 'Paths' in: #v30) printString
		equals: 'Paths./{path} -> #object PathItem'.
	self assert: (self edgeForKey: 'pets' of: 'Paths' in: #v30) isUnknown.
	self
		assert: (self edgeForKey: '200' of: 'Responses' in: #v30) target
		equals: 'Response'.
	self
		assert: (self edgeForKey: '2XX' of: 'Responses' in: #v31) target
		equals: 'Response'.
	self
		assert: (self edgeForKey: 'default' of: 'Responses' in: #v2) name
		equals: 'default'.
	self assert:
		(self edgeForKey: '600' of: 'Responses' in: #v2) isUnknown.
	self assert:
		(self edgeForKey: '20' of: 'Responses' in: #v2) isUnknown.
	self assert:
		(self edgeForKey: '2xx' of: 'Responses' in: #v2) isUnknown.
	self
		assert:
			(self edgeForKey: '{$request.body#/url}' of: 'Callback' in: #v30)
				target
		equals: 'PathItem'.
	self
		assert:
		(self edgeForKey: 'application/json' of: 'Example' in: #v2) kind
		equals: #any.
	self
		assert: (self edgeForKey: 'read:pets' of: 'Scopes' in: #v2) kind
		equals: #scalar.
	self
		assert:
			(self
				 edgeForKey: 'petstore_auth'
				 of: 'SecurityRequirement'
				 in: #v30) kind
		equals: #arrayOfScalars
]

{ #category : 'tests' }
FamixOpenApiSpecGrammarTest >> testRootObjectNames [

	self
		assert: (FamixOpenApiSpecGrammar rootObjectNameIn: #v2)
		equals: 'Swagger'.
	self
		assert: (FamixOpenApiSpecGrammar rootObjectNameIn: #v30)
		equals: 'OpenAPI'.
	self
		assert: (FamixOpenApiSpecGrammar rootObjectNameIn: #v31)
		equals: 'OpenAPI'
]

{ #category : 'tests' }
FamixOpenApiSpecGrammarTest >> testVersionSpecificShapes [

	self
		assert: (self edgeFor: 'discriminator' of: 'Schema' in: #v30) kind
		equals: #object.
	self
		assert: (self edgeFor: 'discriminator' of: 'Schema' in: #v2) kind
		equals: #scalar.
	self
		assert: (self edgeFor: 'schema' of: 'Parameter' in: #v2) target
		equals: 'Schema'.
	self
		assert: (self edgeFor: 'prefixItems' of: 'Schema' in: #v31) kind
		equals: #array.
	self assert:
		(self edgeFor: 'prefixItems' of: 'Schema' in: #v30) isUnknown.
	self
		assert: (self edgeFor: 'webhooks' of: 'OpenAPI' in: #v31) target
		equals: 'PathItem'.
	self assert:
		(self edgeFor: 'webhooks' of: 'OpenAPI' in: #v30) isUnknown.
	self
		assert: (self edgeFor: 'scopes' of: 'SecurityScheme' in: #v2) target
		equals: 'Scopes'
]
