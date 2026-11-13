"
Derivation #servers, for the root of the document: the servers of the source when it declares some (OpenAPI 3), else the servers that the importer makes of nothing (the default server of an OpenAPI 3 document, the ones made of host, basePath and schemes in Swagger 2) at #/servers/0, #/servers/1... in the number that FamixOpenApiSynthesizedServers gives.
"
Class {
	#name : 'FamixOpenApiServersDerivation',
	#superclass : 'FamixOpenApiRelationDerivation',
	#category : 'Famix-OpenApi-Validation',
	#package : 'Famix-OpenApi-Validation'
}

{ #category : 'deriving' }
FamixOpenApiServersDerivation >> declaredServersOf: anOwner in: aCheck [
	"The servers of the source, the entries of its servers"

	^ (FamixOpenApiChildrenDerivation new
		   arguments: #( 'servers' );
		   family: family;
		   yourself) targetsOf: anOwner in: aCheck
]

{ #category : 'deriving' }
FamixOpenApiServersDerivation >> targetsOf: anOwner in: aCheck [

	| servers |
	servers := FamixOpenApiSynthesizedServers on: aCheck inventory.
	servers declaresServers ifTrue: [
		^ self declaredServersOf: anOwner in: aCheck ].
	^ (0 to: servers expectedUrls size - 1) collect: [ :index |
		  '#/servers/' , index printString ]
]
