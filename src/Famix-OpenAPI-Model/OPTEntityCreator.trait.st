"
This trait is used by Famix models.
It provides an API for creating entities and adding them to the model.


"
Trait {
	#name : 'OPTEntityCreator',
	#category : 'Famix-OpenAPI-Model-Model',
	#package : 'Famix-OpenAPI-Model',
	#tag : 'Model'
}

{ #category : 'meta' }
OPTEntityCreator classSide >> annotation [

	<ignoreForCoverage>
	<FMClass: #TEntityCreator super: #Object>
	<package: #'Famix-OpenAPI-Model'>
	<generated>
]

{ #category : 'entity creation' }
OPTEntityCreator >> newApi [

	<ignoreForCoverage>
	<generated>
	^ self add: OPApi new
]

{ #category : 'entity creation' }
OPTEntityCreator >> newApiNamed: aName [

	<ignoreForCoverage>
	<generated>
	^ self add: (OPApi named: aName)
]

{ #category : 'entity creation' }
OPTEntityCreator >> newCallback [

	<ignoreForCoverage>
	<generated>
	^ self add: OPCallback new
]

{ #category : 'entity creation' }
OPTEntityCreator >> newCallbackEntry [

	<ignoreForCoverage>
	<generated>
	^ self add: OPCallbackEntry new
]

{ #category : 'entity creation' }
OPTEntityCreator >> newCallbackEntryNamed: aName [

	<ignoreForCoverage>
	<generated>
	^ self add: (OPCallbackEntry named: aName)
]

{ #category : 'entity creation' }
OPTEntityCreator >> newCallbackNamed: aName [

	<ignoreForCoverage>
	<generated>
	^ self add: (OPCallback named: aName)
]

{ #category : 'entity creation' }
OPTEntityCreator >> newComponents [

	<ignoreForCoverage>
	<generated>
	^ self add: OPComponents new
]

{ #category : 'entity creation' }
OPTEntityCreator >> newComponentsNamed: aName [

	<ignoreForCoverage>
	<generated>
	^ self add: (OPComponents named: aName)
]

{ #category : 'entity creation' }
OPTEntityCreator >> newContact [

	<ignoreForCoverage>
	<generated>
	^ self add: OPContact new
]

{ #category : 'entity creation' }
OPTEntityCreator >> newContactNamed: aName [

	<ignoreForCoverage>
	<generated>
	^ self add: (OPContact named: aName)
]

{ #category : 'entity creation' }
OPTEntityCreator >> newContainedCollections [

	<ignoreForCoverage>
	<generated>
	^ self add: OPContainedCollections new
]

{ #category : 'entity creation' }
OPTEntityCreator >> newContainedCollectionsNamed: aName [

	<ignoreForCoverage>
	<generated>
	^ self add: (OPContainedCollections named: aName)
]

{ #category : 'entity creation' }
OPTEntityCreator >> newDiscriminator [

	<ignoreForCoverage>
	<generated>
	^ self add: OPDiscriminator new
]

{ #category : 'entity creation' }
OPTEntityCreator >> newDiscriminatorMapping [

	<ignoreForCoverage>
	<generated>
	^ self add: OPDiscriminatorMapping new
]

{ #category : 'entity creation' }
OPTEntityCreator >> newDiscriminatorMappingNamed: aName [

	<ignoreForCoverage>
	<generated>
	^ self add: (OPDiscriminatorMapping named: aName)
]

{ #category : 'entity creation' }
OPTEntityCreator >> newDiscriminatorNamed: aName [

	<ignoreForCoverage>
	<generated>
	^ self add: (OPDiscriminator named: aName)
]

{ #category : 'entity creation' }
OPTEntityCreator >> newEncoding [

	<ignoreForCoverage>
	<generated>
	^ self add: OPEncoding new
]

{ #category : 'entity creation' }
OPTEntityCreator >> newEncodingNamed: aName [

	<ignoreForCoverage>
	<generated>
	^ self add: (OPEncoding named: aName)
]

{ #category : 'entity creation' }
OPTEntityCreator >> newExample [

	<ignoreForCoverage>
	<generated>
	^ self add: OPExample new
]

{ #category : 'entity creation' }
OPTEntityCreator >> newExampleEntry [

	<ignoreForCoverage>
	<generated>
	^ self add: OPExampleEntry new
]

{ #category : 'entity creation' }
OPTEntityCreator >> newExampleEntryNamed: aName [

	<ignoreForCoverage>
	<generated>
	^ self add: (OPExampleEntry named: aName)
]

{ #category : 'entity creation' }
OPTEntityCreator >> newExampleNamed: aName [

	<ignoreForCoverage>
	<generated>
	^ self add: (OPExample named: aName)
]

{ #category : 'entity creation' }
OPTEntityCreator >> newExternalDocs [

	<ignoreForCoverage>
	<generated>
	^ self add: OPExternalDocs new
]

{ #category : 'entity creation' }
OPTEntityCreator >> newExternalDocsNamed: aName [

	<ignoreForCoverage>
	<generated>
	^ self add: (OPExternalDocs named: aName)
]

{ #category : 'entity creation' }
OPTEntityCreator >> newExternalDocumentation [

	<ignoreForCoverage>
	<generated>
	^ self add: OPExternalDocumentation new
]

{ #category : 'entity creation' }
OPTEntityCreator >> newExternalDocumentationNamed: aName [

	<ignoreForCoverage>
	<generated>
	^ self add: (OPExternalDocumentation named: aName)
]

{ #category : 'entity creation' }
OPTEntityCreator >> newHeader [

	<ignoreForCoverage>
	<generated>
	^ self add: OPHeader new
]

{ #category : 'entity creation' }
OPTEntityCreator >> newHeaderEntry [

	<ignoreForCoverage>
	<generated>
	^ self add: OPHeaderEntry new
]

{ #category : 'entity creation' }
OPTEntityCreator >> newHeaderEntryNamed: aName [

	<ignoreForCoverage>
	<generated>
	^ self add: (OPHeaderEntry named: aName)
]

{ #category : 'entity creation' }
OPTEntityCreator >> newHeaderNamed: aName [

	<ignoreForCoverage>
	<generated>
	^ self add: (OPHeader named: aName)
]

{ #category : 'entity creation' }
OPTEntityCreator >> newInfo [

	<ignoreForCoverage>
	<generated>
	^ self add: OPInfo new
]

{ #category : 'entity creation' }
OPTEntityCreator >> newInfoNamed: aName [

	<ignoreForCoverage>
	<generated>
	^ self add: (OPInfo named: aName)
]

{ #category : 'entity creation' }
OPTEntityCreator >> newItemsDefinition [

	<ignoreForCoverage>
	<generated>
	^ self add: OPItemsDefinition new
]

{ #category : 'entity creation' }
OPTEntityCreator >> newItemsDefinitionNamed: aName [

	<ignoreForCoverage>
	<generated>
	^ self add: (OPItemsDefinition named: aName)
]

{ #category : 'entity creation' }
OPTEntityCreator >> newLicense [

	<ignoreForCoverage>
	<generated>
	^ self add: OPLicense new
]

{ #category : 'entity creation' }
OPTEntityCreator >> newLicenseNamed: aName [

	<ignoreForCoverage>
	<generated>
	^ self add: (OPLicense named: aName)
]

{ #category : 'entity creation' }
OPTEntityCreator >> newLink [

	<ignoreForCoverage>
	<generated>
	^ self add: OPLink new
]

{ #category : 'entity creation' }
OPTEntityCreator >> newLinkEntry [

	<ignoreForCoverage>
	<generated>
	^ self add: OPLinkEntry new
]

{ #category : 'entity creation' }
OPTEntityCreator >> newLinkEntryNamed: aName [

	<ignoreForCoverage>
	<generated>
	^ self add: (OPLinkEntry named: aName)
]

{ #category : 'entity creation' }
OPTEntityCreator >> newLinkNamed: aName [

	<ignoreForCoverage>
	<generated>
	^ self add: (OPLink named: aName)
]

{ #category : 'entity creation' }
OPTEntityCreator >> newMediaType [

	<ignoreForCoverage>
	<generated>
	^ self add: OPMediaType new
]

{ #category : 'entity creation' }
OPTEntityCreator >> newMediaTypeEntry [

	<ignoreForCoverage>
	<generated>
	^ self add: OPMediaTypeEntry new
]

{ #category : 'entity creation' }
OPTEntityCreator >> newMediaTypeEntryNamed: aName [

	<ignoreForCoverage>
	<generated>
	^ self add: (OPMediaTypeEntry named: aName)
]

{ #category : 'entity creation' }
OPTEntityCreator >> newMediaTypeNamed: aName [

	<ignoreForCoverage>
	<generated>
	^ self add: (OPMediaType named: aName)
]

{ #category : 'entity creation' }
OPTEntityCreator >> newOAuthFlow [

	<ignoreForCoverage>
	<generated>
	^ self add: OPOAuthFlow new
]

{ #category : 'entity creation' }
OPTEntityCreator >> newOAuthFlowNamed: aName [

	<ignoreForCoverage>
	<generated>
	^ self add: (OPOAuthFlow named: aName)
]

{ #category : 'entity creation' }
OPTEntityCreator >> newOpenApi [

	<ignoreForCoverage>
	<generated>
	^ self add: OPOpenApi new
]

{ #category : 'entity creation' }
OPTEntityCreator >> newOpenApiNamed: aName [

	<ignoreForCoverage>
	<generated>
	^ self add: (OPOpenApi named: aName)
]

{ #category : 'entity creation' }
OPTEntityCreator >> newOperation [

	<ignoreForCoverage>
	<generated>
	^ self add: OPOperation new
]

{ #category : 'entity creation' }
OPTEntityCreator >> newOperationNamed: aName [

	<ignoreForCoverage>
	<generated>
	^ self add: (OPOperation named: aName)
]

{ #category : 'entity creation' }
OPTEntityCreator >> newParameter [

	<ignoreForCoverage>
	<generated>
	^ self add: OPParameter new
]

{ #category : 'entity creation' }
OPTEntityCreator >> newParameterEntry [

	<ignoreForCoverage>
	<generated>
	^ self add: OPParameterEntry new
]

{ #category : 'entity creation' }
OPTEntityCreator >> newParameterEntryNamed: aName [

	<ignoreForCoverage>
	<generated>
	^ self add: (OPParameterEntry named: aName)
]

{ #category : 'entity creation' }
OPTEntityCreator >> newParameterNamed: aName [

	<ignoreForCoverage>
	<generated>
	^ self add: (OPParameter named: aName)
]

{ #category : 'entity creation' }
OPTEntityCreator >> newPath [

	<ignoreForCoverage>
	<generated>
	^ self add: OPPath new
]

{ #category : 'entity creation' }
OPTEntityCreator >> newPathNamed: aName [

	<ignoreForCoverage>
	<generated>
	^ self add: (OPPath named: aName)
]

{ #category : 'entity creation' }
OPTEntityCreator >> newProperty [

	<ignoreForCoverage>
	<generated>
	^ self add: OPProperty new
]

{ #category : 'entity creation' }
OPTEntityCreator >> newPropertyNamed: aName [

	<ignoreForCoverage>
	<generated>
	^ self add: (OPProperty named: aName)
]

{ #category : 'entity creation' }
OPTEntityCreator >> newReference [

	<ignoreForCoverage>
	<generated>
	^ self add: OPReference new
]

{ #category : 'entity creation' }
OPTEntityCreator >> newReferenceNamed: aName [

	<ignoreForCoverage>
	<generated>
	^ self add: (OPReference named: aName)
]

{ #category : 'entity creation' }
OPTEntityCreator >> newRequestBody [

	<ignoreForCoverage>
	<generated>
	^ self add: OPRequestBody new
]

{ #category : 'entity creation' }
OPTEntityCreator >> newRequestBodyEntry [

	<ignoreForCoverage>
	<generated>
	^ self add: OPRequestBodyEntry new
]

{ #category : 'entity creation' }
OPTEntityCreator >> newRequestBodyEntryNamed: aName [

	<ignoreForCoverage>
	<generated>
	^ self add: (OPRequestBodyEntry named: aName)
]

{ #category : 'entity creation' }
OPTEntityCreator >> newRequestBodyNamed: aName [

	<ignoreForCoverage>
	<generated>
	^ self add: (OPRequestBody named: aName)
]

{ #category : 'entity creation' }
OPTEntityCreator >> newRequiredSecurityScheme [

	<ignoreForCoverage>
	<generated>
	^ self add: OPRequiredSecurityScheme new
]

{ #category : 'entity creation' }
OPTEntityCreator >> newRequiredSecuritySchemeNamed: aName [

	<ignoreForCoverage>
	<generated>
	^ self add: (OPRequiredSecurityScheme named: aName)
]

{ #category : 'entity creation' }
OPTEntityCreator >> newResponse [

	<ignoreForCoverage>
	<generated>
	^ self add: OPResponse new
]

{ #category : 'entity creation' }
OPTEntityCreator >> newResponseDefinitionEntry [

	<ignoreForCoverage>
	<generated>
	^ self add: OPResponseDefinitionEntry new
]

{ #category : 'entity creation' }
OPTEntityCreator >> newResponseDefinitionEntryNamed: aName [

	<ignoreForCoverage>
	<generated>
	^ self add: (OPResponseDefinitionEntry named: aName)
]

{ #category : 'entity creation' }
OPTEntityCreator >> newResponseEntry [

	<ignoreForCoverage>
	<generated>
	^ self add: OPResponseEntry new
]

{ #category : 'entity creation' }
OPTEntityCreator >> newResponseEntryNamed: aName [

	<ignoreForCoverage>
	<generated>
	^ self add: (OPResponseEntry named: aName)
]

{ #category : 'entity creation' }
OPTEntityCreator >> newResponseNamed: aName [

	<ignoreForCoverage>
	<generated>
	^ self add: (OPResponse named: aName)
]

{ #category : 'entity creation' }
OPTEntityCreator >> newSchema [

	<ignoreForCoverage>
	<generated>
	^ self add: OPSchema new
]

{ #category : 'entity creation' }
OPTEntityCreator >> newSchemaEntry [

	<ignoreForCoverage>
	<generated>
	^ self add: OPSchemaEntry new
]

{ #category : 'entity creation' }
OPTEntityCreator >> newSchemaEntryNamed: aName [

	<ignoreForCoverage>
	<generated>
	^ self add: (OPSchemaEntry named: aName)
]

{ #category : 'entity creation' }
OPTEntityCreator >> newSchemaNamed: aName [

	<ignoreForCoverage>
	<generated>
	^ self add: (OPSchema named: aName)
]

{ #category : 'entity creation' }
OPTEntityCreator >> newSecurityRequirement [

	<ignoreForCoverage>
	<generated>
	^ self add: OPSecurityRequirement new
]

{ #category : 'entity creation' }
OPTEntityCreator >> newSecurityRequirementNamed: aName [

	<ignoreForCoverage>
	<generated>
	^ self add: (OPSecurityRequirement named: aName)
]

{ #category : 'entity creation' }
OPTEntityCreator >> newSecurityScheme [

	<ignoreForCoverage>
	<generated>
	^ self add: OPSecurityScheme new
]

{ #category : 'entity creation' }
OPTEntityCreator >> newSecuritySchemeEntry [

	<ignoreForCoverage>
	<generated>
	^ self add: OPSecuritySchemeEntry new
]

{ #category : 'entity creation' }
OPTEntityCreator >> newSecuritySchemeEntryNamed: aName [

	<ignoreForCoverage>
	<generated>
	^ self add: (OPSecuritySchemeEntry named: aName)
]

{ #category : 'entity creation' }
OPTEntityCreator >> newSecuritySchemeNamed: aName [

	<ignoreForCoverage>
	<generated>
	^ self add: (OPSecurityScheme named: aName)
]

{ #category : 'entity creation' }
OPTEntityCreator >> newSecurityScope [

	<ignoreForCoverage>
	<generated>
	^ self add: OPSecurityScope new
]

{ #category : 'entity creation' }
OPTEntityCreator >> newSecurityScopeNamed: aName [

	<ignoreForCoverage>
	<generated>
	^ self add: (OPSecurityScope named: aName)
]

{ #category : 'entity creation' }
OPTEntityCreator >> newServer [

	<ignoreForCoverage>
	<generated>
	^ self add: OPServer new
]

{ #category : 'entity creation' }
OPTEntityCreator >> newServerNamed: aName [

	<ignoreForCoverage>
	<generated>
	^ self add: (OPServer named: aName)
]

{ #category : 'entity creation' }
OPTEntityCreator >> newServerVariable [

	<ignoreForCoverage>
	<generated>
	^ self add: OPServerVariable new
]

{ #category : 'entity creation' }
OPTEntityCreator >> newServerVariableNamed: aName [

	<ignoreForCoverage>
	<generated>
	^ self add: (OPServerVariable named: aName)
]

{ #category : 'entity creation' }
OPTEntityCreator >> newTag [

	<ignoreForCoverage>
	<generated>
	^ self add: OPTag new
]

{ #category : 'entity creation' }
OPTEntityCreator >> newTagNamed: aName [

	<ignoreForCoverage>
	<generated>
	^ self add: (OPTag named: aName)
]

{ #category : 'entity creation' }
OPTEntityCreator >> newXMLElement [

	<ignoreForCoverage>
	<generated>
	^ self add: OPXMLElement new
]

{ #category : 'entity creation' }
OPTEntityCreator >> newXMLElementNamed: aName [

	<ignoreForCoverage>
	<generated>
	^ self add: (OPXMLElement named: aName)
]
