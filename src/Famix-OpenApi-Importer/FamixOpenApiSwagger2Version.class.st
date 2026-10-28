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

{ #category : 'testing' }
FamixOpenApiSwagger2Version >> isSwagger2 [

	^ true
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
