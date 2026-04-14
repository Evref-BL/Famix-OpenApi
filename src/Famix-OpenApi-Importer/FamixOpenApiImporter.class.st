Class {
	#name : 'FamixOpenApiImporter',
	#superclass : 'Object',
	#instVars : [
		'model',
		'visitor'
	],
	#category : 'Famix-OpenApi-Importer',
	#package : 'Famix-OpenApi-Importer'
}

{ #category : 'private - model' }
FamixOpenApiImporter >> generatedClassNamed: anEntityName [
	| generatedClassName |
	generatedClassName := (FamixOpenApiGenerator prefix asString , anEntityName asString) asSymbol.
	^ Smalltalk globals
		at: generatedClassName
		ifAbsent: [ self error: 'Missing generated class: ', generatedClassName asString ]
]

{ #category : 'importing' }
FamixOpenApiImporter >> importApiFromJsonString: aJsonString [
	| apiClass |
	self modelFromJsonString: aJsonString.
	apiClass := self generatedClassNamed: #Api.
	^ (model allWithType: apiClass)
		ifEmpty: [ nil ]
		ifNotEmpty: [ :apis | apis first ]
]

{ #category : 'initialization' }
FamixOpenApiImporter >> initialize [
	super initialize.
	visitor := FamixOpenApiJsonVisitor new
]

{ #category : 'accessing' }
FamixOpenApiImporter >> model [
	^ model
]

{ #category : 'accessing' }
FamixOpenApiImporter >> model: aModelInstance [
	model := aModelInstance
]

{ #category : 'importing' }
FamixOpenApiImporter >> modelFromJsonFile: aPathOrFileReference [
	model := visitor modelFromJsonFile: aPathOrFileReference.
	^ model
]

{ #category : 'importing' }
FamixOpenApiImporter >> modelFromJsonString: aJsonString [
	model := visitor modelFromJsonString: aJsonString.
	^ model
]

{ #category : 'accessing' }
FamixOpenApiImporter >> visitor [
	^ visitor
]

{ #category : 'accessing' }
FamixOpenApiImporter >> visitor: aVisitor [
	visitor := aVisitor
]
