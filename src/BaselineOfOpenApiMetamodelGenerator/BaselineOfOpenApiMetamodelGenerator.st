Class {
	#name : #BaselineOfOpenApiMetamodelGenerator,
	#superclass : #BaselineOf,
	#package : 'BaselineOfOpenApiMetamodelGenerator'
}

{ #category : 'baselines' }
BaselineOfOpenApiMetamodelGenerator >> baseline: spec [
	<baseline>
	spec for: #common do: [
		spec baseline: 'Moose' with: [
			spec repository: 'github://moosetechnology/Moose:v7.x.x/src' ].
		spec package: 'OpenAPI2ModelGenerator' with: [
			spec requires: #('Moose') ].
		spec package: 'OpenApiMetamodelGenerator'.
		spec group: 'default' with: #('OpenAPI2ModelGenerator' 'OpenApiMetamodelGenerator')
	]
]
