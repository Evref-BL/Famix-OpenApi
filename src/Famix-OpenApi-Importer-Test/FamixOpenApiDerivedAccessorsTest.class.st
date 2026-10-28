"
Unit tests of the derived accessors of the canonical OpenAPI model (operations, tags, effectiveParameters, effectiveSecurity, allProperties, referrers). The entities are built directly, without the importer.
"
Class {
	#name : 'FamixOpenApiDerivedAccessorsTest',
	#superclass : 'TestCase',
	#category : 'Famix-OpenApi-Importer-Test',
	#package : 'Famix-OpenApi-Importer-Test'
}

{ #category : 'helpers' }
FamixOpenApiDerivedAccessorsTest >> operationNamed: aName [

	^ OPOperation new
		  name: aName;
		  yourself
]

{ #category : 'helpers' }
FamixOpenApiDerivedAccessorsTest >> operationNamed: aName in: aPath [

	| operation |
	operation := self operationNamed: aName.
	aPath addOperation: operation.
	^ operation
]

{ #category : 'helpers' }
FamixOpenApiDerivedAccessorsTest >> parameterNamed: aName location: aLocation [

	^ OPParameter new
		  name: aName;
		  location: aLocation;
		  yourself
]

{ #category : 'helpers' }
FamixOpenApiDerivedAccessorsTest >> pathNamed: aRelativePath in: anOpenApi [

	| path |
	path := OPPath new
		        name: aRelativePath;
		        yourself.
	anOpenApi addPath: path.
	^ path
]

{ #category : 'helpers' }
FamixOpenApiDerivedAccessorsTest >> propertyNamed: aName [

	^ OPProperty new
		  name: aName;
		  yourself
]

{ #category : 'helpers' }
FamixOpenApiDerivedAccessorsTest >> schemaNamed: aName [

	^ OPSchema new
		  name: aName;
		  yourself
]

{ #category : 'helpers' }
FamixOpenApiDerivedAccessorsTest >> securityRequirementNamed: aName [

	^ OPSecurityRequirement new
		  name: aName;
		  yourself
]

{ #category : 'helpers' }
FamixOpenApiDerivedAccessorsTest >> tagNamed: aName [

	^ OPTag new
		  name: aName;
		  yourself
]

{ #category : 'tests-schema and referrers' }
FamixOpenApiDerivedAccessorsTest >> testAllPropertiesFollowNestedAllOfMembers [

	| root middle leaf rootProperty |
	root := self schemaNamed: 'Root'.
	rootProperty := self propertyNamed: 'id'.
	root addProperty: rootProperty.
	middle := self schemaNamed: 'Middle'.
	middle addAllOf: root.
	leaf := self schemaNamed: 'Leaf'.
	leaf addAllOf: middle.
	self assert: leaf allProperties asArray equals: { rootProperty }
]

{ #category : 'tests-schema and referrers' }
FamixOpenApiDerivedAccessorsTest >> testAllPropertiesIncludeTheOwnProperties [

	| schema name |
	schema := self schemaNamed: 'Pet'.
	name := self propertyNamed: 'name'.
	schema addProperty: name.
	self assert: schema allProperties asArray equals: { name }
]

{ #category : 'tests-schema and referrers' }
FamixOpenApiDerivedAccessorsTest >> testAllPropertiesIncludeThePropertiesOfAllOfMembers [

	| base pet id name |
	base := self schemaNamed: 'Base'.
	id := self propertyNamed: 'id'.
	base addProperty: id.
	pet := self schemaNamed: 'Pet'.
	name := self propertyNamed: 'name'.
	pet addProperty: name.
	pet addAllOf: base.
	self assert: pet allProperties asArray equals: {
			name.
			id }
]

{ #category : 'tests-schema and referrers' }
FamixOpenApiDerivedAccessorsTest >> testAllPropertiesLetAnOwnPropertyHideAnInheritedOneWithTheSameName [

	| base pet inherited own |
	base := self schemaNamed: 'Base'.
	inherited := self propertyNamed: 'id'.
	base addProperty: inherited.
	pet := self schemaNamed: 'Pet'.
	own := self propertyNamed: 'id'.
	pet addProperty: own.
	pet addAllOf: base.
	self assert: pet allProperties asArray equals: { own }
]

{ #category : 'tests-schema and referrers' }
FamixOpenApiDerivedAccessorsTest >> testAllPropertiesTerminateOnAnAllOfCycle [

	| first second id name |
	first := self schemaNamed: 'First'.
	second := self schemaNamed: 'Second'.
	id := self propertyNamed: 'id'.
	name := self propertyNamed: 'name'.
	first addProperty: id.
	second addProperty: name.
	first addAllOf: second.
	second addAllOf: first.
	self assert: first allProperties asArray equals: {
			id.
			name }
]

{ #category : 'tests-schema and referrers' }
FamixOpenApiDerivedAccessorsTest >> testAllReferrersFollowChainsOfReferrers [

	| schema composed parameter |
	schema := self schemaNamed: 'Pet'.
	composed := self schemaNamed: 'Either'.
	composed addOneOf: schema.
	parameter := self parameterNamed: 'pet' location: 'body'.
	parameter schema: composed.
	self assert: schema allReferrers asSet equals: {
			composed.
			parameter } asSet
]

{ #category : 'tests-schema and referrers' }
FamixOpenApiDerivedAccessorsTest >> testAllReferrersTerminateOnACycleAndExcludeTheReceiver [

	| first second |
	first := self schemaNamed: 'First'.
	second := self schemaNamed: 'Second'.
	first addOneOf: second.
	second addOneOf: first.
	self assert: first allReferrers asArray equals: { second }
]

{ #category : 'tests-operations' }
FamixOpenApiDerivedAccessorsTest >> testDeclaringOpenApiIsNilForADetachedOperation [

	self assert: (self operationNamed: 'orphan') declaringOpenApi isNil
]

{ #category : 'tests-operations' }
FamixOpenApiDerivedAccessorsTest >> testDeclaringOpenApiOfACallbackOperationIsTheOpenApiOfTheCallbackOperation [

	| openApi parent callback callbackOperation |
	openApi := OPOpenApi new.
	parent := self
		          operationNamed: 'subscribe'
		          in: (self pathNamed: '/subscriptions' in: openApi).
	callback := OPCallback new.
	parent addDirectCallback: callback.
	callbackOperation := self operationNamed: 'notify' in: (OPPath new
			                      callback: callback;
			                      yourself).
	self assert: callbackOperation declaringOpenApi equals: openApi
]

{ #category : 'tests-operations' }
FamixOpenApiDerivedAccessorsTest >> testDeclaringOpenApiOfAWebhookOperationIsTheOpenApiDeclaringTheWebhook [

	| openApi webhook operation |
	openApi := OPOpenApi new.
	webhook := OPPath new.
	openApi addWebhook: webhook.
	operation := self operationNamed: 'onEvent' in: webhook.
	self assert: operation declaringOpenApi equals: openApi
]

{ #category : 'tests-operations' }
FamixOpenApiDerivedAccessorsTest >> testDeclaringOpenApiOfAnOperationIsTheOpenApiOfItsPath [

	| openApi operation |
	openApi := OPOpenApi new.
	operation := self
		             operationNamed: 'listPets'
		             in: (self pathNamed: '/pets' in: openApi).
	self assert: operation declaringOpenApi equals: openApi
]

{ #category : 'tests-effective' }
FamixOpenApiDerivedAccessorsTest >> testEffectiveParametersIncludeThePathParameters [

	| path operation own inherited |
	path := OPPath new.
	operation := self operationNamed: 'listPets' in: path.
	own := self parameterNamed: 'limit' location: 'query'.
	inherited := self parameterNamed: 'owner' location: 'path'.
	operation addParameter: own.
	path addParameter: inherited.
	self assert: operation effectiveParameters asArray equals: {
			own.
			inherited }
]

{ #category : 'tests-effective' }
FamixOpenApiDerivedAccessorsTest >> testEffectiveParametersKeepAPathParameterWithTheSameNameInAnotherLocation [

	| path operation own inherited |
	path := OPPath new.
	operation := self operationNamed: 'listPets' in: path.
	own := self parameterNamed: 'id' location: 'query'.
	inherited := self parameterNamed: 'id' location: 'path'.
	operation addParameter: own.
	path addParameter: inherited.
	self assert: operation effectiveParameters asArray equals: {
			own.
			inherited }
]

{ #category : 'tests-effective' }
FamixOpenApiDerivedAccessorsTest >> testEffectiveParametersLetTheOperationOverrideAPathParameterWithTheSameNameAndLocation [

	| path operation own inherited |
	path := OPPath new.
	operation := self operationNamed: 'listPets' in: path.
	own := self parameterNamed: 'limit' location: 'query'.
	inherited := self parameterNamed: 'limit' location: 'query'.
	operation addParameter: own.
	path addParameter: inherited.
	self assert: operation effectiveParameters asArray equals: { own }
]

{ #category : 'tests-effective' }
FamixOpenApiDerivedAccessorsTest >> testEffectiveParametersOfADetachedOperationAreItsOwnParameters [

	| operation own |
	operation := self operationNamed: 'orphan'.
	own := self parameterNamed: 'limit' location: 'query'.
	operation addParameter: own.
	self assert: operation effectiveParameters asArray equals: { own }
]

{ #category : 'tests-effective' }
FamixOpenApiDerivedAccessorsTest >> testEffectiveSecurityFallsBackOnTheRequirementsOfTheOpenApi [

	| openApi operation global |
	openApi := OPOpenApi new.
	global := self securityRequirementNamed: 'global'.
	openApi addSecurityRequirement: global.
	operation := self
		             operationNamed: 'listPets'
		             in: (self pathNamed: '/pets' in: openApi).
	self assert: operation effectiveSecurity asArray equals: { global }
]

{ #category : 'tests-effective' }
FamixOpenApiDerivedAccessorsTest >> testEffectiveSecurityIsEmptyForADetachedOperationWithoutRequirement [

	self assert:
		(self operationNamed: 'orphan') effectiveSecurity isEmpty
]

{ #category : 'tests-effective' }
FamixOpenApiDerivedAccessorsTest >> testEffectiveSecurityIsEmptyWhenNothingIsDeclared [

	| openApi operation |
	openApi := OPOpenApi new.
	operation := self
		             operationNamed: 'listPets'
		             in: (self pathNamed: '/pets' in: openApi).
	self assert: operation effectiveSecurity isEmpty
]

{ #category : 'tests-effective' }
FamixOpenApiDerivedAccessorsTest >> testEffectiveSecurityPrefersTheRequirementsOfTheOperation [

	| openApi operation own |
	openApi := OPOpenApi new.
	openApi addSecurityRequirement:
		(self securityRequirementNamed: 'global').
	operation := self
		             operationNamed: 'listPets'
		             in: (self pathNamed: '/pets' in: openApi).
	own := self securityRequirementNamed: 'local'.
	operation addSecurityRequirement: own.
	self assert: operation effectiveSecurity asArray equals: { own }
]

{ #category : 'tests-operations' }
FamixOpenApiDerivedAccessorsTest >> testOperationsCollectsTheOperationsOfAllPaths [

	| openApi first second |
	openApi := OPOpenApi new.
	first := self
		         operationNamed: 'listPets'
		         in: (self pathNamed: '/pets' in: openApi).
	second := self
		          operationNamed: 'listOwners'
		          in: (self pathNamed: '/owners' in: openApi).
	self assert: openApi operations asSet equals: {
			first.
			second } asSet
]

{ #category : 'tests-operations' }
FamixOpenApiDerivedAccessorsTest >> testOperationsDoNotIncludeWebhookOperations [

	| openApi webhook |
	openApi := OPOpenApi new.
	webhook := OPPath new.
	openApi addWebhook: webhook.
	webhook addOperation: (self operationNamed: 'onEvent').
	self assert: openApi operations isEmpty
]

{ #category : 'tests-operations' }
FamixOpenApiDerivedAccessorsTest >> testOperationsIsEmptyWithoutPath [

	self assert: OPOpenApi new operations isEmpty
]

{ #category : 'tests-schema and referrers' }
FamixOpenApiDerivedAccessorsTest >> testReferrersAreDistinct [

	| schema composed |
	schema := self schemaNamed: 'Pet'.
	composed := self schemaNamed: 'Either'.
	composed addOneOf: schema.
	composed addAnyOf: schema.
	self assert: schema referrers size equals: 1
]

{ #category : 'tests-schema and referrers' }
FamixOpenApiDerivedAccessorsTest >> testReferrersAreEmptyWhenNothingRefersToTheEntity [

	self assert: (self schemaNamed: 'Pet') referrers isEmpty
]

{ #category : 'tests-schema and referrers' }
FamixOpenApiDerivedAccessorsTest >> testReferrersCollectTheParametersUsingTheSchema [

	| schema parameter |
	schema := self schemaNamed: 'Pet'.
	parameter := self parameterNamed: 'pet' location: 'body'.
	parameter schema: schema.
	self assert: schema referrers asArray equals: { parameter }
]

{ #category : 'tests-schema and referrers' }
FamixOpenApiDerivedAccessorsTest >> testReferrersCollectThePropertiesUsingTheSchemaAsValue [

	| schema property |
	schema := self schemaNamed: 'Pet'.
	property := self propertyNamed: 'pet'.
	property valueSchema: schema.
	self assert: schema referrers asArray equals: { property }
]

{ #category : 'tests-schema and referrers' }
FamixOpenApiDerivedAccessorsTest >> testReferrersCollectTheSchemasUsingTheSchemaInAComposition [

	| schema composed |
	schema := self schemaNamed: 'Pet'.
	composed := self schemaNamed: 'Either'.
	composed addOneOf: schema.
	self assert: schema referrers asArray equals: { composed }
]

{ #category : 'tests-schema and referrers' }
FamixOpenApiDerivedAccessorsTest >> testReferrersIncludeTheReceiverWhenItRefersToItself [

	| schema |
	schema := self schemaNamed: 'Tree'.
	schema items: schema.
	self assert: schema referrers asArray equals: { schema }
]

{ #category : 'tests-operations' }
FamixOpenApiDerivedAccessorsTest >> testTagsAreEmptyForADetachedOperation [

	self assert: ((self operationNamed: 'orphan')
			 tagNames: #( 'pets' );
			 yourself) tags isEmpty
]

{ #category : 'tests-operations' }
FamixOpenApiDerivedAccessorsTest >> testTagsAreEmptyWhenTheOperationHasNoTagName [

	| openApi operation |
	openApi := OPOpenApi new.
	openApi addTag: (self tagNamed: 'pets').
	operation := self
		             operationNamed: 'listPets'
		             in: (self pathNamed: '/pets' in: openApi).
	self assert: operation tags isEmpty
]

{ #category : 'tests-operations' }
FamixOpenApiDerivedAccessorsTest >> testTagsResolveTagNamesToTheTagsOfTheOpenApi [

	| openApi pets owners operation |
	openApi := OPOpenApi new.
	pets := self tagNamed: 'pets'.
	owners := self tagNamed: 'owners'.
	openApi
		addTag: pets;
		addTag: owners.
	operation := self
		             operationNamed: 'listPets'
		             in: (self pathNamed: '/pets' in: openApi).
	operation tagNames: #( 'owners' 'pets' ).
	self assert: operation tags asArray equals: {
			owners.
			pets }
]

{ #category : 'tests-operations' }
FamixOpenApiDerivedAccessorsTest >> testTagsSkipANameNotDeclaredByTheOpenApi [

	| openApi pets operation |
	openApi := OPOpenApi new.
	pets := self tagNamed: 'pets'.
	openApi addTag: pets.
	operation := self
		             operationNamed: 'listPets'
		             in: (self pathNamed: '/pets' in: openApi).
	operation tagNames: #( 'unknown' 'pets' ).
	self assert: operation tags asArray equals: { pets }
]
