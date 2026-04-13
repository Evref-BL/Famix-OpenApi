Class {
	#name : #BaselineOfFamixOpenApi,
	#superclass : #BaselineOf,
	#package : 'BaselineOfFamixOpenApi'
}

{ #category : 'baselines' }
BaselineOfFamixOpenApi >> baseline: spec [
	<baseline>
	spec for: #common do: [

		self defineGroups: spec.
		self defineDependencies: spec.
		self definePackages: spec.

		



	]
]



{ #category : #baselines }
BaselineOfGitLabHealth >> customProjectAttributes [
    self class environment at: #MooseEntity ifAbsent: [ ^ #(#WithoutFamix) ].

    ^ #()
]

{ #category : #baselines }
BaselineOfGitLabHealth >> defineGroups: spec [
		spec group: 'default' with: #('FamixOpenApiGenerator')

]

{ #category : #baselines }
BaselineOfGitLabHealth >> defineDependencies: spec [
	spec for: #( #WithoutFamix ) do: [
			spec
				baseline: 'Moose'
				with: [
				spec repository: 'github://moosetechnology/Moose:development/src' ].
			spec package: 'FamixOpenApiGenerator' with: [ spec requires: #( 'Moose' ) ]
		]
]


{ #category : #baselines }
BaselineOfGitLabHealth >> definePackages: spec [
	"generic"
	"spec package: 'FamixOpenApi'."


]

