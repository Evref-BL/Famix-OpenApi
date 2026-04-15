Class {
	#name : 'BaselineOfFamixOpenApi',
	#superclass : 'BaselineOf',
	#category : 'BaselineOfFamixOpenApi',
	#package : 'BaselineOfFamixOpenApi'
}

{ #category : 'baselines' }
BaselineOfFamixOpenApi >> baseline: spec [
	<baseline>
	spec for: #common do: [

		self forceHttpsForIcebergIfPresent.
		self defineDependencies: spec.
		self definePackages: spec.
		self defineGroups: spec.
	]
]

{ #category : 'baselines' }
BaselineOfFamixOpenApi >> customProjectAttributes [
    self class environment at: #MooseEntity ifAbsent: [ ^ #(#WithoutFamix) ].
    ^ #()
]

{ #category : 'baselines' }
BaselineOfFamixOpenApi >> defineDependencies: spec [
	
	spec
		baseline: 'NeoJSON'
		with: [ spec repository: 'github://svenvc/NeoJSON/repository' ].
	
	spec for: #( #WithoutFamix ) do: [
			spec
				baseline: 'Moose'
				with: [
				spec repository: 'github://moosetechnology/Moose:development/src' ].
			
		]
]

{ #category : 'baselines' }
BaselineOfFamixOpenApi >> defineGroups: spec [
		"spec group: 'default' with: #('FamixOpenApiGenerator')"
]

{ #category : 'baselines' }
BaselineOfFamixOpenApi >> definePackages: spec [
	"generic"
	"spec package: 'FamixOpenApi'."
	spec package: 'FamixOpenApiGenerator' with: [ spec requires: #( 'Moose' ) ].
	spec package: 'FamixOpenApiGenerator-Test' with: [ spec requires: #( 'FamixOpenApiGenerator' ) ].
	spec package: 'Famix-OpenApi-Importer' with: [ spec requires: #( 'FamixOpenApiGenerator' 'NeoJSON' ) ].
	spec package: 'Famix-OpenApi-Importer-Test' with: [ spec requires: #( 'Famix-OpenApi-Importer' ) ].
	spec package: 'Famix-OpenApi-Analysis' with: [ spec requires: #( 'FamixOpenApiGenerator' ) ].
	spec package: 'Famix-OpenApi-Analysis-Test' with: [ spec requires: #( 'Famix-OpenApi-Analysis' 'Famix-OpenApi-Importer' ) ].
	spec package: 'Famix-OpenAPI-Model' with: [ spec requires: #( 'FamixOpenApiGenerator' ) ].
	spec package: 'Famix-OpenAPI-Model-Extension' with: [ spec requires: #( 'Famix-OpenAPI-Model' ) ].

]

{ #category : 'private' }
BaselineOfFamixOpenApi >> forceHttpsForIcebergIfPresent [
	| icebergClass |
	icebergClass := self class environment
		at: #Iceberg
		ifAbsent: [ ^ self ].
	(icebergClass class respondsTo: #remoteTypeSelector:)
		ifTrue: [ icebergClass remoteTypeSelector: #httpsUrl ]
]
