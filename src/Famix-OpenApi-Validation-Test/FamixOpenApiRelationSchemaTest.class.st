"
V10, tier 2 (the schema graph): properties (an OPProperty per key and its value schema), items, prefixItems, allOf, oneOf, anyOf, not, additionalProperties, the discriminator and the targets of its mapping, with what each derivation designates VERIFIED by import (the alias that holds its target in allOf, the set that keeps the first occurrence, unresolved and cyclic schemas, the OpenAPI 3.1 $ref with a sibling).
"
Class {
	#name : 'FamixOpenApiRelationSchemaTest',
	#superclass : 'FamixOpenApiRelationTestCase',
	#category : 'Famix-OpenApi-Validation-Test',
	#package : 'Famix-OpenApi-Validation-Test'
}

{ #category : 'tests' }
FamixOpenApiRelationSchemaTest >> testABooleanAdditionalPropertiesOrItemsHoldsNothing31 [

	self
		assertExpectedAt: '#/components/schemas/C'
		selector: #additionalProperties
		in: self documentStructure31
		is: #(  ).
	self
		assertExpectedAt: '#/components/schemas/C'
		selector: #items
		in: self documentStructure31
		is: #(  )
]

{ #category : 'tests' }
FamixOpenApiRelationSchemaTest >> testAMappingValueIsASchemaNameALocalReferenceOrNothing31 [
	"VERIFIED: a name and a $ref designate T; an unresolved value and an external one designate nothing"

	| discriminator entries |
	discriminator := '#/components/schemas/Disc/discriminator'.
	entries := #( 'a' 'b' 'c' 'd' ) collect: [ :each |
		           '#/components/schemas/Disc/discriminator/mapping/' , each ].
	(entries first: 2) do: [ :each |
		self
			assertExpectedAt: each
			selector: #schema
			in: self documentSecurity31
			is: #( '#/components/schemas/T' ) ].
	(entries last: 2) do: [ :each |
		self
			assertExpectedAt: each
			selector: #schema
			in: self documentSecurity31
			is: #(  ) ].
	self
		assertExpectedAt: discriminator
		selector: #mapping
		in: self documentSecurity31
		is: entries
]

{ #category : 'tests' }
FamixOpenApiRelationSchemaTest >> testASchemaReferenceOfAMediaTypeAndOfAParameterHoldsTheSchemaItDesignates30 [

	self
		assertExpectedAt:
		'#/paths/~1p/get/responses/404/content/application~1json'
		selector: #schema
		in: self documentStructure30
		is: #( '#/components/schemas/S' ).
	self
		assertExpectedAt: '#/components/parameters/P'
		selector: #schema
		in: self documentStructure30
		is: #( '#/components/schemas/T' )
]

{ #category : 'tests' }
FamixOpenApiRelationSchemaTest >> testAnAliasInTheComponentsHoldsItsTargetInAllOfAndIsTheTargetOfTheReferencesToIt31 [
	"VERIFIED: A is an alias of T, B designates A (one step), not T"

	self
		assertExpectedAt: '#/components/schemas/A'
		selector: #allOf
		in: self documentStructure31
		is: #( '#/components/schemas/T' ).
	self
		assertExpectedAt: '#/components/schemas/B'
		selector: #allOf
		in: self documentStructure31
		is: #( '#/components/schemas/A' )
]

{ #category : 'tests' }
FamixOpenApiRelationSchemaTest >> testAnAllOfHoldsTheTargetsOfItsReferencesInTheOrderOfTheSourceAndOnce31 [
	"VERIFIED: T listed twice is held once, U after it"

	self
		assertExpectedAt: '#/components/schemas/S'
		selector: #allOf
		in: self documentStructure31
		is: #( '#/components/schemas/T' '#/components/schemas/U' )
]

{ #category : 'tests' }
FamixOpenApiRelationSchemaTest >> testAnInlineSchemaOfAllOfIsAnEntityOfItsOwn30 [

	self
		assertExpectedAt: '#/components/schemas/S'
		selector: #allOf
		in: self documentStructure30
		is: #( '#/components/schemas/T' '#/components/schemas/S/allOf/1' ).
	self
		assertExpectedAt: '#/components/schemas/S/allOf/1'
		selector: #properties
		in: self documentStructure30
		is: #( '#/components/schemas/S/allOf/1/properties/a'
			   '#/components/schemas/S/allOf/1/properties/b' )
]

{ #category : 'tests' }
FamixOpenApiRelationSchemaTest >> testAnUnresolvedAliasOfOpenApi31HoldsNothing [
	"VERIFIED: an alias whose $ref is unresolved has an OPSchema and an OPReference, and no allOf"

	self
		assertExpectedAt: '#/components/schemas/Bad'
		selector: #allOf
		in: self documentSecurity31
		is: #(  )
]

{ #category : 'tests' }
FamixOpenApiRelationSchemaTest >> testAnUnresolvedSchemaIsNotHeldByAllOfPropertiesOrItems30 [
	"VERIFIED: the OPReference is at the site; the property exists without value schema"

	self
		assertExpectedAt: '#/components/schemas/Un'
		selector: #allOf
		in: self documentUnresolved30
		is: #( '#/components/schemas/Un/allOf/1' ).
	self
		assertExpectedAt: '#/components/schemas/Un'
		selector: #properties
		in: self documentUnresolved30
		is: #( '#/components/schemas/Un/properties/p' ).
	self
		assertExpectedAt: '#/components/schemas/Un/properties/p'
		selector: #valueSchema
		in: self documentUnresolved30
		is: #(  ).
	self
		assertExpectedAt: '#/components/schemas/Un'
		selector: #items
		in: self documentUnresolved30
		is: #(  )
]

{ #category : 'tests' }
FamixOpenApiRelationSchemaTest >> testCyclicAliasesHoldEachOther30 [
	"VERIFIED: Cyc and Cyc2 are aliases of each other, the schemas that designate Cyc get the alias"

	self
		assertExpectedAt: '#/components/schemas/Cyc'
		selector: #allOf
		in: self documentUnresolved30
		is: #( '#/components/schemas/Cyc2' ).
	self
		assertExpectedAt: '#/components/schemas/Cyc2'
		selector: #allOf
		in: self documentUnresolved30
		is: #( '#/components/schemas/Cyc' ).
	self
		assertExpectedAt: '#/paths/~1p/get/responses/201/content/a~1b'
		selector: #schema
		in: self documentUnresolved30
		is: #( '#/components/schemas/Cyc' )
]

{ #category : 'tests' }
FamixOpenApiRelationSchemaTest >> testKeysBesideARefOfOpenApi31AreDeferredNotCompared [
	"The importer reads the allOf beside the $ref (the schema holds the target, then the allOf), the inventory does not walk it: deferred, with its reason"

	| report key |
	report := self relationReportFor: self documentSecurity31.
	key := 'v31 Schema.allOf -> OPSchema>>allOf'.
	self assert: (report coverage deferredCountOf: key) equals: 1.
	self
		assert: (report coverage deferralReasonOf: key)
		equals: 'keys beside a $ref (OpenAPI 3.1) are not walked'.
	self assert: report gaps isEmpty
]

{ #category : 'tests' }
FamixOpenApiRelationSchemaTest >> testOneOfNotItemsAndAdditionalPropertiesHoldTheirTargets31 [

	| json |
	json := self documentStructure31.
	self
		assertExpectedAt: '#/components/schemas/S'
		selector: #oneOf
		in: json
		is: #( '#/components/schemas/U' '#/components/schemas/T' ).
	self
		assertExpectedAt: '#/components/schemas/S'
		selector: #not
		in: json
		is: #( '#/components/schemas/U' ).
	self
		assertExpectedAt: '#/components/schemas/S'
		selector: #items
		in: json
		is: #( '#/components/schemas/T' ).
	self
		assertExpectedAt: '#/components/schemas/S'
		selector: #additionalProperties
		in: json
		is: #( '#/components/schemas/T' )
]

{ #category : 'tests' }
FamixOpenApiRelationSchemaTest >> testPrefixItemsHoldTheirSchemasAndASchemaWithASiblingIsAnEntityOfItsOwn31 [
	"VERIFIED: the OpenAPI 3.1 schema that is a $ref with a sibling is an OPSchema at its pointer, and holds its target in allOf"

	self
		assertExpectedAt: '#/components/schemas/S'
		selector: #prefixItems
		in: self documentStructure31
		is: #( '#/components/schemas/S/prefixItems/0'
			   '#/components/schemas/S/prefixItems/1' ).
	self
		assertExpectedAt: '#/components/schemas/S/prefixItems/1'
		selector: #allOf
		in: self documentStructure31
		is: #( '#/components/schemas/T' )
]

{ #category : 'tests' }
FamixOpenApiRelationSchemaTest >> testTheDiscriminatorAndTheTargetsOfItsMappingAreHeld30 [
	"VERIFIED: the entry of the mapping designates the schema its value designates"

	self
		assertExpectedAt: '#/components/schemas/S'
		selector: #discriminator
		in: self documentStructure30
		is: #( '#/components/schemas/S/discriminator' ).
	self
		assertExpectedAt: '#/components/schemas/S/discriminator'
		selector: #mapping
		in: self documentStructure30
		is: #( '#/components/schemas/S/discriminator/mapping/x' ).
	self
		assertExpectedAt: '#/components/schemas/S/discriminator/mapping/x'
		selector: #schema
		in: self documentStructure30
		is: #( '#/components/schemas/T' )
]

{ #category : 'tests' }
FamixOpenApiRelationSchemaTest >> testThePropertiesAreHeldInTheOrderOfTheSourceWithTheirValueSchema31 [

	self
		assertExpectedAt: '#/components/schemas/S'
		selector: #properties
		in: self documentStructure31
		is: #( '#/components/schemas/S/properties/b'
			   '#/components/schemas/S/properties/a' ).
	self
		assertExpectedAt: '#/components/schemas/S/properties/a'
		selector: #valueSchema
		in: self documentStructure31
		is: #( '#/components/schemas/T' ).
	self
		assertExpectedAt: '#/components/schemas/S/properties/b'
		selector: #valueSchema
		in: self documentStructure31
		is: #( '#/components/schemas/S/properties/b' )
]

{ #category : 'tests' }
FamixOpenApiRelationSchemaTest >> testTheXmlAndTheExternalDocumentationOfASchemaAreHeld31 [

	self
		assertExpectedAt: '#/components/schemas/Ar'
		selector: #xml
		in: self documentSecurity31
		is: #( '#/components/schemas/Ar/xml' ).
	self
		assertExpectedAt: '#/components/schemas/Ar'
		selector: #externalDocs
		in: self documentSecurity31
		is: #( '#/components/schemas/Ar/externalDocs' )
]
