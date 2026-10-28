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
FamixOpenApiDerivedAccessorsTest >> testDeclaringOpenApiIsNilForADetachedCallbackAndADetachedPath [

	self assert: OPCallback new declaringOpenApi isNil.
	self assert: OPCallback new declaringOpenApis isEmpty.
	self assert: OPPath new declaringOpenApi isNil.
	self assert: OPPath new declaringOpenApis isEmpty
]

{ #category : 'tests-operations' }
FamixOpenApiDerivedAccessorsTest >> testDeclaringOpenApiIsNilForADetachedOperation [

	self assert: (self operationNamed: 'orphan') declaringOpenApi isNil
]

{ #category : 'tests-operations' }
FamixOpenApiDerivedAccessorsTest >> testDeclaringOpenApiOfACallbackOperationIsTheOpenApiOfTheCallbackOperation [

	| openApi parent callback callbackOperation callbackPath |
	openApi := OPOpenApi new.
	parent := self
		          operationNamed: 'subscribe'
		          in: (self pathNamed: '/subscriptions' in: openApi).
	callback := OPCallback new.
	parent addCallback: callback.
	callbackPath := OPPath new.
	callback addPathItem: callbackPath.
	callbackOperation := self operationNamed: 'notify' in: callbackPath.
	self assert: callbackOperation declaringOpenApi equals: openApi
]

{ #category : 'tests-operations' }
FamixOpenApiDerivedAccessorsTest >> testDeclaringOpenApiOfACallbackSharedByOperationsOfTwoOpenApisAnswersBoth [

	| first second callback |
	first := OPOpenApi new.
	second := OPOpenApi new.
	callback := OPCallback new.
	(self operationNamed: 'one' in: (self pathNamed: '/one' in: first))
		addCallback: callback.
	(self operationNamed: 'two' in: (self pathNamed: '/two' in: second))
		addCallback: callback.
	self assert: callback declaringOpenApi equals: first.
	self assert: callback declaringOpenApis asArray equals: {
			first.
			second }
]

{ #category : 'tests-operations' }
FamixOpenApiDerivedAccessorsTest >> testDeclaringOpenApiOfAPathItemSharedByTwoCallbacksFollowsTheCallbacks [

	| openApi pathItem inline reusable operation |
	openApi := OPOpenApi new
		           components: OPComponents new;
		           yourself.
	pathItem := OPPath new.
	inline := OPCallback new.
	reusable := OPCallback new.
	inline addPathItem: pathItem.
	reusable addPathItem: pathItem.
	self assert: pathItem declaringOpenApi isNil.
	operation := self
		             operationNamed: 'subscribe'
		             in: (self pathNamed: '/subscriptions' in: openApi).
	operation addCallback: inline.
	self assert: pathItem declaringOpenApi equals: openApi.
	openApi components addCallback: reusable.
	self assert: pathItem declaringOpenApis asArray equals: { openApi }
]

{ #category : 'tests-operations' }
FamixOpenApiDerivedAccessorsTest >> testDeclaringOpenApiOfAReusableCallbackIsTheOpenApiOfItsComponents [

	| openApi callback |
	openApi := OPOpenApi new
		           components: OPComponents new;
		           yourself.
	callback := OPCallback new.
	openApi components addCallback: callback.
	self assert: callback declaringOpenApi equals: openApi.
	self assert: callback declaringOpenApis asArray equals: { openApi }
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

{ #category : 'tests-operations' }
FamixOpenApiDerivedAccessorsTest >> testDeclaringOpenApiTerminatesWhenACallbackPathItemHasAnOperationUsingTheSameCallback [

	| callback callbackPath |
	callback := OPCallback new.
	callbackPath := OPPath new.
	callback addPathItem: callbackPath.
	(self operationNamed: 'loop' in: callbackPath) addCallback: callback.
	self assert: callbackPath declaringOpenApi isNil.
	self assert: callback declaringOpenApi isNil.
	self assert: callbackPath declaringOpenApis isEmpty
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

{ #category : 'tests-security' }
FamixOpenApiDerivedAccessorsTest >> testEffectiveSecurityIsEmptyWhenTheOperationDisablesItsOwnSecurityToo [

	| operation |
	operation := self operationNamed: 'orphan'.
	operation addSecurityRequirement:
		(self securityRequirementNamed: 'local').
	operation securityDisabled: true.
	self assert: operation effectiveSecurity isEmpty
]

{ #category : 'tests-security' }
FamixOpenApiDerivedAccessorsTest >> testEffectiveSecurityIsEmptyWhenTheOperationDisablesTheSecurityOfTheOpenApi [

	| openApi operation |
	openApi := OPOpenApi new.
	openApi addSecurityRequirement:
		(self securityRequirementNamed: 'global').
	operation := self
		             operationNamed: 'listPets'
		             in: (self pathNamed: '/pets' in: openApi).
	operation securityDisabled: true.
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

{ #category : 'tests-security' }
FamixOpenApiDerivedAccessorsTest >> testEffectiveSecurityUsesTheDocumentWhenSecurityIsNotDisabled [

	| openApi operation global |
	openApi := OPOpenApi new.
	global := self securityRequirementNamed: 'global'.
	openApi addSecurityRequirement: global.
	operation := self
		             operationNamed: 'listPets'
		             in: (self pathNamed: '/pets' in: openApi).
	operation securityDisabled: false.
	self assert: operation effectiveSecurity asArray equals: { global }
]

{ #category : 'tests-referrers' }
FamixOpenApiDerivedAccessorsTest >> testMergedPointersAreEmptyByDefaultAndKeepWhatIsSet [

	| schema |
	schema := self schemaNamed: 'Merged'.
	self assert: schema mergedPointers isEmpty.
	schema mergedPointers: #( '#/a' '#/b' ).
	self assert: schema mergedPointers asArray equals: #( '#/a' '#/b' )
]

{ #category : 'tests-document' }
FamixOpenApiDerivedAccessorsTest >> testOldAliasesAreGone [

	self deny: (OPParameter includesSelector: #allowEmplyValue).
	self deny: (OPSchema includesSelector: #additonalProperties).
	self deny: (OPSchema includesSelector: #additonalPropertiesAllowed)
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

{ #category : 'tests-referrers' }
FamixOpenApiDerivedAccessorsTest >> testReferrersCollectTheOperationsUsingTheCallbackAndTheCallbacksUsingThePath [

	| callback first second pathItem |
	callback := OPCallback new.
	first := OPOperation new
		         addCallback: callback;
		         yourself.
	second := OPOperation new
		          addCallback: callback;
		          yourself.
	pathItem := OPPath new.
	callback addPathItem: pathItem.
	self assert: callback referrers asArray equals: {
			first.
			second }.
	self assert: pathItem referrers asArray equals: { callback }
]

{ #category : 'tests-referrers' }
FamixOpenApiDerivedAccessorsTest >> testReferrersCollectTheParametersAndMediaTypesUsingTheExample [

	| example parameter mediaType |
	example := OPExample new.
	parameter := OPParameter new
		             addExample: example;
		             yourself.
	mediaType := OPMediaType new
		             addExample: example;
		             yourself.
	self assert: example usedByParameters asArray equals: { parameter }.
	self assert: example usedByMediaTypes asArray equals: { mediaType }.
	self assert: example referrers asIdentitySet equals: {
			parameter.
			mediaType } asIdentitySet
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

{ #category : 'tests-referrers' }
FamixOpenApiDerivedAccessorsTest >> testReferrersCollectTheResponsesAndEncodingsUsingTheHeader [

	| header first second encoding |
	header := OPHeader new.
	first := OPResponse new
		         addHeader: header;
		         yourself.
	second := OPResponse new
		          addHeader: header;
		          yourself.
	encoding := OPEncoding new
		            addHeader: header;
		            yourself.
	self assert: header usedByResponses size equals: 2.
	self assert: header usedByEncodings asArray equals: { encoding }.
	self assert: header referrers size equals: 3.
	self assert: header referrers asIdentitySet equals: {
			first.
			second.
			encoding } asIdentitySet.
	self assert: first headers asArray equals: { header }
]

{ #category : 'tests-referrers' }
FamixOpenApiDerivedAccessorsTest >> testReferrersCollectTheResponsesUsingTheLink [

	| link first second |
	link := OPLink new.
	first := OPResponse new
		         addLink: link;
		         yourself.
	second := OPResponse new
		          addLink: link;
		          yourself.
	self assert: link referrers asArray equals: {
			first.
			second }
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

{ #category : 'tests-security' }
FamixOpenApiDerivedAccessorsTest >> testSecurityDisabledIsFalseByDefault [

	self deny: (self operationNamed: 'orphan') securityDisabled
]

{ #category : 'tests-security' }
FamixOpenApiDerivedAccessorsTest >> testSecurityRequirementItemIsAReferrerOfItsScheme [

	| scheme item requirement |
	scheme := OPSecurityScheme new.
	item := OPSecurityRequirementItem new
		        scheme: scheme;
		        yourself.
	requirement := self securityRequirementNamed: 'single'.
	requirement addItem: item.
	self assert: scheme referrers asArray equals: { item }.
	self assert: item requirement equals: requirement
]

{ #category : 'tests-security' }
FamixOpenApiDerivedAccessorsTest >> testSecurityRequirementItemsExpressAnAndBetweenSchemes [

	| requirement apiKey oauth2 |
	requirement := self securityRequirementNamed: 'both'.
	apiKey := OPSecurityScheme new
		          name: 'api_key';
		          yourself.
	oauth2 := OPSecurityScheme new
		          name: 'petstore_auth';
		          yourself.
	requirement
		addItem: (OPSecurityRequirementItem new
				 scheme: apiKey;
				 yourself);
		addItem: (OPSecurityRequirementItem new
				 scheme: oauth2;
				 scopeNames: #( 'read:pets' );
				 yourself).
	self assert: requirement items size equals: 2.
	self assert: requirement schemes asArray equals: {
			apiKey.
			oauth2 }.
	self
		assert: requirement items last scopeNames asArray
		equals: #( 'read:pets' )
]

{ #category : 'tests-referrers' }
FamixOpenApiDerivedAccessorsTest >> testSubSchemaIsASchemaLinkedToItsLargerSchemaInBothDirections [

	| larger sub |
	larger := self schemaNamed: 'Pet'.
	sub := OPSubSchema new
		       name: 'PetSummary';
		       yourself.
	sub subSchemaOf: larger.
	self assert: (sub isKindOf: OPSchema).
	self assert: sub subSchemaOf equals: larger.
	self assert: larger subSchemas asArray equals: { sub }.
	sub subSchemaOf: nil.
	self assert: larger subSchemas isEmpty
]

{ #category : 'tests-referrers' }
FamixOpenApiDerivedAccessorsTest >> testSubSchemaKeepsTheDerivedAccessorsOfSchema [

	| larger sub property parameter |
	larger := self schemaNamed: 'Pet'.
	sub := OPSubSchema new
		       name: 'PetSummary';
		       yourself.
	sub subSchemaOf: larger.
	property := OPProperty new
		            name: 'id';
		            yourself.
	sub addProperty: property.
	parameter := self parameterNamed: 'summary' location: 'query'.
	parameter schema: sub.
	self assert: sub allProperties asArray equals: { property }.
	self assert: sub referrers asArray equals: { parameter }.
	self assert: sub mergedPointers isEmpty.
	self assert: sub types isEmpty
]

{ #category : 'tests-document' }
FamixOpenApiDerivedAccessorsTest >> testTagDeprecatedAliasesRedirectToOpenApi [

	| tag openApi |
	tag := self tagNamed: 'pets'.
	openApi := OPOpenApi new.
	tag anApi: openApi.
	self assert: tag openApi equals: openApi.
	self assert: tag anApi equals: openApi.
	self assert: openApi tags asArray equals: { tag }
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

{ #category : 'tests-document' }
FamixOpenApiDerivedAccessorsTest >> testUnresolvedReferencesAreOwnedByTheOpenApi [

	| openApi reference |
	openApi := OPOpenApi new.
	reference := OPReference new
		             target: 'https://example.com/owner.json#/Owner';
		             yourself.
	openApi addUnresolvedReference: reference.
	self
		assert: openApi unresolvedReferences asArray
		equals: { reference }.
	self assert: reference openApi equals: openApi
]
