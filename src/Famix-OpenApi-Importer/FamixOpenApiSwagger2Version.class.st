"
I am a concrete specification version handled by the importer; see my superclass.
"
Class {
	#name : 'FamixOpenApiSwagger2Version',
	#superclass : 'FamixOpenApiSpecVersion',
	#category : 'Famix-OpenApi-Importer',
	#package : 'Famix-OpenApi-Importer'
}

{ #category : 'schema normalisation' }
FamixOpenApiSwagger2Version >> explicitNullFlagFrom: aSchemaNode [
	"Answer whether aSchemaNode has x-nullable: true."

	^ (aSchemaNode at: 'x-nullable' ifAbsent: [ nil ]) == true
]

{ #category : 'security normalisation' }
FamixOpenApiSwagger2Version >> flowTypeFor: aFlowName [
	"Answer the OpenAPI 3 flow type of the Swagger 2 flow aFlowName."

	^ aFlowName = 'accessCode'
		  ifTrue: [ 'authorizationCode' ]
		  ifFalse: [
			  aFlowName = 'application'
				  ifTrue: [ 'clientCredentials' ]
				  ifFalse: [ aFlowName ] ]
]

{ #category : 'testing' }
FamixOpenApiSwagger2Version >> isSwagger2 [

	^ true
]

{ #category : 'parameters' }
FamixOpenApiSwagger2Version >> parameterSchemaKeys [
	"Answer the keys of a non-body, non-formData parameter that describe its schema."

	^ #( 'type' 'format' 'items' 'default' 'enum' 'maximum' 'exclusiveMaximum'
	     'minimum' 'exclusiveMinimum' 'maxLength' 'minLength' 'pattern'
	     'maxItems' 'minItems' 'uniqueItems' 'multipleOf' )
]

{ #category : 'references and servers' }
FamixOpenApiSwagger2Version >> refTargetPointerFor: aRefString [
	"Answer aRefString with its Swagger 2 section prefix replaced by the OpenAPI 3 components section."

	aRefString isString ifFalse: [ ^ aRefString ].
	self sectionMapping do: [ :association |
		(aRefString beginsWith: association key) ifTrue: [
			^ association value
			  , (aRefString allButFirst: association key size) ] ].
	^ aRefString
]

{ #category : 'references and servers' }
FamixOpenApiSwagger2Version >> sectionMapping [
	"Answer the associations of Swagger 2 section prefixes to OpenAPI 3 ones."

	^ {
		  ('#/definitions/' -> '#/components/schemas/').
		  ('#/parameters/' -> '#/components/parameters/').
		  ('#/responses/' -> '#/components/responses/').
		  ('#/securityDefinitions/' -> '#/components/securitySchemes/') }
]

{ #category : 'security normalisation' }
FamixOpenApiSwagger2Version >> securitySchemeFor: aType declared: aSchemeName [
	"A Swagger 2 basic security definition is the HTTP basic scheme."

	^ aType = 'basic'
		  ifTrue: [ 'basic' ]
		  ifFalse: [ aSchemeName ]
]

{ #category : 'security normalisation' }
FamixOpenApiSwagger2Version >> securitySchemeKeys [
	"A Swagger 2 oauth2 scheme carries its single flow directly."

	^ super securitySchemeKeys
	  , #( 'flow' 'authorizationUrl' 'tokenUrl' 'scopes' )
]

{ #category : 'security normalisation' }
FamixOpenApiSwagger2Version >> securityTypeFrom: aType [
	"Swagger 2 spells the HTTP basic type basic."

	^ aType = 'basic'
		  ifTrue: [ 'http' ]
		  ifFalse: [ aType ]
]

{ #category : 'references and servers' }
FamixOpenApiSwagger2Version >> serverAt: aUrl [

	^ Dictionary new
		  at: 'url' put: aUrl;
		  yourself
]

{ #category : 'references and servers' }
FamixOpenApiSwagger2Version >> serversFrom: aDocumentNode [
	"Answer the servers built from host, basePath and schemes of aDocumentNode."

	| host basePath schemes |
	aDocumentNode isDictionary ifFalse: [ ^ self defaultServers ].
	host := aDocumentNode at: 'host' ifAbsent: [ nil ].
	basePath := aDocumentNode at: 'basePath' ifAbsent: [ nil ].
	basePath isString ifFalse: [ basePath := '' ].
	(host isString and: [ host notEmpty ]) ifFalse: [
		^ { (self serverAt: (basePath isEmpty
				    ifTrue: [ '/' ]
				    ifFalse: [ basePath ])) } ].
	schemes := aDocumentNode at: 'schemes' ifAbsent: [ nil ].
	(schemes isCollection and: [
		 schemes isString not and: [ schemes notEmpty ] ]) ifFalse: [
		schemes := #( 'https' ) ].
	^ (schemes select: #isString) asArray collect: [ :scheme |
		  self serverAt: scheme , '://' , host , basePath ]
]

{ #category : 'parameters' }
FamixOpenApiSwagger2Version >> styleAndExplodeFor: aCollectionFormat in: aLocation [
	"Answer an array with the OpenAPI 3 style and explode matching aCollectionFormat of a parameter located in aLocation, or nil when there is no equivalent (tsv, or an unknown format or location)."

	aCollectionFormat = 'multi' ifTrue: [ ^ #( 'form' true ) ].
	(aLocation = 'query' or: [ aLocation = 'cookie' ]) ifTrue: [
		aCollectionFormat = 'csv' ifTrue: [ ^ #( 'form' false ) ].
		aCollectionFormat = 'ssv' ifTrue: [ ^ #( 'spaceDelimited'
			     false ) ].
		aCollectionFormat = 'pipes' ifTrue: [ ^ #( 'pipeDelimited'
			     false ) ].
		^ nil ].
	(aLocation = 'path' or: [ aLocation = 'header' ]) ifTrue: [
		aCollectionFormat = 'csv' ifTrue: [ ^ #( 'simple' false ) ] ].
	^ nil
]
