"
V10, tier 3 (the security graph, the links, the tags): the items of a security requirement and the scheme each one designates, the flows of a security scheme and their scopes, in OpenAPI 3 and Swagger 2.
"
Class {
	#name : 'FamixOpenApiRelationSecurityTest',
	#superclass : 'FamixOpenApiRelationTestCase',
	#category : 'Famix-OpenApi-Validation-Test',
	#package : 'Famix-OpenApi-Validation-Test'
}

{ #category : 'tests' }
FamixOpenApiRelationSecurityTest >> testARequirementHoldsOneItemPerKeyEvenForAnUnknownSchemeAndAnEmptyOneNone31 [
	"VERIFIED"

	self
		assertExpectedAt: '#/security/0'
		selector: #items
		in: self documentSecurity31
		is: #( '#/security/0/k' '#/security/0/unknown' ).
	self
		assertExpectedAt: '#/security/1'
		selector: #items
		in: self documentSecurity31
		is: #(  )
]

{ #category : 'tests' }
FamixOpenApiRelationSecurityTest >> testAnItemDesignatesTheSchemeOfTheComponentsOfItsNameOrNone31 [

	self
		assertExpectedAt: '#/security/0/k'
		selector: #scheme
		in: self documentSecurity31
		is: #( '#/components/securitySchemes/k' ).
	self
		assertExpectedAt: '#/security/0/unknown'
		selector: #scheme
		in: self documentSecurity31
		is: #(  )
]

{ #category : 'tests' }
FamixOpenApiRelationSecurityTest >> testTheExternalDocumentationOfATagAnOperationAndTheRootIsHeld [

	| json |
	json := self
		        replace: '"tags":[{"name":"a"}]'
		        with:
		        '"externalDocs":{"url":"http://r"},"tags":[{"name":"a","externalDocs":{"url":"http://t"}}]'
		        in: self documentStructure30.
	self
		assertExpectedAt: '#'
		selector: #externalDocs
		in: json
		is: #( '#/externalDocs' ).
	self
		assertExpectedAt: '#/tags/0'
		selector: #externalDocs
		in: json
		is: #( '#/tags/0/externalDocs' )
]

{ #category : 'tests' }
FamixOpenApiRelationSecurityTest >> testTheFlowsOfASchemeAreHeldInTheOrderOfTheSourceWithTheirScopes31 [

	self
		assertExpectedAt: '#/components/securitySchemes/k'
		selector: #flows
		in: self documentSecurity31
		is: #( '#/components/securitySchemes/k/flows/implicit'
			   '#/components/securitySchemes/k/flows/password' ).
	self
		assertExpectedAt: '#/components/securitySchemes/k/flows/implicit'
		selector: #scopes
		in: self documentSecurity31
		is: #( '#/components/securitySchemes/k/flows/implicit/scopes/a'
			   '#/components/securitySchemes/k/flows/implicit/scopes/b' ).
	self
		assertExpectedAt: '#/components/securitySchemes/k/flows/password'
		selector: #scopes
		in: self documentSecurity31
		is: #(  )
]

{ #category : 'tests' }
FamixOpenApiRelationSecurityTest >> testTheItemOfASwagger2RequirementDesignatesTheSecurityDefinition [

	self
		assertExpectedAt: '#/paths/~1p/post/security/0/k'
		selector: #scheme
		in: self documentStructureSwagger2
		is: #( '#/securityDefinitions/k' )
]

{ #category : 'tests' }
FamixOpenApiRelationSecurityTest >> testTheOauth2SchemeOfSwagger2IsItsOwnFlowWithItsScopes [
	"VERIFIED: the OPOAuthFlow is at the pointer of the scheme"

	self
		assertExpectedAt: '#/securityDefinitions/k'
		selector: #scopes
		in: self documentStructureSwagger2
		is: #( '#/securityDefinitions/k/scopes/s1'
			   '#/securityDefinitions/k/scopes/s2' ).
	self
		assertExpectedAt: '#/securityDefinitions/k'
		selector: #flows
		in: self documentStructureSwagger2
		is: #( '#/securityDefinitions/k' )
]

{ #category : 'tests' }
FamixOpenApiRelationSecurityTest >> testTheRequirementsOfTheRootAndOfAnOperationAreHeldInOrder [

	self
		assertExpectedAt: '#'
		selector: #securityRequirements
		in: self documentSecurity31
		is: #( '#/security/0' '#/security/1' ).
	self
		assertExpectedAt: '#/paths/~1p/get'
		selector: #securityRequirements
		in: self documentStructure30
		is: #( '#/paths/~1p/get/security/0' '#/paths/~1p/get/security/1' )
]
