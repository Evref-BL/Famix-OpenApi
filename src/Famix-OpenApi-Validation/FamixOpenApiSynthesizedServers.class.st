"
The servers the importer builds without a source node, as a documented implicit conversion: the default server '/' of an OpenAPI 3 document that declares no server, and the servers of a Swagger 2 document made from host, basePath and schemes (one per scheme, https when there is none; only the basePath, or '/', when there is no host). They sit at #/servers/N. This class answers the urls they should have, from the root of the inventory, so that the existence check verifies their number and their urls instead of accepting them blindly.
"
Class {
	#name : 'FamixOpenApiSynthesizedServers',
	#superclass : 'Object',
	#instVars : [
		'inventory'
	],
	#category : 'Famix-OpenApi-Validation',
	#package : 'Famix-OpenApi-Validation'
}

{ #category : 'instance creation' }
FamixOpenApiSynthesizedServers class >> on: aSourceInventory [

	^ self new
		  inventory: aSourceInventory;
		  yourself
]

{ #category : 'private' }
FamixOpenApiSynthesizedServers >> basePath [

	| value |
	value := self rootValueAt: 'basePath'.
	^ value isString
		  ifTrue: [ value ]
		  ifFalse: [ '' ]
]

{ #category : 'private' }
FamixOpenApiSynthesizedServers >> declaresServers [

	^ (inventory childrenOf: '#/servers') anySatisfy: [ :each |
		  each isWrongShape not ]
]

{ #category : 'querying' }
FamixOpenApiSynthesizedServers >> expectedUrls [
	"The urls of the servers without source node, in the order of their pointers #/servers/0, #/servers/1..."

	^ inventory version = #v2
		  ifTrue: [ self swagger2Urls ]
		  ifFalse: [ self openApiUrls ]
]

{ #category : 'accessing' }
FamixOpenApiSynthesizedServers >> inventory: aSourceInventory [

	inventory := aSourceInventory
]

{ #category : 'testing' }
FamixOpenApiSynthesizedServers >> isSynthesizedServer: anEntity [
	"An OPServer at #/servers/N: the check compares their number and their urls"

	^ anEntity class == OPServer and: [
		  anEntity canonicalPointer isString and: [
			  anEntity canonicalPointer matchesRegex: '#/servers/\d+' ] ]
]

{ #category : 'private' }
FamixOpenApiSynthesizedServers >> openApiUrls [
	"The default server, unless the document declares servers (they are nodes)"

	^ self declaresServers
		  ifTrue: [ #(  ) ]
		  ifFalse: [ #( '/' ) ]
]

{ #category : 'private' }
FamixOpenApiSynthesizedServers >> rootValueAt: aKey [

	^ (inventory
		   nodeAt: FamixOpenApiSourceNode rootPointer
		   ifAbsent: [ nil ]) ifNotNil: [ :root | root valueAt: aKey ]
]

{ #category : 'private' }
FamixOpenApiSynthesizedServers >> schemes [
	"The schemes of the document that are strings; https when it has none"

	| value |
	value := self rootValueAt: 'schemes'.
	^ (value isCollection and: [
		   value isString not and: [ value isNotEmpty ] ])
		  ifTrue: [ (value select: #isString) asArray ]
		  ifFalse: [ #( 'https' ) ]
]

{ #category : 'private' }
FamixOpenApiSynthesizedServers >> swagger2Urls [
	"One url per scheme: scheme://host/basePath; without host, the basePath alone (or '/')"

	| host basePath |
	host := self rootValueAt: 'host'.
	basePath := self basePath.
	(host isString and: [ host isNotEmpty ]) ifFalse: [
		^ { (basePath ifEmpty: [ '/' ]) } ].
	^ self schemes collect: [ :scheme | scheme , '://' , host , basePath ]
]
