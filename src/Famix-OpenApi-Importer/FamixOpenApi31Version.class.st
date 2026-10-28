"
I am a concrete specification version handled by the importer; see my superclass.
"
Class {
	#name : 'FamixOpenApi31Version',
	#superclass : 'FamixOpenApiSpecVersion',
	#category : 'Famix-OpenApi-Importer',
	#package : 'Famix-OpenApi-Importer'
}

{ #category : 'testing' }
FamixOpenApi31Version >> isOpenApi31 [

	^ true
]

{ #category : 'references and servers' }
FamixOpenApi31Version >> serversFrom: aDocumentNode [
	"Answer the servers of aDocumentNode."

	^ self openApiServersFrom: aDocumentNode
]
