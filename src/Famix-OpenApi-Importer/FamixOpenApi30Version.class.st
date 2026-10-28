"
I am a concrete specification version handled by the importer; see my superclass.
"
Class {
	#name : 'FamixOpenApi30Version',
	#superclass : 'FamixOpenApiSpecVersion',
	#category : 'Famix-OpenApi-Importer',
	#package : 'Famix-OpenApi-Importer'
}

{ #category : 'schema normalisation' }
FamixOpenApi30Version >> explicitNullFlagFrom: aSchemaNode [
	"Answer whether aSchemaNode has nullable: true."

	^ (aSchemaNode at: 'nullable' ifAbsent: [ nil ]) == true
]

{ #category : 'testing' }
FamixOpenApi30Version >> isOpenApi30 [

	^ true
]

{ #category : 'references and servers' }
FamixOpenApi30Version >> serversFrom: aDocumentNode [
	"Answer the servers of aDocumentNode."

	^ self openApiServersFrom: aDocumentNode
]
