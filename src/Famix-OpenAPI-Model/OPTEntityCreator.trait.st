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

	<FMClass: #TEntityCreator super: #Object>
	<package: #'Famix-OpenAPI-Model'>
	<generated>
	^ self
]

{ #category : 'entity creation' }
OPTEntityCreator >> newApi [

	<generated>
	^ self add: OPApi new
]

{ #category : 'entity creation' }
OPTEntityCreator >> newApiNamed: aName [

	<generated>
	^ self add: (OPApi named: aName)
]

{ #category : 'entity creation' }
OPTEntityCreator >> newCallback [

	<generated>
	^ self add: OPCallback new
]

{ #category : 'entity creation' }
OPTEntityCreator >> newCallbackEntry [

	<generated>
	^ self add: OPCallbackEntry new
]

{ #category : 'entity creation' }
OPTEntityCreator >> newCallbackEntryNamed: aName [

	<generated>
	^ self add: (OPCallbackEntry named: aName)
]

{ #category : 'entity creation' }
OPTEntityCreator >> newCallbackNamed: aName [

	<generated>
	^ self add: (OPCallback named: aName)
]

{ #category : 'entity creation' }
OPTEntityCreator >> newComponents [

	<generated>
	^ self add: OPComponents new
]

{ #category : 'entity creation' }
OPTEntityCreator >> newComponentsNamed: aName [

	<generated>
	^ self add: (OPComponents named: aName)
]

{ #category : 'entity creation' }
OPTEntityCreator >> newContact [

	<generated>
	^ self add: OPContact new
]

{ #category : 'entity creation' }
OPTEntityCreator >> newContactNamed: aName [

	<generated>
	^ self add: (OPContact named: aName)
]

{ #category : 'entity creation' }
OPTEntityCreator >> newContainedCollections [

	<generated>
	^ self add: OPContainedCollections new
]

{ #category : 'entity creation' }
OPTEntityCreator >> newContainedCollectionsNamed: aName [

	<generated>
	^ self add: (OPContainedCollections named: aName)
]

{ #category : 'entity creation' }
OPTEntityCreator >> newExample [

	<generated>
	^ self add: OPExample new
]

{ #category : 'entity creation' }
OPTEntityCreator >> newExampleEntry [

	<generated>
	^ self add: OPExampleEntry new
]

{ #category : 'entity creation' }
OPTEntityCreator >> newExampleEntryNamed: aName [

	<generated>
	^ self add: (OPExampleEntry named: aName)
]

{ #category : 'entity creation' }
OPTEntityCreator >> newExampleNamed: aName [

	<generated>
	^ self add: (OPExample named: aName)
]

{ #category : 'entity creation' }
OPTEntityCreator >> newExternalDocs [

	<generated>
	^ self add: OPExternalDocs new
]

{ #category : 'entity creation' }
OPTEntityCreator >> newExternalDocsNamed: aName [

	<generated>
	^ self add: (OPExternalDocs named: aName)
]

{ #category : 'entity creation' }
OPTEntityCreator >> newHeader [

	<generated>
	^ self add: OPHeader new
]

{ #category : 'entity creation' }
OPTEntityCreator >> newHeaderEntry [

	<generated>
	^ self add: OPHeaderEntry new
]

{ #category : 'entity creation' }
OPTEntityCreator >> newHeaderEntryNamed: aName [

	<generated>
	^ self add: (OPHeaderEntry named: aName)
]

{ #category : 'entity creation' }
OPTEntityCreator >> newHeaderNamed: aName [

	<generated>
	^ self add: (OPHeader named: aName)
]

{ #category : 'entity creation' }
OPTEntityCreator >> newInfo [

	<generated>
	^ self add: OPInfo new
]

{ #category : 'entity creation' }
OPTEntityCreator >> newInfoNamed: aName [

	<generated>
	^ self add: (OPInfo named: aName)
]

{ #category : 'entity creation' }
OPTEntityCreator >> newItemsDefinition [

	<generated>
	^ self add: OPItemsDefinition new
]

{ #category : 'entity creation' }
OPTEntityCreator >> newItemsDefinitionNamed: aName [

	<generated>
	^ self add: (OPItemsDefinition named: aName)
]

{ #category : 'entity creation' }
OPTEntityCreator >> newLicense [

	<generated>
	^ self add: OPLicense new
]

{ #category : 'entity creation' }
OPTEntityCreator >> newLicenseNamed: aName [

	<generated>
	^ self add: (OPLicense named: aName)
]

{ #category : 'entity creation' }
OPTEntityCreator >> newLink [

	<generated>
	^ self add: OPLink new
]

{ #category : 'entity creation' }
OPTEntityCreator >> newLinkEntry [

	<generated>
	^ self add: OPLinkEntry new
]

{ #category : 'entity creation' }
OPTEntityCreator >> newLinkEntryNamed: aName [

	<generated>
	^ self add: (OPLinkEntry named: aName)
]

{ #category : 'entity creation' }
OPTEntityCreator >> newLinkNamed: aName [

	<generated>
	^ self add: (OPLink named: aName)
]

{ #category : 'entity creation' }
OPTEntityCreator >> newMediaType [

	<generated>
	^ self add: OPMediaType new
]

{ #category : 'entity creation' }
OPTEntityCreator >> newMediaTypeEntry [

	<generated>
	^ self add: OPMediaTypeEntry new
]

{ #category : 'entity creation' }
OPTEntityCreator >> newMediaTypeEntryNamed: aName [

	<generated>
	^ self add: (OPMediaTypeEntry named: aName)
]

{ #category : 'entity creation' }
OPTEntityCreator >> newMediaTypeNamed: aName [

	<generated>
	^ self add: (OPMediaType named: aName)
]

{ #category : 'entity creation' }
OPTEntityCreator >> newOperation [

	<generated>
	^ self add: OPOperation new
]

{ #category : 'entity creation' }
OPTEntityCreator >> newOperationNamed: aName [

	<generated>
	^ self add: (OPOperation named: aName)
]

{ #category : 'entity creation' }
OPTEntityCreator >> newParameter [

	<generated>
	^ self add: OPParameter new
]

{ #category : 'entity creation' }
OPTEntityCreator >> newParameterEntry [

	<generated>
	^ self add: OPParameterEntry new
]

{ #category : 'entity creation' }
OPTEntityCreator >> newParameterEntryNamed: aName [

	<generated>
	^ self add: (OPParameterEntry named: aName)
]

{ #category : 'entity creation' }
OPTEntityCreator >> newParameterNamed: aName [

	<generated>
	^ self add: (OPParameter named: aName)
]

{ #category : 'entity creation' }
OPTEntityCreator >> newPath [

	<generated>
	^ self add: OPPath new
]

{ #category : 'entity creation' }
OPTEntityCreator >> newPathNamed: aName [

	<generated>
	^ self add: (OPPath named: aName)
]

{ #category : 'entity creation' }
OPTEntityCreator >> newProperty [

	<generated>
	^ self add: OPProperty new
]

{ #category : 'entity creation' }
OPTEntityCreator >> newPropertyNamed: aName [

	<generated>
	^ self add: (OPProperty named: aName)
]

{ #category : 'entity creation' }
OPTEntityCreator >> newRequestBody [

	<generated>
	^ self add: OPRequestBody new
]

{ #category : 'entity creation' }
OPTEntityCreator >> newRequestBodyEntry [

	<generated>
	^ self add: OPRequestBodyEntry new
]

{ #category : 'entity creation' }
OPTEntityCreator >> newRequestBodyEntryNamed: aName [

	<generated>
	^ self add: (OPRequestBodyEntry named: aName)
]

{ #category : 'entity creation' }
OPTEntityCreator >> newRequestBodyNamed: aName [

	<generated>
	^ self add: (OPRequestBody named: aName)
]

{ #category : 'entity creation' }
OPTEntityCreator >> newRequiredSecurityScheme [

	<generated>
	^ self add: OPRequiredSecurityScheme new
]

{ #category : 'entity creation' }
OPTEntityCreator >> newRequiredSecuritySchemeNamed: aName [

	<generated>
	^ self add: (OPRequiredSecurityScheme named: aName)
]

{ #category : 'entity creation' }
OPTEntityCreator >> newResponse [

	<generated>
	^ self add: OPResponse new
]

{ #category : 'entity creation' }
OPTEntityCreator >> newResponseDefinitionEntry [

	<generated>
	^ self add: OPResponseDefinitionEntry new
]

{ #category : 'entity creation' }
OPTEntityCreator >> newResponseDefinitionEntryNamed: aName [

	<generated>
	^ self add: (OPResponseDefinitionEntry named: aName)
]

{ #category : 'entity creation' }
OPTEntityCreator >> newResponseEntry [

	<generated>
	^ self add: OPResponseEntry new
]

{ #category : 'entity creation' }
OPTEntityCreator >> newResponseEntryNamed: aName [

	<generated>
	^ self add: (OPResponseEntry named: aName)
]

{ #category : 'entity creation' }
OPTEntityCreator >> newResponseNamed: aName [

	<generated>
	^ self add: (OPResponse named: aName)
]

{ #category : 'entity creation' }
OPTEntityCreator >> newSchema [

	<generated>
	^ self add: OPSchema new
]

{ #category : 'entity creation' }
OPTEntityCreator >> newSchemaEntry [

	<generated>
	^ self add: OPSchemaEntry new
]

{ #category : 'entity creation' }
OPTEntityCreator >> newSchemaEntryNamed: aName [

	<generated>
	^ self add: (OPSchemaEntry named: aName)
]

{ #category : 'entity creation' }
OPTEntityCreator >> newSchemaNamed: aName [

	<generated>
	^ self add: (OPSchema named: aName)
]

{ #category : 'entity creation' }
OPTEntityCreator >> newSecurityRequirement [

	<generated>
	^ self add: OPSecurityRequirement new
]

{ #category : 'entity creation' }
OPTEntityCreator >> newSecurityRequirementNamed: aName [

	<generated>
	^ self add: (OPSecurityRequirement named: aName)
]

{ #category : 'entity creation' }
OPTEntityCreator >> newSecurityScheme [

	<generated>
	^ self add: OPSecurityScheme new
]

{ #category : 'entity creation' }
OPTEntityCreator >> newSecuritySchemeEntry [

	<generated>
	^ self add: OPSecuritySchemeEntry new
]

{ #category : 'entity creation' }
OPTEntityCreator >> newSecuritySchemeEntryNamed: aName [

	<generated>
	^ self add: (OPSecuritySchemeEntry named: aName)
]

{ #category : 'entity creation' }
OPTEntityCreator >> newSecuritySchemeNamed: aName [

	<generated>
	^ self add: (OPSecurityScheme named: aName)
]

{ #category : 'entity creation' }
OPTEntityCreator >> newSecurityScope [

	<generated>
	^ self add: OPSecurityScope new
]

{ #category : 'entity creation' }
OPTEntityCreator >> newSecurityScopeNamed: aName [

	<generated>
	^ self add: (OPSecurityScope named: aName)
]

{ #category : 'entity creation' }
OPTEntityCreator >> newTag [

	<generated>
	^ self add: OPTag new
]

{ #category : 'entity creation' }
OPTEntityCreator >> newTagNamed: aName [

	<generated>
	^ self add: (OPTag named: aName)
]

{ #category : 'entity creation' }
OPTEntityCreator >> newXMLElement [

	<generated>
	^ self add: OPXMLElement new
]

{ #category : 'entity creation' }
OPTEntityCreator >> newXMLElementNamed: aName [

	<generated>
	^ self add: (OPXMLElement named: aName)
]
