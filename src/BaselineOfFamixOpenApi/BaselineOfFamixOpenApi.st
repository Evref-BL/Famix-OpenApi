Class {
	#name : #BaselineOfFamixOpenApi,
	#superclass : #BaselineOf,
	#package : 'BaselineOfFamixOpenApi'
}

{ #category : 'baselines' }
BaselineOfFamixOpenApi >> baseline: spec [
	<baseline>
	spec for: #common do: [

		self defineDependencies: spec.
		self definePackages: spec.
		self defineGroups: spec.
	]
]



{ #category : #baselines }
BaselineOfFamixOpenApi >> customProjectAttributes [
    self class environment at: #MooseEntity ifAbsent: [ ^ #(#WithoutFamix) ].
    ^ #()
]

{ #category : #baselines }
BaselineOfFamixOpenApi >> defineGroups: spec [
		"spec group: 'default' with: #('FamixOpenApiGenerator')"
]

{ #category : #baselines }
BaselineOfFamixOpenApi >> defineDependencies: spec [
	spec for: #( #WithoutFamix ) do: [
			spec
				baseline: 'Moose'
				with: [
				spec repository: 'github://moosetechnology/Moose:development/src' ].
			spec package: 'FamixOpenApiGenerator' with: [ spec requires: #( 'Moose' ) ]
		]
]


{ #category : #baselines }
BaselineOfFamixOpenApi >> definePackages: spec [
	"generic"
	"spec package: 'FamixOpenApi'."


]

