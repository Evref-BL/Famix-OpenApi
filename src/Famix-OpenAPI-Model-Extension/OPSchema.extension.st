Extension { #name : 'OPSchema' }

{ #category : '*Famix-OpenAPI-Model-Extension' }
OPSchema >> additonalProperties [
	"Deprecated alias (typo) of #additionalProperties, kept for one cycle."

	^ self additionalProperties
]

{ #category : '*Famix-OpenAPI-Model-Extension' }
OPSchema >> additonalProperties: aSchema [
	"Deprecated alias (typo) of #additionalProperties:, kept for one cycle."

	self additionalProperties: aSchema
]

{ #category : '*Famix-OpenAPI-Model-Extension' }
OPSchema >> additonalPropertiesAllowed [
	"Deprecated alias (typo) of #additionalPropertiesAllowed, kept for one cycle."

	^ self additionalPropertiesAllowed
]

{ #category : '*Famix-OpenAPI-Model-Extension' }
OPSchema >> additonalPropertiesAllowed: aBoolean [
	"Deprecated alias (typo) of #additionalPropertiesAllowed:, kept for one cycle."

	self additionalPropertiesAllowed: aBoolean
]

{ #category : '*Famix-OpenAPI-Model-Extension' }
OPSchema >> allProperties [
	"Answer the properties of the receiver followed by the ones inherited from its allOf members, recursively. A property of the receiver hides an inherited one with the same name. Cycles through allOf are followed only once."

	| result |
	result := OrderedCollection new.
	self collectAllPropertiesInto: result visited: IdentitySet new.
	^ result
]

{ #category : '*Famix-OpenAPI-Model-Extension' }
OPSchema >> collectAllPropertiesInto: aCollection visited: visitedSchemas [

	(visitedSchemas includes: self) ifTrue: [ ^ self ].
	visitedSchemas add: self.
	self properties do: [ :each |
		aCollection
			detect: [ :known | known name = each name ]
			ifNone: [ aCollection add: each ] ].
	self allOf do: [ :each |
		each collectAllPropertiesInto: aCollection visited: visitedSchemas ]
]
