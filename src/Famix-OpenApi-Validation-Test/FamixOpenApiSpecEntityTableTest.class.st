"
Tests of FamixOpenApiSpecEntityTable: the table spec object -> OP class is complete for the three versions, names existing classes, differs on purpose from FamixOpenApiFieldMapping classNameFor: and agrees with what the real importer builds on documents that cover every spec object.
"
Class {
	#name : 'FamixOpenApiSpecEntityTableTest',
	#superclass : 'FamixOpenApiExistenceTestCase',
	#category : 'Famix-OpenApi-Validation-Test',
	#package : 'Famix-OpenApi-Validation-Test'
}

{ #category : 'tests - importer' }
FamixOpenApiSpecEntityTableTest >> assertTableAgrees: aNode with: aLookup [
	"The entities at the pointer of aNode are exactly one of the class of the table, or none when the table has no class"

	| name found |
	name := FamixOpenApiSpecEntityTable
		        classNameFor: aNode specObject
		        version: aNode version.
	found := (aLookup entitiesAt: aNode pointer) collect: [ :each |
		         each class name asString ].
	self
		assert: found asArray
		equals: (name ifNil: [ #(  ) ] ifNotNil: [ :each | { each } ])
]

{ #category : 'tests - importer' }
FamixOpenApiSpecEntityTableTest >> isPlainNode: aNode in: anExpectation of: anInventory [
	"A node whose entity is the one of the table alone: no $ref, not dropped, and none of the objects ruled by their context (a property, a boolean schema, a Swagger 2 parameter or security scheme)"

	aNode isWrongShape ifTrue: [ ^ false ].
	aNode isReference ifTrue: [ ^ false ].
	(anExpectation isDropped: aNode) ifTrue: [ ^ false ].
	(aNode version = #v2 and: [
		 #( 'Parameter' 'SecurityScheme' ) includes: aNode specObject ])
		ifTrue: [ ^ false ].
	^ aNode specObject ~= 'Schema' or: [
		  aNode value isDictionary and: [
			  (anInventory fieldOf: aNode) ~= 'properties' ] ]
]

{ #category : 'tests - data' }
FamixOpenApiSpecEntityTableTest >> testContainersAndStandInsHaveNoEntity [
	"FamixOpenApiFieldMapping carries Paths by OPPath, Items by OPSchema, Responses by OPResponse: stand-ins, no entity sits at those nodes"

	#( 'Paths' 'Responses' 'OAuthFlows' 'Scopes' 'Items' ) do: [ :name |
		self
			assert:
			(FamixOpenApiSpecEntityTable classNameFor: name version: #v30)
				isNil
			description: name.
		self
			assert:
			(FamixOpenApiSpecEntityTable classNameFor: name version: #v2) isNil
			description: name ].
	self
		assert: (FamixOpenApiFieldMapping classNameFor: 'Paths')
		equals: 'OPPath'
]

{ #category : 'tests - data' }
FamixOpenApiSpecEntityTableTest >> testEveryClassNameNamesAnExistingEntityClass [

	FamixOpenApiSpecEntityTable dataEntities do: [ :row |
		self
			assert: (Smalltalk globals includesKey: row second asSymbol)
			description: row second.
		self assert:
			((Smalltalk globals at: row second asSymbol) inheritsFrom: OPEntity) ]
]

{ #category : 'tests - data' }
FamixOpenApiSpecEntityTableTest >> testEverySpecObjectOfTheGrammarIsDecidedInEveryVersion [

	#( #v2 #v30 #v31 ) do: [ :version |
		(FamixOpenApiSpecFieldTable objectNamesIn: version) do: [ :name |
			self
				assert:
				(FamixOpenApiSpecEntityTable decidesOn: name version: version)
				description: (self describe: {
							 version.
							 name }) ] ]
]

{ #category : 'tests - data' }
FamixOpenApiSpecEntityTableTest >> testExampleIsAnEntityOnlyInOpenApi3 [

	self
		assert:
		(FamixOpenApiSpecEntityTable classNameFor: 'Example' version: #v30)
		equals: 'OPExample'.
	self
		assert:
		(FamixOpenApiSpecEntityTable classNameFor: 'Example' version: #v31)
		equals: 'OPExample'.
	self assert:
		(FamixOpenApiSpecEntityTable classNameFor: 'Example' version: #v2)
			isNil.
	self deny:
		(FamixOpenApiSpecEntityTable noteFor: 'Example' version: #v2)
			isEmpty.
	self assert:
		(FamixOpenApiSpecEntityTable noteFor: 'Example' version: #v30)
			isEmpty
]

{ #category : 'tests - importer' }
FamixOpenApiSpecEntityTableTest >> testFixturesCoverEverySpecObjectWithoutContextRules [
	"The agreement above is only worth something if every spec object was seen in plain form in the three versions"

	| verified contextual |
	verified := self verifiedPlainNodes.
	contextual := #( 'Reference' ).
	#( #v2 #v30 #v31 ) do: [ :version |
		(FamixOpenApiSpecFieldTable objectNamesIn: version)
			reject: [ :name |
				(contextual includes: name) or: [
					version = #v2 and: [
						#( 'Parameter' 'SecurityScheme' ) includes: name ] ] ]
			thenDo: [ :name |
				self
					assert: (verified includes: version -> name)
					description: (self describe: {
								 version.
								 name }) ] ]
]

{ #category : 'tests - data' }
FamixOpenApiSpecEntityTableTest >> testNoObjectIsBothWithAndWithoutEntity [

	FamixOpenApiSpecEntityTable dataNoEntity do: [ :row |
		self
			assert:
				(FamixOpenApiSpecEntityTable classNameFor: row first version: #v30)
					isNil
			description: row first ]
]

{ #category : 'tests - data' }
FamixOpenApiSpecEntityTableTest >> testReferenceIsRuledByItsContext [

	#( #v2 #v30 #v31 ) do: [ :version |
		self assert: (FamixOpenApiSpecEntityTable
				 classNameFor: 'Reference'
				 version: version) isNil ]
]

{ #category : 'tests - importer' }
FamixOpenApiSpecEntityTableTest >> testTableAgreesWithTheImporterOnPlainNodes [

	self verifiedPlainNodes
]

{ #category : 'tests - importer' }
FamixOpenApiSpecEntityTableTest >> verifiedPlainNodes [
	"A Set of version -> spec object of the plain nodes of the fixtures whose entity is the one of the table. Fails at the first node that disagrees"

	| verified |
	verified := Set new.
	self allDocuments do: [ :each |
		| inventory lookup expectation |
		inventory := self inventoryOf: each value.
		lookup := FamixOpenApiPointerLookup onModel:
			          (self modelOf: each value).
		expectation := FamixOpenApiNodeExpectation on: inventory.
		inventory allNodes
			select: [ :node |
			self isPlainNode: node in: expectation of: inventory ]
			thenDo: [ :node |
				self assertTableAgrees: node with: lookup.
				verified add: node version -> node specObject ] ].
	^ verified
]
